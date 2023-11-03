import 'package:flutter_news_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late final SharedPreferences prefs;

  static Future<SharedPreferences> init() async => prefs = await SharedPreferences.getInstance();

  static const String TAG_INTRO = 'intro',
      TAG_CAT_SELECT = 'cat_select',
      TAG_SELECTED_CAT_IDS = 'selected_cat',
      TAG_LOGIN_TYPE = 'login_type',
      TAG_SOCIAL_ID = 'social_id',
      TAG_USER_ID = 'user_id',
      TAG_USER_NAME = 'user_name',
      TAG_USER_EMAIL = 'user_email',
      TAG_USER_PHONE = 'user_phone',
      TAG_USER_IMAGE = 'user_image',
      TAG_USER_PASSWORD = 'user_password',
      TAG_IS_LOGGED = 'isloged',
      TAG_IS_REMEMBER = 'isremember',
      TAG_IS_REPORTER = 'isreporter',
      TAG_IS_DARK_MODE = 'isdarkmode',
      TAG_IS_LIVE_TV = 'islivetv',
      TAG_APPLE_ID = 'ap_id',
      TAG_APPLE_NAME = 'ap_name',
      TAG_APPLE_EMAIL = 'ap_email',
      TAG_DEVICE_TYPE = 'mobile_tablet';

  static setIntroShown(bool isShown) {
    prefs.setBool(TAG_INTRO, isShown);
  }

  static bool getIntroShown() {
    return prefs.getBool(TAG_INTRO) ?? false;
  }

  static setSelectCatShown(bool isShown) {
    prefs.setBool(TAG_CAT_SELECT, isShown);
  }

  static bool getSelectCatShown() {
    return prefs.getBool(TAG_CAT_SELECT) ?? false;
  }

  static setIsLogged(bool isLogged) {
    prefs.setBool(TAG_IS_LOGGED, isLogged);
  }

  static bool isLogged() {
    return prefs.getBool(TAG_IS_LOGGED) ?? false;
  }

  static setIsDarkMode(bool isDarkMode) {
    prefs.setBool(TAG_IS_DARK_MODE, isDarkMode);
  }

  static bool isDarkMode() {
    return prefs.getBool(TAG_IS_DARK_MODE) ?? false;
  }

  static String getLoginType() {
    return prefs.getString(TAG_LOGIN_TYPE) ?? Constants.LOGIN_TYPE_NORMAL;
  }

  static setUserInfo(int userID, userName, userEmail, userPhone, userImage, socialID, loginType, bool isReporter) {
    prefs.setInt(TAG_USER_ID, userID);
    prefs.setString(TAG_USER_NAME, userName);
    prefs.setString(TAG_USER_EMAIL, userEmail);
    prefs.setString(TAG_USER_PHONE, userPhone);
    prefs.setString(TAG_USER_IMAGE, userImage);
    prefs.setString(TAG_SOCIAL_ID, socialID);
    prefs.setString(TAG_LOGIN_TYPE, loginType);
    prefs.setBool(TAG_IS_REPORTER, isReporter);
  }

  static int getUserID() {
    return prefs.getInt(TAG_USER_ID) ?? 0;
  }

  static String getSocialID() {
    return prefs.getString(TAG_SOCIAL_ID) ?? '';
  }

  static String getUserName() {
    return prefs.getString(TAG_USER_NAME) ?? '';
  }

  static String getUserEmail() {
    return prefs.getString(TAG_USER_EMAIL) ?? '';
  }

  static String getUserPhone() {
    return prefs.getString(TAG_USER_PHONE) ?? '';
  }

  static String getUserImage() {
    return prefs.getString(TAG_USER_IMAGE) ?? '';
  }

  static setUserPassword(String password) {
    prefs.setString(TAG_USER_PASSWORD, password);
  }

  static String getUserPassword() {
    return prefs.getString(TAG_USER_PASSWORD) ?? '';
  }

  static bool isReporter() {
    return prefs.getBool(TAG_IS_REPORTER) ?? false;
  }

  static setIsRemember(bool isRemember) {
    prefs.setBool(TAG_IS_REMEMBER, isRemember);
  }

  static bool isRemember() {
    return prefs.getBool(TAG_IS_REMEMBER) ?? false;
  }

  static setSelectedCatIDs(List<String> catIDs) {
    prefs.setString(TAG_SELECTED_CAT_IDS, catIDs.join(','));
  }

  static String getSelectedCatIDs() {
    return prefs.getString(TAG_SELECTED_CAT_IDS) ?? '';
  }

  static setIsLiveTV(bool isLiveTV) {
    prefs.setBool(TAG_IS_LIVE_TV, isLiveTV);
  }

  static bool isLiveTV() {
    return prefs.getBool(TAG_IS_LIVE_TV) ?? false;
  }

  static String getAppleID() {
    return prefs.getString(TAG_APPLE_ID) ?? '';
  }

  static setAppleID(String apple_id) {
    prefs.setString(TAG_APPLE_ID, apple_id);
  }

  static String getAppleName() {
    return prefs.getString(TAG_APPLE_NAME) ?? '';
  }

  static setAppleName(String apple_name) {
    prefs.setString(TAG_APPLE_NAME, apple_name);
  }

  static String getAppleEmail() {
    return prefs.getString(TAG_APPLE_EMAIL) ?? '';
  }

  static setAppleEmail(String apple_email) {
    prefs.setString(TAG_APPLE_EMAIL, apple_email);
  }

  static String getDeviceType() {
    return prefs.getString(TAG_DEVICE_TYPE) ?? '';
  }

  static setDeviceType(String mobile_tablet) {
    prefs.setString(TAG_DEVICE_TYPE, mobile_tablet);
  }
}
