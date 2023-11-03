import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/items/itemCategories.dart';

import '../apiservice/apiclient.dart';
import '../models/appbar_model.dart';
import '../models/category_model.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';

// ignore: must_be_immutable
class SelectCategories extends StatefulWidget {
  bool fromApp;
  SelectCategories({super.key, required this.fromApp});

  @override
  State<SelectCategories> createState() => _SelectCategoriesState();
}

class _SelectCategoriesState extends State<SelectCategories> {
  final textInpControllerSearch = TextEditingController();
  List<ItemCategories> listCategories = [];
  List<String> selectedCatIDs = [];
  bool isLoading = true, isInternet = false;
  String errorMessage = Strings.err_no_data_found;

  @override
  void initState() {
    if (widget.fromApp) {
      selectedCatIDs = SharedPref.getSelectedCatIDs().split(',');
    }

    loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarCustom(appBarTitle: Strings.select_categories, isSettings: false),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                Strings.select_cat_see_news,
                style: TextStyle(
                  height: 1,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: isLoading && listCategories.length == 0
                      ? CustomProgressBar()
                      : listCategories.length > 0
                          ? CustomScrollView(slivers: [
                              SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int position) {
                                    if (position < listCategories.length) {
                                      return CategoryModel(
                                          itemCategory: listCategories[position],
                                          isSelect: true,
                                          isCategorySelected: selectedCatIDs.contains(listCategories[position].id.toString()),
                                          selectFun: (String catId) {
                                            if (!selectedCatIDs.contains(catId)) {
                                              selectedCatIDs.add(catId);
                                            } else {
                                              selectedCatIDs.remove(catId);
                                            }
                                          });
                                    } else {
                                      return SizedBox(height: 10);
                                    }
                                  },
                                  childCount: listCategories.length,
                                ),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: SharedPref.getDeviceType() == 'mobile' ? 2 : 3,
                                    childAspectRatio: 1.3,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5),
                              ),
                            ])
                          : isInternet
                              ? Methods.getErrorEmpty(errorMessage)
                              : Methods.getErrorEmpty(Strings.err_internet_not_connected),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Theme.of(context).bottomNavigationBarTheme.backgroundColor, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCatIDs.length > 0) {
                    SharedPref.setSelectedCatIDs(selectedCatIDs);
                  } else {
                    Methods.showSnackBar(context, Strings.select_1_cat);
                  }
                  if (!widget.fromApp) {
                    SharedPref.setSelectCatShown(true);
                    Methods.openDashBoardPage(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  backgroundColor: ColorsApp.primary,
                ),
                child: Text(
                  Strings.save,
                  style: TextStyle(fontSize: 18),
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

      if (!widget.fromApp) {
        for (var itemCat in listCategories) {
          selectedCatIDs.add(itemCat.id.toString());
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
