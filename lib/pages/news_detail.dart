import 'package:flutter_news_app/items/itemGallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/models/news_model.dart';
import 'package:flutter_news_app/pages/bottomsheet_comment.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_news_app/items/itemNews.dart';
import 'package:flutter_news_app/models/appbar_model.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/banner_admob.dart';
import '../ads/banner_wortise.dart';
import '../apiservice/apiclient.dart';
import '../items/itemSuccess.dart';
import '../models/comment_model.dart';
import '../models/tablet/news_model_tablet.dart';
import '../resources/colors.dart';
import '../resources/images.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';
import 'news_by_search.dart';

class NewsDetail extends StatefulWidget {
  final ItemNews itemNews;
  final bool isNewsEdit, isFromNotification;
  const NewsDetail({super.key, required this.itemNews, required this.isNewsEdit, required this.isFromNotification});

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  final textInpControllerComment = TextEditingController();
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;
  double aspectRatio = 1;
  bool isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    widget.itemNews.arrayListGallery.add(new ItemGallery(id: 0, image: widget.itemNews.image, imageFile: null));
    loadView();
    loadNewsDetails();
    loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarNewsDetails(
          isNewsEdit: widget.isNewsEdit,
          itemNews: widget.itemNews,
          isFromNotification: widget.isFromNotification,
          onChanged: (task) {
            if (task == Strings.edit_news) {
              widget.itemNews.arrayListGallery.clear();
              widget.itemNews.arrayListGallery.add(new ItemGallery(id: 0, image: widget.itemNews.image, imageFile: null));
              loadNewsDetails();
            } else if (task == Strings.favourite) {
              if (SharedPref.isLogged()) {
                loadDoFavourite();
              } else {
                Methods.showSnackBar(context, Strings.login_to_continue);
              }
            }
          },
        ),
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  widget.itemNews.newsType != 'Video'
                      ? CarouselSlider(
                          options: CarouselOptions(aspectRatio: 1.85, autoPlay: true, viewportFraction: 1.0),
                          items: widget.itemNews.arrayListGallery.map((e) {
                            return Builder(builder: (context) {
                              return Card(
                                  margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      width: double.infinity,
                                      imageUrl: e.image,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => Image.asset(
                                        Images.placeholder_news,
                                        fit: BoxFit.cover,
                                      ),
                                      placeholder: (context, url) => Image.asset(
                                        Images.placeholder_news,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ));
                            });
                          }).toList(),
                        )
                      : isVideoInitialized
                          ? VisibilityDetector(
                              key: Key('news_detail'),
                              onVisibilityChanged: (info) {
                                try {
                                  if (info.visibleFraction == 0) {
                                    chewieController.pause();
                                  }
                                } catch (e) {}
                              },
                              child: AspectRatio(aspectRatio: aspectRatio, child: Chewie(controller: chewieController)),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: CustomProgressBar(),
                            ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(32, 5, 6, 5),
                                  decoration: BoxDecoration(
                                      color: !SharedPref.isDarkMode() ? ColorsApp.bg_user_name : ColorsApp.bg_user_name_dark,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    widget.itemNews.userName,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 10, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 14,
                                  foregroundImage: NetworkImage(widget.itemNews.userImage),
                                  backgroundImage: AssetImage(Images.ic_profile),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).textTheme.bodyLarge!.backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.itemNews.categoryName,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            widget.itemNews.title,
                            style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18, fontWeight: FontWeight.w600, height: 1.3),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Theme.of(context).textTheme.bodyLarge!.backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.itemNews.date,
                                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                              decoration: BoxDecoration(color: ColorsApp.bg_no_comment, borderRadius: BorderRadius.circular(20)),
                              child: Row(children: [
                                Image(width: 15, height: 15, image: AssetImage(Images.ic_eye), color: ColorsApp.primary),
                                SizedBox(width: 5),
                                Text(
                                  widget.itemNews.totalViews,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                              decoration: BoxDecoration(color: ColorsApp.bg_no_comment, borderRadius: BorderRadius.circular(20)),
                              child: Row(children: [
                                Image(width: 15, height: 15, image: AssetImage(Images.ic_comment)),
                                SizedBox(width: 5),
                                Text(
                                  widget.itemNews.totalComment,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Html(
                          data: widget.itemNews.description,
                          style: {
                            "body": Style(margin: Margins.all(0), fontSize: FontSize.large),
                          },
                          onLinkTap: (url, attributes, element) {
                            _launchUrl(Uri.parse(url!));
                          },
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: widget.itemNews.tags
                                .split(',')
                                .map((tags) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return NewsBySearch(searchText: tags);
                                        }));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: !SharedPref.isDarkMode() ? ColorsApp.border_tags : ColorsApp.border_tags_dark,
                                            style: BorderStyle.solid,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: Text(
                                          '#' + tags,
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.bodyLarge!.color,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(children: [
                          Text(
                            Strings.comments,
                            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Expanded(child: SizedBox()),
                          TextButton(
                            onPressed: () {
                              showBottomDialog();
                            },
                            child: Text(
                              Strings.see_all,
                              style: TextStyle(color: ColorsApp.primary, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          )
                        ]),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: !SharedPref.isDarkMode() ? ColorsApp.border_comment : ColorsApp.border_comment_dark,
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(children: [
                            Row(
                              children: [
                                Text(
                                  Strings.comments,
                                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  widget.itemNews.totalComment,
                                  style: TextStyle(color: ColorsApp.primary, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                Expanded(child: SizedBox(width: 15)),
                                GestureDetector(
                                  onTap: () => showBottomDialog(),
                                  child: Image(
                                    width: 18,
                                    height: 18,
                                    image: AssetImage(Images.ic_comment_list),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Methods.getHorizontalGreyLine(1.5),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  foregroundImage: NetworkImage(SharedPref.getUserImage()),
                                  backgroundImage: AssetImage(Images.ic_profile),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => showBottomDialog(),
                                    child: TextField(
                                      enabled: false,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                        filled: true,
                                        fillColor: !SharedPref.isDarkMode() ? Colors.white : ColorsApp.bg_edit_text_dark,
                                        hintText: Strings.comments,
                                        isDense: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(50),
                                          borderSide: BorderSide(
                                            width: 1.5,
                                            color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(50),
                                          borderSide: BorderSide(
                                            width: 1.5,
                                            color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            if (widget.itemNews.arrayListComments.length > 0)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: widget.itemNews.arrayListComments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CommentModel(itemComments: widget.itemNews.arrayListComments[index]);
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 12,
                                ),
                              ),
                          ]),
                        ),
                        SizedBox(height: 10),
                        if (widget.itemNews.arrayListRelatedNews.length > 0)
                          Row(children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                Strings.related_news,
                                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            // TextButton(
                            //   onPressed: () {},
                            //   child: Text(
                            //     Strings.see_all,
                            //     style: TextStyle(color: ColorsApp.primary, fontSize: 14, fontWeight: FontWeight.w500),
                            //   ),
                            // )
                          ]),
                        SizedBox(height: 10),
                        if (widget.itemNews.arrayListRelatedNews.length > 0)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.itemNews.arrayListRelatedNews.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (SharedPref.getDeviceType() == 'mobile') {
                                return NewsModel(
                                    itemNews: widget.itemNews.arrayListRelatedNews[index], height: Constants.newsItemHeight, isNewsEdit: false);
                              } else {
                                return NewsModelTablet(
                                    itemNews: widget.itemNews.arrayListRelatedNews[index], height: Constants.newsItemHeight, isNewsEdit: false);
                              }
                            },
                          ),
                        SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Constants.adType == Constants.AD_TYPE_ADMOB ? BannerAdmob() : BannerWortise(),
          ),
        ]),
      ),
    );
  }

  loadNewsDetails() async {
    ItemNews? itemNews = await new ApiCLient().getNewsDetails(
      Constants.METHOD_NEWS_DETAILS,
      SharedPref.getUserID().toString(),
      widget.itemNews.id.toString(),
    );
    if (itemNews != null) {
      setState(() {
        widget.itemNews.title = itemNews.title;
        widget.itemNews.description = itemNews.description;
        widget.itemNews.date = itemNews.date;
        widget.itemNews.tags = itemNews.tags;
        widget.itemNews.image = itemNews.image;
        if (widget.itemNews.arrayListGallery[0].image == '') {
          widget.itemNews.arrayListGallery[0] = new ItemGallery(id: 0, image: itemNews.image, imageFile: null);
        }
        widget.itemNews.categoryName = itemNews.categoryName;
        widget.itemNews.userName = itemNews.userName;
        widget.itemNews.userImage = itemNews.userImage;
        widget.itemNews.videoType = itemNews.videoType;
        widget.itemNews.videoUrl = itemNews.videoUrl;
        widget.itemNews.newsType = itemNews.newsType;
        widget.itemNews.totalComment = itemNews.totalComment;
        widget.itemNews.totalViews = itemNews.totalViews;
        widget.itemNews.isFav = itemNews.isFav;
        widget.itemNews.arrayListComments = itemNews.arrayListComments;
        widget.itemNews.arrayListRelatedNews = itemNews.arrayListRelatedNews;
        widget.itemNews.arrayListGallery.addAll(itemNews.arrayListGallery);

        loadVideo();
      });
    }
  }

  showBottomDialog() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheetComment(itemNews: widget.itemNews);
        });
  }

  loadView() async {
    await new ApiCLient().getDoView(Constants.METHOD_DO_VIEW, widget.itemNews.id.toString(), 'News');
  }

  loadDoFavourite() async {
    ItemSuccess? itemSuccess =
        await new ApiCLient().getDoFav(Constants.METHOD_DO_FAVOURITE, widget.itemNews.id.toString(), 'News', SharedPref.getUserID().toString());

    if (itemSuccess != null) {
      setState(() {
        if (itemSuccess.success == 'true') {
          widget.itemNews.isFav = true;
        } else {
          widget.itemNews.isFav = false;
        }
      });
      Methods.showSnackBar(context, itemSuccess.message);
    }
  }

  void loadVideo() {
    if (widget.itemNews.newsType == 'Video' && !isVideoInitialized) {
      videoPlayerController = VideoPlayerController.network(widget.itemNews.videoUrl);
      videoPlayerController.initialize().then((value) {
        setState(() {
          aspectRatio = videoPlayerController.value.aspectRatio;

          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: false,
            aspectRatio: aspectRatio,
            deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          );
          isVideoInitialized = true;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.itemNews.newsType == 'Video') {
      chewieController.dispose();
      videoPlayerController.dispose();
    }
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}
