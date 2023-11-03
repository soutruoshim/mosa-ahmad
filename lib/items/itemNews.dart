import 'package:flutter_news_app/items/itemComments.dart';

import 'itemGallery.dart';

class ItemNews {
  int id = 0, categoryID = 0;
  bool isFav = false;
  String title = '',
      image = '',
      date = '01 Jan 1900',
      totalComment = '0',
      userName = '',
      userImage = '',
      totalViews = '0',
      categoryName = '',
      tags = '',
      description = '',
      newsType = '',
      videoType = '',
      videoUrl = '';
  List<ItemGallery> arrayListGallery = [];
  List<ItemNews> arrayListRelatedNews = [];
  List<ItemComments> arrayListComments = [];

  ItemNews(id, title) {
    this.id = id;
    this.title = title;
  }

  ItemNews.fromJson(Map<String, dynamic> json) {
    id = json['post_id'];
    title = json['post_title'];
    image = json['post_image'];
    date = json['post_date'];
    totalComment = json['total_comments'].toString();
    totalViews = json['total_views'].toString();
    if (json.containsKey('favourite')) {
      isFav = json['favourite'];
    }
    userName = json['user_name'];
    userImage = json['user_image'];
    categoryName = json['category_name'];
    if (json.containsKey('cat_id')) {
      categoryID = json['cat_id'];
    }
    description = json['post_description'];
    tags = json['post_tags'];
  }

  ItemNews.fromSliderJson(Map<String, dynamic> json) {
    id = json['post_id'];
    title = json['post_title'];
    image = json['post_image'];
    categoryName = json['category_name'];
    description = json['post_description'];
    tags = json['post_tags'];
  }

  ItemNews.fromNewsDetailJson(Map<String, dynamic> json) {
    id = json['post_id'];
    title = json['post_title'];
    image = json['post_image'];
    date = json['post_date'];
    totalComment = json['total_comments'].toString();
    totalViews = json['total_views'].toString();
    isFav = json['favourite'];
    userName = json['user_name'];
    userImage = json['user_image'];
    categoryName = json['category_name'];
    description = json['post_description'];
    tags = json['post_tags'];

    newsType = json['post_type'];
    videoType = json['video_type'];
    videoUrl = json['video_url'];

    if (json['gallery_list'] != null) {
      json['gallery_list'].forEach((v) {
        arrayListGallery.add(ItemGallery.fromJson(v));
      });
    }

    if (json['related_news'] != null) {
      json['related_news'].forEach((v) {
        arrayListRelatedNews.add(ItemNews.fromJson(v));
      });
    }

    if (json['comments_list'] != null) {
      json['comments_list'].forEach((v) {
        arrayListComments.add(ItemComments.fromJson(v));
      });
    }
  }
}
