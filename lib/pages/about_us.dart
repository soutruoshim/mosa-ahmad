import 'package:flutter_news_app/utils/methods.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/appbar_model.dart';
import '../resources/colors.dart';
import '../resources/images.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    super.initState();
  }

  double webViewHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarCustom(appBarTitle: Strings.about_us, isSettings: false),
        body: SingleChildScrollView(
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 17),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          width: 40,
                          height: 40,
                          imageUrl: Constants.itemAppDetails!.appLogo!,
                          errorWidget: (context, url, error) => Image.asset('images/app_logo.png'),
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Text(
                            Constants.itemAppDetails!.appName!,
                            style: TextStyle(
                              color: !SharedPref.isDarkMode() ? ColorsApp.text_about_appname : ColorsApp.text_about_appname_dark,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                getCardDesign(Images.ic_about, Strings.app_version, Constants.itemAppDetails!.appVersion!),
                SizedBox(height: 10),
                getCardDesign(Images.ic_company, Strings.company, Constants.itemAppDetails!.appCompany!),
                SizedBox(height: 10),
                getCardDesign(Images.ic_email, Strings.email_address, Constants.itemAppDetails!.appEmail!),
                SizedBox(height: 10),
                getCardDesign(Images.ic_website, Strings.website, Constants.itemAppDetails!.appWebsite!),
                SizedBox(height: 10),
                getCardDesign(Images.ic_contacts, Strings.contact_us, Constants.itemAppDetails!.appContact!),
                SizedBox(height: 10),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 10),
                          child: Text(
                            Strings.about_us,
                            style: TextStyle(
                              color: !SharedPref.isDarkMode() ? ColorsApp.text_about_appname : ColorsApp.text_about_appname_dark,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Html(data: Constants.itemAppDetails!.appAboutUs!),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {Factory(() => EagerGestureRecognizer())};

getCardDesign(String imageUrl, String title, String value) {
  return Card(
    child: Container(
      height: 70,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: ColorsApp.bg_icons_settings,
              shape: BoxShape.circle,
            ),
            width: 35,
            height: 35,
            child: Image(image: AssetImage(imageUrl)),
          ),
          SizedBox(width: 15),
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              title,
              style: TextStyle(
                color: !SharedPref.isDarkMode() ? ColorsApp.text_about_appname : ColorsApp.text_about_appname_dark,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(color: ColorsApp.bg_text_about_us, borderRadius: BorderRadius.circular(20)),
              child: Text(
                value,
                style: TextStyle(
                  color: !SharedPref.isDarkMode() ? ColorsApp.text_about_appname : ColorsApp.text_about_appname_dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ])
        ],
      ),
    ),
  );
}
