import 'dart:io';

class ItemAppDetails {
  bool? isLiveTv = false;
  String? packageName,
      appName,
      appEmail,
      appLogo,
      appCompany,
      appWebsite,
      appContact,
      appAboutUs,
      facebookLink,
      twitterLink,
      instagramLink,
      youtubeLink,
      showAppUpdate,
      appVersion,
      appVersionCode,
      appUpdateDescription,
      appUpdateLink,
      appUpdateCancel,
      success,
      message;
  List<ItemAds> arrayListAds = [];
  List<PageList> arrayListPages = [];

  ItemAppDetails(
      {this.packageName,
      this.appName,
      this.appEmail,
      this.appLogo,
      this.appCompany,
      this.appWebsite,
      this.appContact,
      this.facebookLink,
      this.twitterLink,
      this.instagramLink,
      this.youtubeLink,
      this.appVersion,
      this.showAppUpdate,
      this.appVersionCode,
      this.appUpdateDescription,
      this.appUpdateLink,
      this.appUpdateCancel,
      this.isLiveTv,
      required this.arrayListAds,
      required this.arrayListPages,
      this.success,
      this.message});

  ItemAppDetails.fromJson(Map<String, dynamic> json) {
    packageName = json['app_package_name'];
    appName = json['app_name'];
    appEmail = json['app_email'];
    appLogo = json['app_logo'];
    appCompany = json['app_company'];
    appWebsite = json['app_website'];
    appVersion = json['app_version'];
    appContact = json['app_contact'];
    facebookLink = json['facebook_link'];
    twitterLink = json['twitter_link'];
    instagramLink = json['instagram_link'];
    youtubeLink = json['youtube_link'];

    if (Platform.isAndroid) {
      showAppUpdate = json['app_update_hide_show'];
      appVersionCode = json['app_update_version_code'];
      appUpdateDescription = json['app_update_desc'];
      appUpdateLink = json['app_update_link'];
      appUpdateCancel = json['app_update_cancel_option'];
    } else if (Platform.isIOS) {
      showAppUpdate = json['ios_app_update_hide_show'];
      appVersionCode = json['ios_app_update_version_code'];
      appUpdateDescription = json['ios_app_update_desc'];
      appUpdateLink = json['ios_app_update_link'];
      appUpdateCancel = json['ios_app_update_cancel_option'];
    }
    isLiveTv = json['livetv_settings'] == 1;
    success = json['success'];
    message = json['message'];

    if (Platform.isAndroid) {
      if (json['ads_list'] != null) {
        arrayListAds = <ItemAds>[];
        json['ads_list'].forEach((v) {
          arrayListAds.add(new ItemAds.fromJson(v));
        });
      }
    } else if (Platform.isIOS) {
      if (json['ads_ios_list'] != null) {
        arrayListAds = <ItemAds>[];
        json['ads_ios_list'].forEach((v) {
          arrayListAds.add(new ItemAds.fromJson(v));
        });
      }
    }
    if (json['page_list'] != null) {
      arrayListPages = <PageList>[];
      json['page_list'].forEach((v) {
        arrayListPages.add(new PageList.fromJson(v));
      });
    }
  }
}

class ItemAds {
  int? adId;
  String? adsName;
  AdsInfo? adsInfo;
  String? status;

  ItemAds({this.adId, this.adsName, this.adsInfo, this.status});

  ItemAds.fromJson(Map<String, dynamic> json) {
    adId = json['ad_id'];
    adsName = json['ads_name'];
    adsInfo = json['ads_info'] != null ? new AdsInfo.fromJson(json['ads_info']) : null;
    status = json['status'];
  }
}

class AdsInfo {
  String? publisherId;
  bool? bannerOnOff;
  String? bannerId;
  bool? interstitialOnOff;
  String? interstitialId;
  int? interstitialClicks;
  bool? nativeOnOff;
  String? nativeId;
  int? nativePosition;

  AdsInfo(
      {this.publisherId,
      this.bannerOnOff,
      this.bannerId,
      this.interstitialOnOff,
      this.interstitialId,
      this.interstitialClicks,
      this.nativeOnOff,
      this.nativeId,
      this.nativePosition});

  AdsInfo.fromJson(Map<String, dynamic> json) {
    publisherId = json['publisher_id'];
    bannerOnOff = json['banner_on_off'] == '1';
    bannerId = json['banner_id'];
    interstitialOnOff = json['interstitial_on_off'] == '1';
    interstitialId = json['interstitial_id'];
    interstitialClicks = int.parse(json['interstitial_clicks']);
    nativeOnOff = json['native_on_off'] == '1';
    nativeId = json['native_id'];
    nativePosition = int.parse(json['native_position']);
  }
}

class PageList {
  int? pageId;
  String? pageTitle;
  String? pageContent;

  PageList({this.pageId, this.pageTitle, this.pageContent});

  PageList.fromJson(Map<String, dynamic> json) {
    pageId = json['page_id'];
    pageTitle = json['page_title'];
    pageContent = json['page_content'];
  }
}
