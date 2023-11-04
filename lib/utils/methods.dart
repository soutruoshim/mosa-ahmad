import 'dart:io';
import 'dart:math';

import 'package:flutter_news_app/resources/images.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_news_app/ads/interstitial_wortise.dart';
import 'package:flutter_news_app/pages/live_tv.dart';
import 'package:flutter_news_app/pages/login.dart';
import 'package:flutter_news_app/pages/news_by_search.dart';
import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wortise/wortise_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/interstitial_admob.dart';
import '../apiservice/apiclient.dart';
import '../items/itemAppDetails.dart';
import '../pages/categories_select.dart';
import '../pages/dashboard.dart';
import '../pages/intro.dart';
import '../pages/settings.dart';
import '../resources/strings.dart';
import 'auth_google.dart';
import 'constants.dart';

class Methods {
  static showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static getEditTextInputDecoration(label) {
    return InputDecoration(
      filled: true,
      label: Text(label),
      alignLabelWithHint: true,
      hintText: label != Strings.add_tags ? '' : Strings.comma_separed_tags,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: 1.5,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  static getEditTextInputSearch(context, TextEditingController textInpControllerSearch, bool isFromSearch, Function search) {
    return TextField(
      controller: textInpControllerSearch,
      textInputAction: TextInputAction.search,
      style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
      onSubmitted: (value) {
        if (!isFromSearch) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewsBySearch(searchText: textInpControllerSearch.text.toString());
          }));
        } else {
          search.call();
        }
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        hintText: Strings.search_here,
      ),
    );
  }

  static getInputSearchCategories(context, TextEditingController textInpControllerSearch, Function search) {
    return TextField(
      controller: textInpControllerSearch,
      style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
      textInputAction: TextInputAction.search,
      onChanged: (value) => search.call(value),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        hintText: Strings.search_here,
      ),
    );
  }

  static SizedBox getHorizontalGreyLine(double height) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: !SharedPref.isDarkMode() ? ColorsApp.line_vertical_grey : ColorsApp.line_vertical_grey_dark,
              borderRadius: BorderRadius.circular(20))),
    );
  }

  static SizedBox getHorizontalLine(double height, Color color) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20))),
    );
  }

  static getErrorEmpty(error) {
    return Center(child: Text(error));
  }

  static getAssetsIconWithPrimaryBG(image, double padding, double width, double height) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: ColorsApp.bg_icons_settings,
        shape: BoxShape.circle,
      ),
      width: width,
      height: height,
      child: Image(image: AssetImage(image)),
    );
  }

  static getAssetsWhiteIconWithBG(Color colors, image, double padding, double width, double height) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: colors,
        shape: BoxShape.circle,
      ),
      width: width,
      height: height,
      child: Image(
        image: AssetImage(image),
        color: Colors.white,
      ),
    );
  }

  static getAssetsIconWithBG(Color colors, image, double padding, double width, double height) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: colors,
        shape: BoxShape.circle,
      ),
      width: width,
      height: height,
      child: Image(
        image: AssetImage(image),
      ),
    );
  }

  static openDashBoardPage(context) {
    if (SharedPref.getSelectCatShown()) {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      //   return Dashboard();
      // }));

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
        return Dashboard();
      }), (route) => false);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return SelectCategories(fromApp: false);
      }));
    }
  }

  static logout(context, bool isFromApp) async {
    if (SharedPref.getLoginType() == Constants.LOGIN_TYPE_GOOGLE) {
      AuthGoogle.signOut(context: context);
    }
    SharedPref.setUserInfo(0, '', '', '', 'null', '', Constants.LOGIN_TYPE_NORMAL, false);
    SharedPref.setIsLogged(false);
    Methods.openLoginPage(context, isFromApp);
  }

  static openLoginPage(context, bool isFromApp) {
    if (isFromApp) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Login(isFromApp: isFromApp);
      }));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return Login(isFromApp: isFromApp);
      }));
    }
  }

  static getPageBgBoxDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(!SharedPref.isDarkMode() ? Images.bg_login : Images.bg_login_dark),
        fit: BoxFit.fill,
      ),
    );
  }

  static Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      print("internet  available");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      print("internet  available");
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am connected to a wifi network.
      print("internet not available");
      return false;
    } else {
      print("internet not available");
      return false;
    }
  }

  static void initAds() {
    if (Constants.adType == Constants.AD_TYPE_ADMOB) {
      MobileAds.instance.initialize();
    } else if (Constants.adType == Constants.AD_TYPE_WORTISE) {
      WortiseSdk.initialize(Constants.wortiseAppID);
    }

    if (Constants.adType == Constants.AD_TYPE_ADMOB) {
      AdManagerInterAdmob adManagerInterAdmob = new AdManagerInterAdmob();
      adManagerInterAdmob.createAd();
    } else if (Constants.adType == Constants.AD_TYPE_WORTISE) {
      AdManagerInterWortise adManagerInterWortise = new AdManagerInterWortise();
      adManagerInterWortise.createAd();
    }
  }

  static showInterAd({required Function onAdDissmissed}) {
    if (Constants.isInterAd) {
      Constants.adCount = Constants.adCount + 1;
      if (Constants.adCount % Constants.interAdPos == 0) {
        if (Constants.adType == Constants.AD_TYPE_ADMOB) {
          AdManagerInterAdmob adManagerInterAdmob = new AdManagerInterAdmob();
          if (adManagerInterAdmob.getAd() != null) {
            adManagerInterAdmob.getAd()!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                AdManagerInterAdmob.setAd(null);
                adManagerInterAdmob.createAd();
                onAdDissmissed.call();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                AdManagerInterAdmob.setAd(null);
                adManagerInterAdmob.createAd();
                onAdDissmissed.call();
              },
            );
            adManagerInterAdmob.getAd()!.show();
          } else {
            AdManagerInterAdmob.setAd(null);
            adManagerInterAdmob.createAd();
            onAdDissmissed.call();
          }
        } else if (Constants.adType == Constants.AD_TYPE_WORTISE) {
          AdManagerInterWortise adManagerInterWortise = new AdManagerInterWortise();
          if (adManagerInterWortise.getAd() != null && AdManagerInterWortise.isAdLoaded) {
            adManagerInterWortise.showAd(() {
              AdManagerInterAdmob.setAd(null);
              adManagerInterWortise.createAd();
              onAdDissmissed.call();
            });
          } else {
            AdManagerInterAdmob.setAd(null);
            adManagerInterWortise.createAd();
            onAdDissmissed.call();
          }
        }
      } else {
        onAdDissmissed.call();
      }
    } else {
      onAdDissmissed.call();
    }
  }

  static showLoaderDialog(BuildContext context, String messsage) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Container(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator( color: Colors.cyan,
              strokeWidth: 3,),
            SizedBox(height: 20),
            Center(child: Text(messsage)),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static loadUpdateDialog(context, dialogSubText, bool isCancel, bool? isIntroShown, bool isFromSplash, String url) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      isDismissible: isCancel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return Wrap(children: [
          Container(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 35,
                      height: 4,
                      child: DecoratedBox(decoration: BoxDecoration(color: ColorsApp.line_vertical_grey_80, borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      Strings.app_update,
                      style: TextStyle(
                        color: ColorsApp.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 2,
                      child: DecoratedBox(decoration: BoxDecoration(color: ColorsApp.line_vertical_grey, borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      dialogSubText,
                      style: TextStyle(
                        color: ColorsApp.text_dialog_title,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (isCancel)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                if (isFromSplash) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        if (isIntroShown != null && isIntroShown) {
                                          return Dashboard();
                                        } else {
                                          SharedPref.setIntroShown(true);
                                          return IntroScreen();
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  Strings.cancel,
                                  style: TextStyle(color: ColorsApp.primary, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: ColorsApp.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (isCancel)
                          SizedBox(
                            width: 25,
                          ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
                                throw Exception('Could not launch');
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(Strings.update, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsApp.primary,
                              shape: StadiumBorder(),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        ]);
      },
    );
  }

  static loadVerifyDialog(context, dialogTitle, dialogSubText, bool isCancel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return Wrap(children: [
          Container(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 35,
                      height: 4,
                      child: DecoratedBox(decoration: BoxDecoration(color: ColorsApp.line_vertical_grey_80, borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      dialogTitle,
                      style: TextStyle(
                        color: ColorsApp.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 2,
                      child: DecoratedBox(decoration: BoxDecoration(color: ColorsApp.line_vertical_grey, borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      dialogSubText,
                      style: TextStyle(
                        color: ColorsApp.text_dialog_title,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              exit(0);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(Strings.ok, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsApp.primary,
                              shape: StadiumBorder(),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        ]);
      },
    );
  }

  static Future<bool?> showAlertBottomDialog(context, String title, String message, String buttonFirstText, String buttonSecondText) {
    return showModalBottomSheet<bool>(
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(children: [
              Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 35,
                          height: 4,
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: !SharedPref.isDarkMode() ? ColorsApp.line_vertical_grey_80 : ColorsApp.line_vertical_grey_dark,
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            color: ColorsApp.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 1,
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: !SharedPref.isDarkMode() ? ColorsApp.line_vertical_grey_80 : ColorsApp.line_vertical_grey_dark,
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          message,
                          style: TextStyle(
                            color: !SharedPref.isDarkMode() ? ColorsApp.text_dialog_title : ColorsApp.text_title_dark,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(buttonFirstText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: ColorsApp.primary,
                                  side: BorderSide(color: ColorsApp.primary),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(buttonSecondText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsApp.primary,
                                  shape: StadiumBorder(),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ),
            ]),
          );
        });
  }

  static loadAppDetails(context, bool isCancel, bool isFromSplash, Function onFinish) async {
    bool isIntroShown = SharedPref.getIntroShown();

    if (await checkConnectivity()) {
      ItemAppDetails? itemAppDetails = await new ApiCLient().getAppDetails(Constants.METHOD_APP_DETAILS);

      if (itemAppDetails != null) {
        if (itemAppDetails.success == '1') {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          // if (packageInfo.packageName == itemAppDetails.packageName) {
          if (packageInfo.version == itemAppDetails.appVersionCode || itemAppDetails.showAppUpdate == 'false') {
            Constants.itemAppDetails = itemAppDetails;
            SharedPref.setIsLiveTV(itemAppDetails.isLiveTv!);

            for (var itemPage in itemAppDetails.arrayListPages) {
              if (itemPage.pageId == 1) {
                Constants.itemAppDetails!.appAboutUs = itemPage.pageContent;
                break;
              }
            }
            for (var itemAds in itemAppDetails.arrayListAds) {
              if (Constants.itemAppDetails!.arrayListAds.length > 0) {
                Constants.adType = itemAds.adsName!;

                Constants.wortiseAppID = itemAds.adsInfo!.publisherId!;

                Constants.isBannerAd = itemAds.adsInfo!.bannerOnOff!;
                Constants.isInterAd = itemAds.adsInfo!.interstitialOnOff!;
                Constants.isNativeAd = itemAds.adsInfo!.nativeOnOff!;

                Constants.bannerAdId = itemAds.adsInfo!.bannerId!;
                Constants.interAdId = itemAds.adsInfo!.interstitialId!;
                Constants.nativeAdId = itemAds.adsInfo!.nativeId!;

                Constants.interAdPos = itemAds.adsInfo!.interstitialClicks!;
                Constants.nativeAdPos = itemAds.adsInfo!.nativePosition!;
              }

              initAds();
            }

            onFinish.call();
          } else {
            Methods.loadUpdateDialog(context, itemAppDetails.appUpdateDescription, itemAppDetails.appUpdateCancel == 'true', isIntroShown,
                isFromSplash, itemAppDetails.appUpdateLink!);
          }
          // } else {
          //   Methods.loadVerifyDialog(context, Strings.err_invalid_package_name, Strings.err_invalid_package_name, isCancel);
          // }
        } else {
          Methods.loadVerifyDialog(context, Strings.err_server, Strings.err_connecting_server, isCancel);
        }
      }
    } else {
      if (!isIntroShown) {
        Methods.loadVerifyDialog(context, Strings.err_server, Strings.err_internet_not_connected, false);
      } else {
        onFinish.call();
      }
    }
  }
}

// ignore: must_be_immutable
class CustomHideShowAppBar extends StatelessWidget {
  String title;

  CustomHideShowAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return new SliverAppBar(
      title: Text(title,
          style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle!.color,
            fontWeight: FontWeight.bold,
          )),
      elevation: 0,
      automaticallyImplyLeading: false,
      floating: false,
      snap: false,
      backgroundColor: Colors.transparent,
      actions: [
        if (SharedPref.isLiveTV())
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
}

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator( color: Colors.cyan,
      strokeWidth: 3,));
  }
}

class CustomLazyLoadingProgressBar extends StatelessWidget {
  const CustomLazyLoadingProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10), child: Center(child: CircularProgressIndicator( color: Colors.cyan,
      strokeWidth: 3,)));
  }
}

fileFromImageUrl(String url) async {
  final response = await http.get(
    Uri.parse(url),
  );

  final directory = await getTemporaryDirectory();

  var randomNumber = Random().nextInt(10000);

  final path = directory.path;
  final file = File('$path/$randomNumber.png');
  file.writeAsBytes(response.bodyBytes);

  file.writeAsBytesSync(response.bodyBytes);

  return XFile(file.path);
}
