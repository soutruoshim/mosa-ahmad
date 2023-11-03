import 'dart:io';

import 'package:flutter_news_app/utils/constants.dart';

class AdHelper {
  static String get bannerAdId {
    // if (Platform.isAndroid) {
    //   return Constants.bannerAdId;
    // } else if (Platform.isIOS) {
    //   return Constants.bannerAdId;
    // } else {
    //   return '';
    // }
    return Constants.bannerAdId;
  }

  static String get interAdId {
    // if (Platform.isAndroid) {
    //   return Constants.interAdId;
    // } else if (Platform.isIOS) {
    //   return Constants.interAdId;
    // } else {
    //   return '';
    // }
    return Constants.interAdId;
  }

  static String get nativeAdId {
    // if (Platform.isAndroid) {
    //   return Constants.nativeAdId;
    // } else if (Platform.isIOS) {
    //   return Constants.nativeAdId;
    // } else {
    //   return '';
    // }
    return Constants.nativeAdId;
  }
}
