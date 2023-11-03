import 'dart:io';

import 'package:flutter_news_app/items/itemNews.dart';
import 'package:flutter_news_app/pages/bottomsheet_report.dart';
import 'package:flutter_news_app/pages/dashboard.dart';
import 'package:flutter_news_app/pages/edit_news.dart';
import 'package:flutter_news_app/pages/live_tv.dart';
import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter_news_app/resources/images.dart';
import 'package:flutter_news_app/resources/strings.dart';
import 'package:flutter_news_app/utils/methods.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../pages/settings.dart';

// ignore: must_be_immutable
class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  bool? isSettings = false, isFromNotification;
  AppBarCustom({required this.appBarTitle, this.isSettings, this.isFromNotification});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: (isFromNotification != null && isFromNotification!)
          ? GestureDetector(
              child: Icon(
                Icons.arrow_back_rounded,
                color: SharedPref.isDarkMode() ? Colors.white : Colors.black,
              ),
              onTap: () {
                if (!isFromNotification!) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ),
                  );
                }
              },
            )
          : null,
      title: Text(this.appBarTitle,
          style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle!.color,
            fontWeight: FontWeight.bold,
          )),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        if (isSettings! && SharedPref.isLiveTV())
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 10, 0, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.actionsIconTheme!.color!,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Image.asset(Images.ic_live_tv, color: ColorsApp.primary),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LiveTV();
                  }))
                },
              ),
            ),
          ),
        if (isSettings!)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 10, 10, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.actionsIconTheme!.color!,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Image.asset(Images.ic_settings),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Settings();
                  }))
                },
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// ignore: must_be_immutable
class AppBarNewsDetails extends StatelessWidget implements PreferredSizeWidget {
  ItemNews itemNews;
  bool isNewsEdit = false, isFromNotification;
  Function onChanged;
  AppBarNewsDetails({required this.isNewsEdit, required this.itemNews, required this.onChanged, required this.isFromNotification});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        child: Icon(Icons.arrow_back_rounded),
        onTap: () {
          if (!isFromNotification) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Dashboard();
                },
              ),
            );
          }
        },
      ),
      title: Text('',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle!.color,
            fontWeight: FontWeight.bold,
          )),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                String shareMessage = '';
                if (Platform.isAndroid) {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  shareMessage = itemNews.title +
                      '\n' +
                      Strings.share_news_msg +
                      Strings.appName +
                      ' - https://play.google.com/store/apps/details?id=' +
                      packageInfo.packageName;
                } else if (Platform.isIOS) {
                  shareMessage = itemNews.title +
                      '\n' +
                      Strings.share_news_msg +
                      Strings.appName +
                      ' - https://apps.apple.com/us/app/whatsapp-messenger/id' +
                      '310633997';
                } else {
                  shareMessage = itemNews.title + '\n' + Strings.share_news_msg + Strings.appName;
                }
                final box = context.findRenderObject() as RenderBox?;

                XFile fileForShare = await fileFromImageUrl(itemNews.image);
                Share.shareXFiles(
                  [fileForShare],
                  text: shareMessage,
                  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                );
              },
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
                child: Methods.getAssetsIconWithBG(Theme.of(context).appBarTheme.actionsIconTheme!.color!, Images.ic_share, 10, 35.0, 35.0),
              ),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            onChanged.call(Strings.favourite);
          },
          child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
              child: Methods.getAssetsIconWithBG(
                  Theme.of(context).appBarTheme.actionsIconTheme!.color!, !itemNews.isFav ? Images.ic_fav : Images.ic_fav_hover, 12, 35.0, 35.0)),
        ),
        if (isNewsEdit)
          GestureDetector(
            onTap: () async {
              bool? isChanged = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditNews(itemNews: itemNews);
              }));
              if (isChanged != null) {
                onChanged.call(Strings.edit_news);
              }
            },
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
              child: Methods.getAssetsIconWithBG(Theme.of(context).appBarTheme.actionsIconTheme!.color!, Images.ic_edit, 10, 35.0, 35.0),
            ),
          ),
        GestureDetector(
          onTap: () async {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                builder: (context) {
                  return BottomSheetReport(
                    itemNews: itemNews,
                    itemComment: null,
                    reportType: 'News',
                    reportSubmit: () {
                      Navigator.pop(context);
                    },
                  );
                });
          },
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
            child: Methods.getAssetsIconWithBG(Theme.of(context).appBarTheme.actionsIconTheme!.color!, Images.ic_about, 10, 35.0, 35.0),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
