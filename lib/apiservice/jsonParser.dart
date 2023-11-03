import 'package:flutter_news_app/items/itemAppDetails.dart';
import 'package:flutter_news_app/items/itemLiveTV.dart';

import '../items/itemCategories.dart';
import '../items/itemComments.dart';
import '../items/itemHome.dart';
import '../items/itemNews.dart';
import '../items/itemSuccess.dart';
import '../items/itemUsers.dart';

class JsonParser {
  List<ItemAppDetails>? arrayListAppDetails;
  List<ItemUser>? arrayListUser;
  List<ItemSuccess>? arrayListSuccess;
  ItemHome? itemHome;
  List<ItemCategories>? arrayListCategories;
  List<ItemNews>? arrayListLatestNews;
  List<ItemLiveTV>? arrayListLiveTV;
  List<ItemComments>? arrayListComments;
  int? statusCode;

  // JsonParser({this.arrayListUser, this.arrayListSuccess, this.statusCode});

  JsonParser.fromSuccessJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      arrayListSuccess = <ItemSuccess>[];
      json['NEWS_APP'].forEach((v) {
        arrayListSuccess!.add(new ItemSuccess.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  JsonParser.fromAppDetailsJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      arrayListAppDetails = <ItemAppDetails>[];
      json['NEWS_APP'].forEach((v) {
        arrayListAppDetails!.add(new ItemAppDetails.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  JsonParser.fromUserJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      arrayListUser = <ItemUser>[];
      json['NEWS_APP'].forEach((v) {
        arrayListUser!.add(new ItemUser.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  JsonParser.fromCategoryJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      arrayListCategories = <ItemCategories>[];
      json['NEWS_APP'].forEach((v) {
        arrayListCategories!.add(new ItemCategories.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  JsonParser.fromHomeJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      itemHome = json['NEWS_APP'] != null
          ? new ItemHome.fromJson(json['NEWS_APP'])
          : null;
    }
    statusCode = json['status_code'];
  }

  JsonParser.fromLatestNewsJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      arrayListLatestNews = <ItemNews>[];
      json['NEWS_APP'].forEach((v) {
        arrayListLatestNews!.add(new ItemNews.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  JsonParser.fromNewsDetailJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      arrayListLatestNews = <ItemNews>[];
      json['NEWS_APP'].forEach((v) {
        arrayListLatestNews!.add(new ItemNews.fromNewsDetailJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  JsonParser.fromLiveTVJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      arrayListLiveTV = <ItemLiveTV>[];
      json['NEWS_APP'].forEach((v) {
        arrayListLiveTV!.add(new ItemLiveTV.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  JsonParser.fromCommentJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      arrayListComments = <ItemComments>[];
      json['NEWS_APP'].forEach((v) {
        arrayListComments!.add(new ItemComments.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  JsonParser.fromAddCommentJson(Map<String, dynamic> json) {
    if (json['NEWS_APP'] != null) {
      arrayListSuccess = <ItemSuccess>[];
      json['NEWS_APP'].forEach((v) {
        arrayListSuccess!.add(new ItemSuccess.fromAddCommentJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.arrayListSuccess != null) {
  //     data['HD_WALLPAPER_APP'] =
  //         this.arrayListSuccess!.map((v) => v.toJson()).toList();
  //   }
  //   data['status_code'] = this.statusCode;
  //   return data;
  // }
}
