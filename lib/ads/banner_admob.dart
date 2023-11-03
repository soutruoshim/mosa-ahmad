import 'package:flutter_news_app/ads/AdHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdmob extends StatefulWidget {
  const BannerAdmob({super.key});

  @override
  State<BannerAdmob> createState() => _BannerAdmobState();
}

class _BannerAdmobState extends State<BannerAdmob> {
  BannerAd? bannerAd;
  bool isLoaded = false;

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Container(
            height: bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: bannerAd!),
          )
        : Container();
  }

  void loadAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          // debugPrint('BannerAd failed to load: $error');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }
}
