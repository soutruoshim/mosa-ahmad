import 'package:flutter_news_app/items/itemHome.dart';
import 'package:flutter_news_app/models/tablet/news_model_small_tablet.dart';
import 'package:flutter_news_app/models/tablet/news_model_tablet.dart';
import 'package:flutter_news_app/pages/dashboard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/items/itemHomeSection.dart';
import 'package:flutter_news_app/models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../apiservice/apiclient.dart';
import '../models/appbar_model.dart';
import '../models/news_model_small.dart';
import '../resources/colors.dart';
import '../resources/images.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';
import 'news_by_home.dart';
import 'news_detail.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  bool isInternet = false;
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final textInpControllerSearch = TextEditingController();

    return Scaffold(
      appBar: AppBarCustom(appBarTitle: Strings.home, isSettings: true),
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: loadHome(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            ItemHome itemHome = snapshot.data;
            return Container(
              child: CustomScrollView(
                slivers: buildSliverList(context, itemHome, Constants.newsItemHeight, Constants.newsItemHeightSmall, textInpControllerSearch, (String type, int id) {
                  if (type == Strings.latest_news) {
                    Dashboard.of(context).openLatestTab();
                  } else if (type == Strings.trending_news) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return NewsByHome(type: type, homeSectionID: '0', homeSectionName: type);
                    }));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return NewsByHome(type: type, homeSectionID: id.toString(), homeSectionName: type);
                    }));
                  }
                }),
              ),
            );
            // return HomeUI(itemHome: itemHome);
          } else if (snapshot.hasError) {
            if (isInternet) {
              return Methods.getErrorEmpty(Strings.err_connecting_server);
            } else {
              return Methods.getErrorEmpty(Strings.err_internet_not_connected);
            }
          } else {
            return CustomProgressBar();
          }
        },
      ),
    );
  }

  Future<ItemHome?> loadHome() async {
    isInternet = await Methods.checkConnectivity();
    return await new ApiCLient().getHome(Constants.METHOD_HOME, SharedPref.getUserID().toString(), SharedPref.getSelectedCatIDs());
  }
}

List<Widget> buildSliverList(
    context, ItemHome itemHome, double newsItemHeight, double newsItemHeightSmall, textInpControllerSearch, Function seeAllClick) {
  List<Widget> slivers = [];

  slivers.add(SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Methods.getEditTextInputSearch(context, textInpControllerSearch, false, () {}),
    ),
  ));

  if (itemHome.arrayListSlider.length > 0) {
    slivers.add(new SliverToBoxAdapter(
      child: CarouselSlider(
        options: CarouselOptions(aspectRatio: 1.85, autoPlay: true, viewportFraction: 1.0),
        items: itemHome.arrayListSlider.map((itemNews) {
          return Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NewsDetail(itemNews: itemNews, isNewsEdit: false, isFromNotification: false);
                }));
              },
              child: Card(
                margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        imageUrl: itemNews.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          Images.placeholder_news,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.bottomCenter,
                            end: AlignmentDirectional.topCenter,
                            colors: [ColorsApp.grt_home_2, ColorsApp.grt_home_1],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: ColorsApp.primary_AA,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              itemNews.categoryName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            itemNews.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        }).toList(),
      ),
    ));
  }

  if (itemHome.arrayListLatestNews.length > 0) {
    slivers.add(new SliverToBoxAdapter(
      child: SectionHeader(
        textTitle: Strings.latest_news,
        clickFun: () {
          seeAllClick.call(Strings.latest_news, 0);
        },
      ),
    ));
    slivers.add(SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 8),
        child: SharedPref.getDeviceType() == 'mobile'
            ? NewsModel(itemNews: itemHome.arrayListLatestNews[index], height: newsItemHeight, isNewsEdit: false)
            : NewsModelTablet(itemNews: itemHome.arrayListLatestNews[index], height: newsItemHeight, isNewsEdit: false),
      );
    }, childCount: itemHome.arrayListLatestNews.length)));
  }

  if (itemHome.arrayListTrendingNews.length > 0) {
    slivers.add(new SliverToBoxAdapter(
      child: SectionHeader(
        textTitle: Strings.trending_news,
        clickFun: () {
          seeAllClick.call(Strings.trending_news, 0);
        },
      ),
    ));
    slivers.add(SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: SharedPref.getDeviceType() == 'mobile'
                ? NewsModelSmall(itemNews: itemHome.arrayListTrendingNews[index], height: newsItemHeightSmall, isNewsEdit: false)
                : NewsModelSmallTablet(itemNews: itemHome.arrayListTrendingNews[index], height: newsItemHeightSmall, isNewsEdit: false)),
      );
    }, childCount: itemHome.arrayListTrendingNews.length)));
  }

  for (ItemHomeSections itemHomeSection in itemHome.arrayListHomeSections) {
    slivers.add(new SliverToBoxAdapter(
      child: SectionHeader(
        textTitle: itemHomeSection.title,
        clickFun: () {
          seeAllClick.call(itemHomeSection.title, itemHomeSection.id);
        },
      ),
    ));
    slivers.add(SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 8),
        child: SharedPref.getDeviceType() == 'mobile'
            ? NewsModel(itemNews: itemHomeSection.arrayListNews[index], height: newsItemHeight, isNewsEdit: false)
            : NewsModelTablet(itemNews: itemHomeSection.arrayListNews[index], height: newsItemHeight, isNewsEdit: false),
      );
    }, childCount: itemHomeSection.arrayListNews.length)));
  }
  return slivers;
}

class SectionHeader extends StatelessWidget {
  final String textTitle;
  final Function clickFun;
  const SectionHeader({super.key, required this.textTitle, required this.clickFun});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
      child: Row(children: [
        Text(
          textTitle,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Expanded(child: SizedBox()),
        TextButton(
          onPressed: () {
            Methods.showInterAd(onAdDissmissed: () {
              clickFun.call();
            });
          },
          child: Text(Strings.see_all, style: TextStyle(color: ColorsApp.primary, fontSize: 14, fontWeight: FontWeight.w500)),
        )
      ]),
    );
  }
}
