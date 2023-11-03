import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/pages/news_by_cat.dart';
import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter/material.dart';

import '../items/itemCategories.dart';
import '../resources/images.dart';
import '../utils/methods.dart';

class CategoryModel extends StatefulWidget {
  final ItemCategories itemCategory;
  final bool isSelect, isCategorySelected;
  final Function? selectFun;

  CategoryModel({required this.itemCategory, required this.isSelect, required this.isCategorySelected, this.selectFun});

  @override
  State<CategoryModel> createState() => _CategoryModelState();
}

class _CategoryModelState extends State<CategoryModel> {
  bool isCheckBoxSelected = false;

  @override
  void initState() {
    super.initState();
    isCheckBoxSelected = widget.isCategorySelected;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          if (!widget.isSelect) {
            Methods.showInterAd(onAdDissmissed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewsByCat(catID: widget.itemCategory.id.toString(), catName: widget.itemCategory.name, isFromNotification: false);
              }));
            });
          }
        },
        child: Container(
          width: 300,
          height: 150,
          child: Stack(children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(Images.placeholder_cat, fit: BoxFit.cover),
                      imageUrl: widget.itemCategory.image,
                      errorWidget: (context, url, error) => Image.asset(Images.placeholder_cat, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      widget.itemCategory.name,
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            if (widget.isSelect)
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: ColorsApp.bg_checkbox,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Checkbox(
                    value: isCheckBoxSelected,
                    activeColor: ColorsApp.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(width: 2, color: Colors.white),
                    onChanged: (onChanged) {
                      setState(() {
                        isCheckBoxSelected = !isCheckBoxSelected;
                        widget.selectFun!.call(widget.itemCategory.id.toString());
                      });
                    },
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
