import 'package:flutter_news_app/items/itemNews.dart';

class ItemHomeSections {
  int id=0;
  String title='', type='';
  List<ItemNews> arrayListNews = [];


  ItemHomeSections.fromJson(Map<String, dynamic> json) {
     
    id = json['home_id'];
    title = json['home_title'];
    type = json['home_type'];
    type = json['home_type'];  

    if (json['home_content'] != null) {
      arrayListNews = <ItemNews>[];
      json['home_content'].forEach((v) {
        arrayListNews.add(new ItemNews.fromJson(v));
      });
    }
  }
}