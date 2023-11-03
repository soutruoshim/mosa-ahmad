import 'dart:convert';

import 'package:flutter_news_app/apiservice/requestString.dart';
import 'package:flutter_news_app/items/itemGallery.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_news_app/apiservice/jsonParser.dart';
import 'package:flutter_news_app/items/itemCategories.dart';
import 'package:flutter_news_app/items/itemLiveTV.dart';
import 'package:http/http.dart' as http;
import '../items/itemAppDetails.dart';
import '../items/itemComments.dart';
import '../items/itemHome.dart';
import '../items/itemNews.dart';
import '../items/itemSuccess.dart';
import '../items/itemUsers.dart';
import '../utils/constants.dart';

class ApiCLient {
  late RequestString requestString;
  http.Client client = http.Client();

  Future<ItemAppDetails?> getAppDetails(String method) async {
    requestString = new RequestString();
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );
    Map<String, dynamic> responseJson = json.decode(response.body.toString());

    return JsonParser.fromAppDetailsJson(responseJson).arrayListAppDetails?[0];
  }

  Future<ItemUser?> getLogin(String method, String email, String password) async {
    requestString = new RequestString(userEmail: email, userPassword: password);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromUserJson(responseJson).arrayListUser?[0];
  }

  Future<ItemUser?> getSocialLogin(String method, String loginType, String socialID, String name, String email) async {
    requestString = new RequestString(loginType: loginType, socialID: socialID, userName: name, userEmail: email);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromUserJson(responseJson).arrayListUser?[0];
  }

  Future<ItemSuccess?> getRegister(String method, String name, String email, String phone, String password) async {
    requestString = new RequestString(userName: name, userEmail: email, userPassword: password, userPhone: phone);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<ItemSuccess?> getForgotPassword(String method, String email) async {
    requestString = new RequestString(userEmail: email);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<ItemUser?> getProfile(String method, String userID) async {
    requestString = new RequestString(userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromUserJson(responseJson).arrayListUser?[0];
  }

  Future<ItemSuccess?> getProfileEdit(
      String method, String user_id, String name, String email, String phone, String password, String filePath) async {
    requestString = new RequestString(userID: user_id, userName: name, userEmail: email, userPassword: password, userPhone: phone);

    var request = http.MultipartRequest("POST", Uri.parse(Constants.SERVER_URL + method));
    request.fields['data'] = requestString.getAPIRequest(method);
    if (filePath != '') {
      var pic = await http.MultipartFile.fromPath("user_image", filePath);
      request.files.add(pic);
    }
    var requestSend = await request.send();
    var responseRaw = await requestSend.stream.toBytes();
    var response = String.fromCharCodes(responseRaw);

    Map<String, dynamic> responseJson = json.decode(response);
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<List<ItemCategories>?> getCategories(String method, String userID) async {
    requestString = new RequestString(userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromCategoryJson(responseJson).arrayListCategories;
  }

  Future<ItemHome?> getHome(String method, String userID, String catIds) async {
    requestString = new RequestString(userID: userID, catID: catIds);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromHomeJson(responseJson).itemHome;
  }

  // Future<List<ItemNews>?> getLatestNews(String method, String userID, String catIDs, int page) async {
  //   requestString = new RequestString(userID: userID, catID: catIDs);
  //   final response = await http.post(
  //     Uri.parse(Constants.SERVER_URL + method + '?page=$page'),
  //     body: {"data": requestString.getAPIRequest(method)},
  //   );

  //   Map<String, dynamic> responseJson = json.decode(response.body.toString());
  //   return JsonParser.fromLatestNewsJson(responseJson).arrayListLatestNews;
  // }

  Future<List<ItemNews>?> getLatestNews(String method, String userID, String catIDs, int page) async {
    client.close();

    requestString = new RequestString(userID: userID, catID: catIDs);
    client = http.Client();

    final response = await client.post(
      Uri.parse(Constants.SERVER_URL + method + '?page=$page'),
      body: {"data": requestString.getAPIRequest(method)},
    );

    client = http.Client();

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromLatestNewsJson(responseJson).arrayListLatestNews;
  }

  Future<List<ItemNews>?> getNewsByCat(String method, String userID, String catID, int page) async {
    client.close();

    requestString = new RequestString(catID: catID, userID: userID);

    client = http.Client();
    final response = await client.post(
      Uri.parse(Constants.SERVER_URL + method + '?page=$page'),
      body: {"data": requestString.getAPIRequest(method)},
    );

    client = http.Client();

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromLatestNewsJson(responseJson).arrayListLatestNews;
  }

  Future<List<ItemNews>?> getNewsByFav(String method, String userID, int page) async {
    requestString = new RequestString(userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method + '?page=$page'),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromLatestNewsJson(responseJson).arrayListLatestNews;
  }

  Future<List<ItemNews>?> getNewsByHomeSection(String method, String userID, String homeSectionID) async {
    requestString = new RequestString(homeSectionID: homeSectionID, userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromLatestNewsJson(responseJson).arrayListLatestNews;
  }

  Future<List<ItemNews>?> getNewsByTrending(String method, String userID, String catID) async {
    requestString = new RequestString(catID: catID, userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromLatestNewsJson(responseJson).arrayListLatestNews;
  }

  Future<List<ItemNews>?> getNewsBySearch(String method, String userID, String searchText, int page) async {
    requestString = new RequestString(searchText: searchText, userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method + '?page=$page'),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromLatestNewsJson(responseJson).arrayListLatestNews;
  }

  Future<List<ItemNews>?> getNewsByUser(String method, String userID) async {
    requestString = new RequestString(userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromLatestNewsJson(responseJson).arrayListLatestNews;
  }

  Future<ItemNews?> getNewsDetails(String method, String userID, String postID) async {
    requestString = new RequestString(postID: postID, userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );
    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromNewsDetailJson(responseJson).arrayListLatestNews![0];
  }

  Future<ItemLiveTV?> getLiveTV(String method) async {
    requestString = new RequestString();
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromLiveTVJson(responseJson).arrayListLiveTV?[0];
  }

  Future<ItemSuccess?> getDoFav(String method, String postID, String postType, String userID) async {
    requestString = new RequestString(postID: postID, postType: postType, userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<ItemSuccess?> getDoView(String method, String postID, String postType) async {
    requestString = new RequestString(postID: postID, postType: postType);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<List<ItemComments>?> getComments(String method, String postID) async {
    requestString = new RequestString(postID: postID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );
    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromCommentJson(responseJson).arrayListComments;
  }

  Future<ItemSuccess?> getAddComment(String method, String postID, String comment, String userID) async {
    requestString = new RequestString(postID: postID, userID: userID, comment: comment);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );
    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromAddCommentJson(responseJson).arrayListSuccess![0];
  }

  Future<ItemSuccess?> getNewsUpload(String method, String userID, String catID, String postType, String videoType, String videoUrl, String title,
      String date, String tags, String description, String imageFile, List<XFile> imageGallery, String videoFilePath) async {
    requestString = new RequestString(
        userID: userID,
        catID: catID,
        postType: postType,
        videoType: videoType,
        videoUrl: videoUrl,
        title: title,
        description: description,
        date: date,
        tags: tags);

    var request = http.MultipartRequest("POST", Uri.parse(Constants.SERVER_URL + method));
    request.fields['data'] = requestString.getAPIRequest(method);

    if (imageFile != '') {
      var pic = await http.MultipartFile.fromPath("new_image", imageFile);
      request.files.add(pic);
    }
    if (imageGallery.length > 0) {
      for (var image in imageGallery) {
        var pic1 = await http.MultipartFile.fromPath("image_gallery[]", image.path);
        request.files.add(pic1);
      }
    }
    if (videoFilePath != '') {
      var pic = await http.MultipartFile.fromPath("video_file", videoFilePath);
      request.files.add(pic);
    }
    var requestSend = await request.send();
    var responseRaw = await requestSend.stream.toBytes();
    var response = String.fromCharCodes(responseRaw);

    Map<String, dynamic> responseJson = json.decode(response);
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<ItemSuccess?> getNewsEdit(String method, String userID, String newsID, String catID, String postType, String videoType, String videoUrl,
      String title, String date, String tags, String description, String imageFile, List<ItemGallery> imageGallery, String videoFilePath) async {
    requestString = new RequestString(
        userID: userID,
        postID: newsID,
        catID: catID,
        postType: postType,
        videoType: videoType,
        videoUrl: videoUrl,
        title: title,
        description: description,
        date: date,
        tags: tags);

    var request = http.MultipartRequest("POST", Uri.parse(Constants.SERVER_URL + method));
    request.fields['data'] = requestString.getAPIRequest(method);

    if (imageFile != '') {
      var pic = await http.MultipartFile.fromPath("new_image", imageFile);
      request.files.add(pic);
    }
    if (imageGallery.length > 0) {
      for (var image in imageGallery) {
        if (image.imageFile != null) {
          var pic1 = await http.MultipartFile.fromPath("image_gallery[]", image.imageFile!.path);
          request.files.add(pic1);
        }
      }
    }
    if (videoFilePath != '') {
      var pic = await http.MultipartFile.fromPath("video_file", videoFilePath);
      request.files.add(pic);
    }
    var requestSend = await request.send();
    var responseRaw = await requestSend.stream.toBytes();
    var response = String.fromCharCodes(responseRaw);

    Map<String, dynamic> responseJson = json.decode(response);
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<ItemSuccess?> getReporterRequest(String method, String userID) async {
    requestString = new RequestString(userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<ItemSuccess?> getGalleryDelete(String method, String galleryID) async {
    requestString = new RequestString(galleryID: galleryID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<ItemSuccess?> getReport(String method, String userID, String postID, String postType, String message) async {
    requestString = new RequestString(userID: userID, postID: postID, postType: postType, searchText: message);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }

  Future<ItemSuccess?> getDeleteUserAccount(String method, String userID) async {
    requestString = new RequestString(userID: userID);
    final response = await http.post(
      Uri.parse(Constants.SERVER_URL + method),
      body: {"data": requestString.getAPIRequest(method)},
    );

    Map<String, dynamic> responseJson = json.decode(response.body.toString());
    return JsonParser.fromSuccessJson(responseJson).arrayListSuccess?[0];
  }
}
