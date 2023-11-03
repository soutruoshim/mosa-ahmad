import 'package:flutter_news_app/ads/AdHelper.dart';
import 'package:flutter/material.dart';
import 'package:wortise/banner_ad.dart';
import 'package:wortise/ad_size.dart';

class BannerWortise extends StatefulWidget {
  const BannerWortise({super.key});

  @override
  State<BannerWortise> createState() => _BannerWortiseState();
}

class _BannerWortiseState extends State<BannerWortise> {
  BannerAd? bannerAd;
  bool isLoaded = false;

  // final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState() {
    super.initState();
    // loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BannerAd(
        adSize: AdSize.HEIGHT_50,
        adUnitId: AdHelper.bannerAdId,
      ),
    );
  }

  // void loadAd() {
  //   bannerAd = BannerAd(
  //     adSize: AdSize.HEIGHT_50,
  //     adUnitId: 'test-banner',
  //     listener: (event, args) {
  //       print('wortise bbbb');
  //       switch (event) {
  //         case BannerAdEvent.CLICKED:
  //           {
  //             // The banner has been clicked
  //           }
  //           break;

  //         case BannerAdEvent.FAILED:
  //           {
  //             print('aaa wortise banner failed');
  //             setState(() {
  //               isLoaded = false;
  //             });
  //           }
  //           break;

  //         case BannerAdEvent.LOADED:
  //           {
  //             print('aaa wortise banner loaded');
  //             setState(() {
  //               isLoaded = true;
  //             });
  //           }
  //           break;
  //       }
  //     },
  //   );
  // }
}
