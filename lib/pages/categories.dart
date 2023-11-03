import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/items/itemCategories.dart';

import '../apiservice/apiclient.dart';
import '../models/category_model.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';

class Categories extends StatefulWidget {
  Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final textInpControllerSearch = TextEditingController();
  List<ItemCategories> listCategories = [], listSearchCat = [];
  bool isLoading = true, isInternet = false;
  String errorMessage = Strings.err_no_data_found;

  @override
  void initState() {
    loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[CustomHideShowAppBar(title: Strings.categories)];
        },
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Methods.getInputSearchCategories(context, textInpControllerSearch, (searchText) {
                listSearchCat.clear();
                if (searchText.isEmpty) {
                  setState(() {});
                  return;
                }

                listCategories.forEach((itemCat) {
                  if (itemCat.name.toLowerCase().contains(searchText.toString().toLowerCase())) listSearchCat.add(itemCat);
                });

                setState(() {});
              }),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: isLoading && listCategories.length == 0
                      ? CustomProgressBar()
                      : listCategories.length > 0
                          ? textInpControllerSearch.text.length == 0
                              ? CustomScrollView(slivers: [
                                  SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int position) {
                                        if (position < listCategories.length) {
                                          return CategoryModel(itemCategory: listCategories[position], isSelect: false, isCategorySelected: false);
                                        } else {
                                          return SizedBox(height: 10);
                                        }
                                      },
                                      childCount: listCategories.length,
                                    ),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: SharedPref.getDeviceType() == 'mobile' ? 2 : 3,
                                        childAspectRatio: 1.3,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10),
                                  ),
                                ])
                              : CustomScrollView(slivers: [
                                  SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int position) {
                                        if (position < listSearchCat.length) {
                                          return CategoryModel(itemCategory: listSearchCat[position], isSelect: false, isCategorySelected: false);
                                        } else {
                                          return SizedBox(height: 10);
                                        }
                                      },
                                      childCount: listSearchCat.length,
                                    ),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, childAspectRatio: 1.3, mainAxisSpacing: 5, crossAxisSpacing: 5),
                                  ),
                                ])
                          : isInternet
                              ? Methods.getErrorEmpty(errorMessage)
                              : Methods.getErrorEmpty(Strings.err_internet_not_connected),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadCategories() async {
    if (await Methods.checkConnectivity()) {
      isInternet = true;
      setState(() {
        isLoading = true;
      });
      try {
        List<ItemCategories>? tempList = await new ApiCLient().getCategories(Constants.METHOD_CATEGORIES, SharedPref.getUserID().toString());
        if (tempList != null) {
          errorMessage = Strings.err_no_data_found;
          listCategories.addAll(tempList);
        }
      } catch (e) {
        if (listCategories.length == 0) {
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
}
