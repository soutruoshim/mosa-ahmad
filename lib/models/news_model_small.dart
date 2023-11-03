import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/items/itemNews.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter/material.dart';

import '../apiservice/apiclient.dart';
import '../items/itemSuccess.dart';
import '../pages/news_detail.dart';
import '../resources/images.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';

// ignore: must_be_immutable
class NewsModelSmall extends StatefulWidget {
  final ItemNews itemNews;
  final bool isNewsEdit;
  var height;

  NewsModelSmall({required this.itemNews, required this.height, required this.isNewsEdit});

  @override
  State<NewsModelSmall> createState() => _NewsModelSmallState();
}

class _NewsModelSmallState extends State<NewsModelSmall> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          Methods.showInterAd(onAdDissmissed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NewsDetail(itemNews: widget.itemNews, isNewsEdit: widget.isNewsEdit, isFromNotification: false);
            }));
          });
        },
        child: Container(
          child: Row(
            children: [
              Container(
                width: widget.height,
                height: widget.height,
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(10), bottomStart: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(Images.placeholder_news_small, fit: BoxFit.cover),
                      imageUrl: widget.itemNews.image,
                      errorWidget: (context, url, error) => Image.asset(Images.placeholder_news_small, fit: BoxFit.cover),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: ColorsApp.primary_AA,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.itemNews.categoryName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: widget.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).textTheme.bodyLarge!.backgroundColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.itemNews.date,
                                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              GestureDetector(
                                onTap: () {
                                  if (SharedPref.isLogged()) {
                                    loadDoFavourite();
                                  } else {
                                    Methods.showSnackBar(context, Strings.login_to_continue);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 5, 0),
                                  child: Methods.getAssetsIconWithPrimaryBG(
                                      !widget.itemNews.isFav ? Images.ic_fav : Images.ic_fav_hover, 6.0, 25.0, 25.0),
                                ),
                              ),
                              Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final box = context.findRenderObject() as RenderBox?;

                                      XFile fileForShare = await fileFromImageUrl(widget.itemNews.image);
                                      Share.shareXFiles(
                                        [fileForShare],
                                        text: widget.itemNews.title + '\n' + Strings.appName,
                                        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 13, 0),
                                      child: Methods.getAssetsIconWithPrimaryBG(Images.ic_share, 6.0, 25.0, 25.0),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox(height: 5)),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(end: 8),
                              child: Text(
                                widget.itemNews.title,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox(height: 5)),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
