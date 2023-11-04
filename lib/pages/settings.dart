import 'dart:io' as DevicePlatform;

import 'package:flutter_news_app/main.dart';
import 'package:flutter_news_app/pages/categories_select.dart';
import 'package:flutter_news_app/pages/webview.dart';
import 'package:flutter_news_app/resources/strings.dart';
import 'package:flutter_news_app/utils/constants.dart';
import 'package:flutter_news_app/utils/methods.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../items/itemAppDetails.dart';
import '../models/appbar_model.dart';
import '../resources/colors.dart';
import '../resources/images.dart';
import 'about_us.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkMode = false, isDataFetched = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = SharedPref.isDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarCustom(appBarTitle: Strings.settings, isSettings: false),
        body: (Constants.itemAppDetails != null)
            ? getSettingPageDesign()
            : Container(
                child: FutureBuilder<ItemAppDetails?>(
                  future: loadAppDetails(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return const Center(child: Text('Something went wrong'));
                    return snapshot.hasData
                        ? getSettingPageDesign()
                        : !isDataFetched
                            ? Center(child: CircularProgressIndicator( color: Colors.cyan,
                      strokeWidth: 3,))
                            : const Center(child: Text('Something went wrong'));
                  },
                ),
              ),
      ),
    );
  }

  getSettingPageDesign() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Methods.getHorizontalGreyLine(1),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(children: [
                Methods.getAssetsIconWithPrimaryBG('images/icons/ic_theme.png', 8.0, 35, 35),
                SizedBox(width: 10),
                Text(
                  Strings.dark_mode,
                  style: TextStyle(
                    color: !SharedPref.isDarkMode() ? ColorsApp.text_bb : ColorsApp.text_title_dark,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: SizedBox(width: 10),
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (onChange) {
                    setState(() {
                      isDarkMode = !isDarkMode;
                      MyApp.of(context).changeTheme(isDarkMode);
                    });
                  },
                  activeColor: ColorsApp.primary,
                )
              ]),
            ),
            Methods.getHorizontalGreyLine(1),
            getMenuDesign(Strings.select_categories, Images.ic_more_app, '', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SelectCategories(fromApp: true);
              }));
            }),
            if (Constants.itemAppDetails!.arrayListPages.length > 0)
              ListView.builder(
                shrinkWrap: true,
                itemCount: Constants.itemAppDetails!.arrayListPages.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return getMenuDesign(Constants.itemAppDetails!.arrayListPages[index].pageTitle, '',
                      Constants.itemAppDetails!.arrayListPages[index].pageId.toString(), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      if (Constants.itemAppDetails!.arrayListPages[index].pageId == 1) {
                        return AboutUs();
                      } else {
                        return WebView(
                            pageName: Constants.itemAppDetails!.arrayListPages[index].pageTitle!,
                            htmlData: Constants.itemAppDetails!.arrayListPages[index].pageContent!);
                      }
                    }));
                  });
                },
              ),
            getMenuDesign(Strings.more_app, Images.ic_more_app, '', () {
              _launchUrl(Uri.parse(DevicePlatform.Platform.isAndroid ? Strings.moreAppUrlAndroid : Strings.moreAppUrliOS));
            }),
            getMenuDesign(Strings.rate_app, Images.ic_rate_app, '', () async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              _launchUrl(Uri.parse(DevicePlatform.Platform.isAndroid
                  ? 'https://play.google.com/store/apps/details?id=' + packageInfo.packageName
                  : "https://itunes.apple.com/app/id" + Strings.rateAppiOS));
            }),
            SharedPref.isLogged()
                ? getMenuDesign(Strings.logout, Images.ic_logout, '', () async {
                    bool? flag = await Methods.showAlertBottomDialog(context, Strings.logout, Strings.sure_logout, Strings.cancel, Strings.logout);
                    if (flag != null) {
                      if (flag) {
                        Methods.logout(context, false);
                      }
                    }
                  })
                : getMenuDesign(Strings.login, Images.ic_logout, '', () async {
                    Methods.openLoginPage(context, true);
                  }),
          ],
        ),
      ),
    );
  }

  getMenuDesign(title, String image, String pageID, Function onPress) {
    if (image == '') {
      if (pageID == '1') {
        image = Images.ic_about;
      } else if (pageID == '2') {
        image = Images.ic_terms;
      } else if (pageID == '3') {
        image = Images.ic_privacy_policy;
      } else if (pageID == '4') {
        image = Images.ic_terms;
      } else if (pageID == '4') {
        image = Images.ic_about;
      }
    }
    return Column(children: [
      InkWell(
        onTap: () {
          onPress.call();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 5),
          child: Row(children: [
            Methods.getAssetsIconWithPrimaryBG(image, 8.0, 35, 35),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: !SharedPref.isDarkMode() ? ColorsApp.text_bb : ColorsApp.text_title_dark,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: SizedBox(width: 10),
            ),
            Icon(
              size: 15,
              Icons.arrow_forward_ios_rounded,
              color: ColorsApp.primary,
            )
          ]),
        ),
      ),
      Methods.getHorizontalGreyLine(1),
    ]);
  }

  Future<ItemAppDetails?> loadAppDetails(context) async {
    await Methods.loadAppDetails(context, false, false, () {});
    return Constants.itemAppDetails;
  }
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $_url');
  }
}
