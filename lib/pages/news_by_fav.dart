import 'dart:math';

import 'package:flutter_news_app/ads/AdHelper.dart';
import 'package:flutter_news_app/ads/banner_admob.dart';
import 'package:flutter_news_app/models/tablet/news_model_tablet.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_news_app/items/itemNews.dart';
import 'package:flutter_news_app/resources/strings.dart';
import 'package:wortise/google_native_ad.dart';

import '../ads/banner_wortise.dart';
import '../apiservice/apiclient.dart';
import '../models/appbar_model.dart';
import '../models/nativead.dart';
import '../models/news_model.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';

// ignore: must_be_immutable
class NewsByFav extends StatefulWidget {
  NewsByFav({super.key});

  @override
  State<NewsByFav> createState() => _NewsByFavState();
}

class _NewsByFavState extends State<NewsByFav> {
  final textInpControllerSearch = TextEditingController();
  List<ItemNews?> listNews = [];
  bool isLoading = true, isOver = false, isInternet = false;
  int currentLength = 0, pageNumber = 0, totalArraySize = 0;
  late ScrollController scrollController;
  String errorMessage = Strings.err_no_data_found;

  bool isAdLoaded = false;
  List<dynamic> listNativeAds = [];

  @override
  void initState() {
    loadNativeAds();
    loadNews();
    scrollController = new ScrollController(initialScrollOffset: 5.0)..addListener(scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        appBar: AppBarCustom(appBarTitle: Strings.favourite, isSettings: true),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Methods.getEditTextInputSearch(context, textInpControllerSearch, false, () {}),
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
                              separatorBuilder: (context, index) => SizedBox(
                                height: 8,
                              ),
                            )
                          : isInternet
                              ? Methods.getErrorEmpty(errorMessage)
                              : Methods.getErrorEmpty(Strings.err_internet_not_connected),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Constants.adType == Constants.AD_TYPE_ADMOB ? BannerAdmob() : BannerWortise(),
            ),
          ],
        ),
      ),
    );
  }

  loadNews() async {
    if (await Methods.checkConnectivity()) {
      isInternet = true;
      setState(() {
        isLoading = true;
      });

      pageNumber = pageNumber + 1;
      try {
        List<ItemNews>? tempList = await new ApiCLient().getNewsByFav(Constants.METHOD_NEWS_BY_FAV, SharedPref.getUserID().toString(), pageNumber);
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

  scrollListener() {
    if (!isOver && !isLoading && scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      loadNews();
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
