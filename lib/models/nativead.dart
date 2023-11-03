import 'package:flutter_news_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wortise/ad_widget.dart' as Wortise;

// ignore: must_be_immutable
class NativeAdsPage extends StatelessWidget {
  dynamic nativeAds;
  NativeAdsPage({super.key, required this.nativeAds});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
      child: Constants.adType == Constants.AD_TYPE_ADMOB ? AdWidget(ad: nativeAds, key: UniqueKey()) : Wortise.AdWidget(ad: nativeAds),
    );
  }
}
