import 'dart:math';

import 'package:flutter_news_app/ads/AdHelper.dart';
import 'package:flutter_news_app/items/itemNews.dart';
import 'package:flutter_news_app/models/nativead.dart';
import 'package:flutter_news_app/models/tablet/news_model_tablet.dart';
import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter_news_app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wortise/google_native_ad.dart';

import '../apiservice/apiclient.dart';
import '../items/itemCategories.dart';
import '../models/news_model.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';

// ignore: must_be_immutable
class LatestNews extends StatefulWidget {
  LatestNews({super.key});

  @override
  State<LatestNews> createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  final textInpControllerSearch = TextEditingController();
  List<ItemNews?> listNews = [];
  List<ItemCategories> categories = [];
  bool isLoading = true, isOver = false, isInternet = false;
  int currentLength = 0, pageNumber = 0;
  late ScrollController scrollController;
  ItemCategories? itemSelectedCategory;
  String errorMessage = Strings.err_no_data_found;
  int totalArraySize = 0;
  late Future<List<ItemCategories>> futureCat;

  bool isAdLoaded = false;
  List<dynamic> listNativeAds = [];

  ApiCLient apiCLient = new ApiCLient();

  @override
  void initState() {
    futureCat = loadCategories();
    loadNativeAds();
    loadLatestNews();
    scrollController = new ScrollController(initialScrollOffset: 5.0)..addListener(scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[CustomHideShowAppBar(title: Strings.latest_news)];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Methods.getEditTextInputSearch(context, textInpControllerSearch, false, () {}),
            ),
            SizedBox(height: 15),
            Container(
              height: 30,
              child: FutureBuilder<List<ItemCategories>?>(
                future: futureCat,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, position) {
                        return Padding(
                          padding: position == 0
                              ? EdgeInsetsDirectional.only(start: 20)
                              : position == categories.length - 1
                                  ? EdgeInsetsDirectional.only(end: 20)
                                  : EdgeInsetsDirectional.only(start: 0),
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = false;

                                listNews.clear();
                                isOver = false;
                                pageNumber = 0;

                                if (itemSelectedCategory == null || itemSelectedCategory!.id != categories[position].id) {
                                  itemSelectedCategory = categories[position];
                                } else {
                                  itemSelectedCategory = null;
                                }

                                loadLatestNews();
                              });
                            },
                            child: Text(categories[position].name),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: itemSelectedCategory == null || itemSelectedCategory!.id != categories[position].id
                                    ? ColorsApp.primary
                                    : Colors.white,
                                side: BorderSide(
                                  color: ColorsApp.primary,
                                  width: 1.5,
                                ),
                                backgroundColor: itemSelectedCategory == null || itemSelectedCategory!.id != categories[position].id
                                    ? Colors.transparent
                                    : ColorsApp.primary,
                                shape: StadiumBorder()),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(width: 7),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: isLoading && listNews.length == 0
                      ? CustomProgressBar()
                      : listNews.length > 0
                          ? ListView.separated(
                              controller: scrollController,
                              itemCount: !isOver ? listNews.length + 1 : listNews.length,
                              itemBuilder: (context, position) {
                                if (position < listNews.length) {
                                  if (listNews[position] != null) {
                                    if (SharedPref.getDeviceType() == 'mobile') {
                                      return NewsModel(itemNews: listNews[position]!, height: Constants.newsItemHeight, isNewsEdit: false);
                                    } else {
                                      return NewsModelTablet(itemNews: listNews[position]!, height: Constants.newsItemHeight, isNewsEdit: false);
                                    }
                                  } else {
                                    if (listNativeAds.length > 0) {
                                      return NativeAdsPage(nativeAds: listNativeAds[new Random().nextInt(listNativeAds.length)]);
                                    } else {
                                      return Container();
                                    }
                                  }
                                } else {
                                  return CustomLazyLoadingProgressBar();
                                }
                              },
                              separatorBuilder: (context, index) {
                                // if (index % Constants.nativeAdPos == 0 && isAdLoaded) {
                                //   return NativeAdsPage(nativeAds: listNativeAds[new Random().nextInt(listNativeAds.length)]);
                                // } else {
                                return SizedBox(
                                  height: 8,
                                );
                                // }
                              },
                            )
                          : isInternet
                              ? Methods.getErrorEmpty(errorMessage)
                              : Methods.getErrorEmpty(Strings.err_internet_not_connected),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  loadLatestNews() async {
    if (await Methods.checkConnectivity()) {
      isInternet = true;
      setState(() {
        isLoading = true;
      });

      pageNumber = pageNumber + 1;
      try {
        List<ItemNews>? tempList;

        if (itemSelectedCategory == null) {
          tempList = await apiCLient.getLatestNews(
              Constants.METHOD_LATEST_NEWS, SharedPref.getUserID().toString(), SharedPref.getSelectedCatIDs(), pageNumber);
        } else {
          tempList = await apiCLient.getNewsByCat(
              Constants.METHOD_NEWS_BY_CAT, SharedPref.getUserID().toString(), itemSelectedCategory!.id.toString(), pageNumber);
        }
        if (tempList != null) {
          errorMessage = Strings.err_no_data_found;
          if (tempList.length <= 5) {
            isOver = true;
          }

          totalArraySize = totalArraySize + tempList.length;
          for (int i = 0; i < tempList.length; i++) {
            listNews.add(tempList[i]);

            if (Constants.isNativeAd) {
              int abc = listNews.lastIndexOf(null);
              if (((listNews.length - (abc + 1)) % Constants.nativeAdPos == 0) && (tempList.length - 1 != i || totalArraySize != 1500)) {
                listNews.add(null);
              }
            }
          }

          // listNews.addAll(tempList);
        }
      } catch (e) {
        isOver = true;
        if (listNews.length == 0) {
          errorMessage = Strings.err_connecting_server;
        }
      }

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isInternet = false;
      });
    }
  }

  Future<List<ItemCategories>> loadCategories() async {
    // pageNumber = pageNumber + 1;
    if (await Methods.checkConnectivity()) {
      if (Constants.arrayListCategories.length == 0) {
        Constants.arrayListCategories.addAll(
            (await new ApiCLient().getCategories(Constants.METHOD_CATEGORIES, SharedPref.getUserID().toString())) as Iterable<ItemCategories>);

        // return Constants.arrayListCategories;
      }
      // else {
      // return Constants.arrayListCategories;
      // }
    }

    List<String> selectedCatIds = SharedPref.getSelectedCatIDs().split(',');
    for (var itemCat in Constants.arrayListCategories) {
      if (selectedCatIds.contains(itemCat.id.toString())) {
        categories.add(itemCat);
      }
    }
    return categories;
  }

  scrollListener() {
    if (!isOver && !isLoading && scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      loadLatestNews();
    }
  }

  void loadNativeAds() async {
    if (Constants.isNativeAd && listNativeAds.length < 4) {
      if (Constants.adType == Constants.AD_TYPE_ADMOB) {
        NativeAd(
          adUnitId: AdHelper.nativeAdId,
          factoryId: 'listTile',
          request: AdRequest(),
          listener: NativeAdListener(
            // Called when an ad is successfully received.
            onAdLoaded: (Ad ad) {
              var _add = ad as NativeAd;
              listNativeAds.add(_add);
              if (listNativeAds.length == 1) {
                setState(() {
                  isAdLoaded = true;
                });
              }

              loadNativeAds();
            },
            // Called when an ad request failed.
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
          ),
        ).load();
      } else {
        late GoogleNativeAd _nativeAd;
        try {
          _nativeAd = GoogleNativeAd(AdHelper.nativeAdId, 'test-factory', (event, args) {
            if (event == GoogleNativeAdEvent.LOADED) {
              listNativeAds.add(_nativeAd);
              if (listNativeAds.length == 1) {
                setState(() {
                  isAdLoaded = true;
                });
              }
              if (listNativeAds.length < 4) {
                loadNativeAds();
              }
            }
          });
          await _nativeAd.load();
        } catch (e) {}
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    try {
      for (var nativeAd in listNativeAds) {
        nativeAd.dispose();
      }
    } catch (e) {}
    super.dispose();
  }
}
