import 'package:flutter_news_app/items/itemHomeSection.dart';
import 'package:flutter_news_app/items/itemNews.dart';

class ItemHome { 
  List<ItemNews> arrayListSlider = [];
  List<ItemNews> arrayListLatestNews = [];
  List<ItemNews> arrayListTrendingNews = [];
  List<ItemHomeSections> arrayListHomeSections = [];


  ItemHome.fromJson(Map<String, dynamic> json) {
    if (json['slider'] != null) {
      arrayListSlider = <ItemNews>[];
      json['slider'].forEach((v) {
        arrayListSlider.add(new ItemNews.fromSliderJson(v));
      });
    }
    
    if (json['latest_news'] != null) {
      arrayListLatestNews = <ItemNews>[];
      json['latest_news'].forEach((v) {
        arrayListLatestNews.add(new ItemNews.fromJson(v));
      });
    }
    
    if (json['trending_news'] != null) {
      arrayListTrendingNews = <ItemNews>[];
      json['trending_news'].forEach((v) {
        arrayListTrendingNews.add(new ItemNews.fromJson(v));
      });
    }
    if (json['home_sections'] != null) {
      arrayListHomeSections = <ItemHomeSections>[];
      json['home_sections'].forEach((v) {
        arrayListHomeSections.add(new ItemHomeSections.fromJson(v));
      });
    }
  }
}