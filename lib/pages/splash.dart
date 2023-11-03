import 'dart:async';
import 'dart:io';

import 'package:flutter_news_app/items/itemNews.dart';
import 'package:flutter_news_app/pages/news_detail.dart';
import 'package:flutter_news_app/resources/images.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_news_app/pages/dashboard.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_news_app/pages/intro.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:flutter/material.dart';

import '../apiservice/apiclient.dart';
import '../items/itemUsers.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import 'news_by_cat.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isNotification = false;
  String postType = '', postID = '', postTitle = '', externalLink = 'false';

  @override
  void initState() {
    super.initState();

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult openedResult) {
      if (openedResult.notification.additionalData!['post_title'].toString() != '' ||
          openedResult.notification.additionalData!['external_link'].toString() != 'false') {
        isNotification = true;
        try {
          postID = openedResult.notification.additionalData!['post_id'].toString();
          postTitle = openedResult.notification.additionalData!['post_title'].toString();
          postType = openedResult.notification.additionalData!['type'].toString();
          externalLink = openedResult.notification.additionalData!['external_link'].toString();
        } catch (e) {
          print('error - ' + e.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadAppDetails(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(fit: BoxFit.fitWidth, !SharedPref.isDarkMode() ? Images.splash : Images.splash_dark),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          alignment: Alignment.bottomCenter,
          child: CircularProgressIndicator(
            color: Colors.red,
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }

  loadAppDetails(context) async {
    if (MediaQuery.of(context).size.width < 600) {
      SharedPref.setDeviceType('mobile');
      Constants.newsItemHeight = (MediaQuery.of(context).size.width - 20) / 2.6;
      Constants.newsItemHeightSmall = (MediaQuery.of(context).size.width - 20) / 3.9;
    } else {
      SharedPref.setDeviceType('tablet');
      Constants.newsItemHeight = (MediaQuery.of(context).size.width - 20) / 4;
      Constants.newsItemHeightSmall = (MediaQuery.of(context).size.width - 20) / 6;
    }
    Constants.deviceType = SharedPref.getDeviceType();
    // Constants.newsItemHeight = (MediaQuery.of(context).size.width - 20) / 2.6;
    bool isIntroShown = SharedPref.getIntroShown();

    if (!SharedPref.isLogged() || !isIntroShown) {
      Methods.loadAppDetails(context, true, true, () {
        setTime(context, isIntroShown);
      });
    } else {
      if (SharedPref.getLoginType() == Constants.LOGIN_TYPE_NORMAL) {
        loadLogin();
      } else if (SharedPref.getLoginType() == Constants.LOGIN_TYPE_GOOGLE) {
        loadSocial(Constants.LOGIN_TYPE_GOOGLE, SharedPref.getSocialID(), SharedPref.getUserName(), SharedPref.getUserEmail());
      }
    }
  }

  setTime(context, isIntroShown) async {
    Timer(
      Duration(seconds: 0),
      () async {
        if (externalLink == 'false') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                if (isIntroShown != null && isIntroShown) {
                  if (!isNotification) {
                    return Dashboard();
                  } else {
                    if (postType == 'news') {
                      return NewsDetail(
                        itemNews: new ItemNews(int.parse(postID), postTitle),
                        isNewsEdit: false,
                        isFromNotification: isNotification,
                      );
                    } else {
                      return NewsByCat(catID: postID, catName: postTitle, isFromNotification: isNotification);
                    }
                  }
                } else {
                  SharedPref.setIntroShown(true);
                  return IntroScreen();
                }
              },
            ),
          );
        } else {
          try {
            _launchUrl(Uri.parse(externalLink));
          } catch (e) {}
          // exit(0);
        }
      },
    );
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    } else {
      exit(0);
    }
  }

  loadLogin() async {
    SharedPref.getUserID().toString();
    ItemUser? itemUser = await new ApiCLient().getLogin(Constants.METHOD_LOGIN, SharedPref.getUserEmail().toString(), SharedPref.getUserPassword());

    if (itemUser != null) {
      if (itemUser.success == '1') {
        SharedPref.setUserInfo(itemUser.userID!, itemUser.userName, itemUser.userEmail, itemUser.userPhone, itemUser.userImage, '',
            Constants.LOGIN_TYPE_NORMAL, itemUser.isReporter);
        SharedPref.setIsLogged(true);
      } else {
        SharedPref.setIsLogged(false);
      }
    }

    setTime(context, true);
  }

  loadSocial(String loginType, String socialID, String name, String email) async {
    try {
      ItemUser? itemUser = await new ApiCLient().getSocialLogin(Constants.METHOD_SOCIAL_LOGIN, loginType, socialID, name, email);

      if (itemUser != null) {
        if (itemUser.success == '1') {
          SharedPref.setUserInfo(
              itemUser.userID!, itemUser.userName, itemUser.userEmail, itemUser.userPhone, itemUser.userImage, '', loginType, itemUser.isReporter);
          SharedPref.setIsLogged(true);
        } else {
          SharedPref.setIsLogged(false);
        }
      }

      setTime(context, true);
    } catch (e) {}
  }
}
