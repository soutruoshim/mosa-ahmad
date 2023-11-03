import 'package:flutter_news_app/ads/AdHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManagerInterAdmob {
  static InterstitialAd? _interstitialAd;

  void createAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interAdId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {},
      ),
    );
  }

  InterstitialAd? getAd() {
    return _interstitialAd;
  }

  static void setAd(InterstitialAd? interstitialAd) {
    _interstitialAd = interstitialAd;
  }
}
