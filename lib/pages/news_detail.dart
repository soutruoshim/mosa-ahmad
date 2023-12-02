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
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    widget.itemNews.arrayListGallery.add(new ItemGallery(id: 0, image: widget.itemNews.image, imageFile: null));
    loadView();
    loadNewsDetails();
    loadVideo();
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }


  @override
  Widget build(BuildContext context) {
    String url = "${Constants.SERVER_URL_PAGE}${ widget.itemNews.id}";
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
  //       body: WebViewWidget(controller: _controller..loadHtmlString('''<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width, initial-scale=0.9"><style type="text/css">
  //   body { background: transparent; margin: 18; padding: 0;font-size:14px }}
  // </style></head><body>${widget.itemNews.description}</body>
  // </html>''')),
        body: WebViewWidget(controller: _controller..loadRequest(Uri.parse(url)))),
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
