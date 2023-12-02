import 'package:flutter_news_app/items/itemCategories.dart';

import '../items/itemAppDetails.dart';

class Constants {
  static const String SERVER_URL = 'https://mosa-ahmad.online/public/api/v1/';
  static const String SERVER_URL_PAGE = 'https://mosa-ahmad.online/news/';


  static const String METHOD_APP_DETAILS = 'app_details';

  static const String METHOD_LOGIN = 'login';
  static const String METHOD_SOCIAL_LOGIN = 'social_login';
  static const String METHOD_REGISTER = 'signup';
  static const String METHOD_FORGOT_PASSWORD = 'forgot_password';
  static const String METHOD_PROFILE = 'profile';
  static const String METHOD_PROFILE_UPDATE = 'profile_update';

  static const String METHOD_HOME = 'home';
  static const String METHOD_LATEST_NEWS = 'latest_news';
  static const String METHOD_NEWS_BY_CAT = 'category_wise_news';
  static const String METHOD_NEWS_BY_TRENDING = 'trending_news';
  static const String METHOD_NEWS_BY_HOME_SECTION = 'home_section';
  static const String METHOD_NEWS_BY_SEARCH = 'search_news';
  static const String METHOD_NEWS_BY_FAV = 'user_favourite_post_list';
  static const String METHOD_NEWS_BY_USER = 'user_news_list';
  static const String METHOD_CATEGORIES = 'category';
  static const String METHOD_LIVE_TV = 'livetv';

  static const String METHOD_NEWS_DETAILS = 'single_news';

  static const String METHOD_COMMENT_LIST = 'news_comment_list';
  static const String METHOD_DO_FAVOURITE = 'post_favourite';
  static const String METHOD_DO_VIEW = 'post_view';
  static const String METHOD_POST_COMMENT = 'user_comments';

  static const String METHOD_REPORTER_REQUEST = 'reporter_request';
  static const String METHOD_UPLOAD_NEWS = 'user_add_news';
  static const String METHOD_EDIT_NEWS = 'user_edit_news';
  static const String METHOD_REMOVE_GALLERY_IMAGE = 'user_news_gallery_delete';

  static const String METHOD_REPORTS = 'user_reports';
  static const String METHOD_DELETE_USER_ACCOUNT = 'delete_user_account';

  static const String LOGIN_TYPE_NORMAL = 'normal';
  static const String LOGIN_TYPE_GOOGLE = 'google';
  static const String LOGIN_TYPE_APPLE = 'apple';

  static const String AD_TYPE_ADMOB = 'Admob';
  static const String AD_TYPE_WORTISE = 'Wortise';

  static ItemAppDetails? itemAppDetails;
  static List<ItemCategories> arrayListCategories = [];
  // static ItemUser? itemUser;

  static bool isProfileLoaded = false, isBannerAd = true, isInterAd = true, isNativeAd = true;
  static String adType = AD_TYPE_ADMOB, wortiseAppID = '', bannerAdId = '', interAdId = '', nativeAdId = '';
  static int interAdPos = 3, nativeAdPos = 3, adCount = 0;
  static double newsItemHeight = 50.0, newsItemHeightSmall = 30;

  static String fontName = 'Inter', deviceType = '';
}
