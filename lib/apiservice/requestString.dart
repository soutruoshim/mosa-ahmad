import 'dart:convert';

import '../utils/constants.dart';
import 'apiencode.dart';

class RequestString {
  String? userID = '',
      userName = '',
      userEmail = '',
      userPhone = '',
      userPassword,
      postID,
      postType,
      catID,
      homeSectionID,
      comment,
      searchText,
      title,
      tags,
      date,
      videoType,
      description,
      videoUrl,
      galleryID,
      loginType,
      socialID;

  RequestString(
      {this.userID,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.userPassword,
      this.postID,
      this.postType,
      this.catID,
      this.homeSectionID,
      this.comment,
      this.searchText,
      this.title,
      this.tags,
      this.date,
      this.videoType,
      this.description,
      this.videoUrl,
      this.galleryID,
      this.loginType,
      this.socialID}) {}

  String getAPIRequest(method) {
    Map<String, String> mapObj = ApiEncode.getSignSalt();

    switch (method) {
      case Constants.METHOD_LOGIN:
        mapObj.addAll({
          "email": userEmail!,
          "password": userPassword!,
        });
        break;

      case Constants.METHOD_SOCIAL_LOGIN:
        mapObj.addAll({
          "login_type": loginType!,
          "email": userEmail!,
          "social_id": socialID!,
          "name": userName!,
        });
        break;

      case Constants.METHOD_REGISTER:
        mapObj.addAll({
          "name": userName!,
          "email": userEmail!,
          "password": userPassword!,
          "phone": userPhone!,
        });
        break;

      case Constants.METHOD_HOME:
        mapObj.addAll({
          "user_id": userID!,
          "user_selected_cats": catID!,
        });
        break;

      case Constants.METHOD_CATEGORIES:
        mapObj.addAll({
          "id": userID!,
        });
        break;

      case Constants.METHOD_FORGOT_PASSWORD:
        mapObj.addAll({
          "email": userEmail!,
        });
        break;

      case Constants.METHOD_PROFILE:
        mapObj.addAll({
          "user_id": userID!,
        });
        break;

      case Constants.METHOD_PROFILE_UPDATE:
        mapObj.addAll({
          "user_id": userID!,
          "name": userName!,
          "email": userEmail!,
          "password": userPassword!,
          "phone": userPhone!,
        });
        break;

      case Constants.METHOD_LATEST_NEWS:
        mapObj.addAll({
          "user_id": userID!,
          "user_selected_cats": catID!,
        });
        break;

      case Constants.METHOD_NEWS_BY_CAT:
        mapObj.addAll({
          "cat_id": catID!,
          "user_id": userID!,
        });
        break;

      case Constants.METHOD_NEWS_BY_TRENDING:
        mapObj.addAll({
          "user_selected_cats": catID!,
          "user_id": userID!,
        });
        break;

      case Constants.METHOD_NEWS_DETAILS:
        mapObj.addAll({
          "post_id": postID!,
          "user_id": userID!,
        });
        break;

      case Constants.METHOD_NEWS_BY_HOME_SECTION:
        mapObj.addAll({
          "id": homeSectionID!,
          "user_id": userID!,
        });
        break;

      case Constants.METHOD_NEWS_BY_SEARCH:
        mapObj.addAll({
          "user_id": userID!,
          "search_text": searchText!,
        });
        break;

      case Constants.METHOD_NEWS_BY_USER:
        mapObj.addAll({
          "user_id": userID!,
        });
        break;

      case Constants.METHOD_NEWS_BY_FAV:
        mapObj.addAll({
          "user_id": userID!,
        });
        break;

      case Constants.METHOD_DO_FAVOURITE:
        mapObj.addAll({
          "post_id": postID!,
          "post_type": postType!,
          "user_id": userID!,
        });
        break;

      case Constants.METHOD_DO_VIEW:
        mapObj.addAll({
          "post_id": postID!,
          "post_type": postType!,
        });
        break;

      case Constants.METHOD_COMMENT_LIST:
        mapObj.addAll({
          "post_id": postID!,
        });
        break;

      case Constants.METHOD_POST_COMMENT:
        mapObj.addAll({
          "user_id": userID!,
          "post_id": postID!,
          "comment_text": comment!,
        });
        break;

      case Constants.METHOD_UPLOAD_NEWS:
        mapObj.addAll({
          "user_id": userID!,
          "category": catID!,
          "type": postType!,
          "video_type": videoType!,
          "title": title!,
          "description": description!,
          "tags": tags!,
          "date": date!,
          "video_url": videoUrl!,
        });
        break;

      case Constants.METHOD_EDIT_NEWS:
        mapObj.addAll({
          "user_id": userID!,
          "news_id": postID!,
          "category": catID!,
          "type": postType!,
          "video_type": videoType!,
          "title": title!,
          "description": description!,
          "tags": tags!,
          "date": date!,
          "video_url": videoUrl!,
        });
        break;

      case Constants.METHOD_REMOVE_GALLERY_IMAGE:
        mapObj.addAll({
          "gallery_id": galleryID!,
        });
        break;

      case Constants.METHOD_REPORTER_REQUEST:
        mapObj.addAll({
          "user_id": userID!,
        });
        break;

      case Constants.METHOD_REPORTS:
        mapObj.addAll({
          "user_id": userID!,
          "post_id": postID!,
          "post_type": postType!,
          "message": searchText!,
        });
        break;

      case Constants.METHOD_DELETE_USER_ACCOUNT:
        mapObj.addAll({
          "user_id": userID!,
        });
        break;

      default:
    }

    print('aaa - ' + ApiEncode.generateBase64(jsonEncode(mapObj)));
    return ApiEncode.generateBase64(jsonEncode(mapObj));
  }
}
