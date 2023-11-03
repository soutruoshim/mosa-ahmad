import 'package:flutter_news_app/ads/AdHelper.dart';
import 'package:wortise/interstitial_ad.dart';

class AdManagerInterWortise {
  static InterstitialAd? _interstitialAd;
  static bool isAdLoaded = false;
  static late Function onAdDissmissed;

  void createAd() async {
    _interstitialAd = InterstitialAd(AdHelper.interAdId, (event, args) {
      if (event == InterstitialAdEvent.LOADED) {
        isAdLoaded = true;
      } else if (event == InterstitialAdEvent.FAILED) {
        isAdLoaded = false;
      } else if (event == InterstitialAdEvent.DISMISSED) {
        onAdDissmissed.call();
      }
    });
    await _interstitialAd?.loadAd();
  }

  InterstitialAd? getAd() {
    return _interstitialAd;
  }

  void showAd(Function onAdDissmissedFun) {
    onAdDissmissed = onAdDissmissedFun;
    _interstitialAd!.showAd();
  }

  static void setAd(InterstitialAd? interstitialAd) {
    _interstitialAd = interstitialAd;
  }
}
