import 'dart:io';

import 'package:flutter_news_app/items/itemCategories.dart';
import 'package:flutter_news_app/items/itemGallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_news_app/items/itemNews.dart';
import 'package:flutter_news_app/resources/strings.dart';

import '../apiservice/apiclient.dart';
import '../items/itemSuccess.dart';
import '../models/appbar_model.dart';
import '../resources/images.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';

// ignore: must_be_immutable
class EditNews extends StatefulWidget {
  final ItemNews itemNews;
  const EditNews({super.key, required this.itemNews});

  @override
  State<EditNews> createState() => EditNewsState();
}

class EditNewsState extends State<EditNews> {
  static const String NEWS_TYPE_IMAGE = 'Image';
  static const String NEWS_TYPE_VIDEO = 'Video';
  static const String VIDEO_TYPE_URL = 'URL';
  static const String VIDEO_TYPE_LOCAL = 'Local';

  final textInpCntTitle = TextEditingController();
  final textInpCntTags = TextEditingController();
  final textInpCntDate = TextEditingController();
  final textInpCntDescription = TextEditingController();
  final textInpCntVideoUrl = TextEditingController();
  double width = 0;
  DateTime selectedDate = DateTime.now();

  List<ItemCategories> listCategories = [ItemCategories(id: 0, name: Strings.select_categories, image: 'image')];
  List<String> listNewsType = [NEWS_TYPE_IMAGE, NEWS_TYPE_VIDEO];
  List<String> listVideoType = [VIDEO_TYPE_URL, VIDEO_TYPE_LOCAL];
  List<String> listTags = [];

  late ItemCategories selectedCategory;
  ImagePicker _picker = ImagePicker();
  XFile? featuredImage = null, videoFile = null;
  List<ItemGallery> listImageGallery = [];
  late String selectedNewsType, selectedVideoType, videoName = Strings.video_name;

  @override
  void initState() {
    super.initState();
    selectedCategory = listCategories[0];
    selectedNewsType = listNewsType[listNewsType.indexOf(widget.itemNews.newsType)];
    if (widget.itemNews.newsType == NEWS_TYPE_IMAGE) {
      selectedVideoType = listVideoType[0];
    } else {
      selectedVideoType = listVideoType[listVideoType.indexOf(widget.itemNews.videoType)];
      textInpCntVideoUrl.text = widget.itemNews.videoUrl;
      videoName = widget.itemNews.videoUrl;
    }
    textInpCntDate.text = DateFormat.yMd().format(DateFormat('dd, MMM yyyy').parse(widget.itemNews.date));
    textInpCntDescription.text = widget.itemNews.description;
    listTags = widget.itemNews.tags.split(',');
    textInpCntTitle.text = widget.itemNews.title;

    listImageGallery.addAll(widget.itemNews.arrayListGallery);
    listImageGallery.removeAt(0);
    loadCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = (MediaQuery.of(context).size.width - 30);
  }

  List<ItemNews> data = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        appBar: AppBarCustom(appBarTitle: Strings.edit_news, isSettings: false),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10.0),
                      strokeWidth: 2,
                      dashPattern: [10, 5],
                      color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: GestureDetector(
                          onTap: () async {
                            featuredImage = await _picker.pickImage(source: ImageSource.gallery);
                            if (featuredImage != null) {
                              setState(() {});
                            } else {}
                          },
                          child: AspectRatio(
                            aspectRatio: 1.85,
                            child: featuredImage == null
                                ? CachedNetworkImage(
                                    imageUrl: widget.itemNews.image,
                                    placeholder: (context, url) => Image.asset(Images.placeholder_news),
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                                    image: FileImage(File(featuredImage!.path)),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      Strings.news_details,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        Strings.news_type,
                        style: TextStyle(
                          color: !SharedPref.isDarkMode() ? ColorsApp.text_bb : ColorsApp.text_bb_dark,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: !SharedPref.isDarkMode() ? ColorsApp.bgCardNews : ColorsApp.bgCardNews_dark,
                        items: listNewsType.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            listImageGallery.clear();
                            videoFile = null;
                            videoName = Strings.video_name;
                            textInpCntVideoUrl.text = '';
                            selectedNewsType = value!;
                          });
                        },
                        value: selectedNewsType,
                        underline: SizedBox(),
                      ),
                    ),
                    SizedBox(height: 15),
                    selectedNewsType == NEWS_TYPE_IMAGE
                        ? DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(10.0),
                            strokeWidth: 2,
                            dashPattern: [10, 5],
                            color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              child: listImageGallery.length == 0
                                  ? GestureDetector(
                                      onTap: () async {
                                        List<XFile?> file = await _picker.pickMultiImage();
                                        setState(() {
                                          for (var itemFile in file) {
                                            listImageGallery.add(new ItemGallery(id: 0, image: '', imageFile: itemFile));
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(35),
                                        width: width,
                                        color: !SharedPref.isDarkMode() ? ColorsApp.bg_edit_text : ColorsApp.bg_edit_text_dark,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Methods.getAssetsWhiteIconWithBG(ColorsApp.primary, Images.ic_upload, 10, 50.0, 50.0),
                                            SizedBox(height: 10),
                                            Text(
                                              Strings.add_gallery_image,
                                              style: TextStyle(
                                                color: !SharedPref.isDarkMode() ? ColorsApp.text_bb : ColorsApp.text_bb_dark,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(Strings.recom_size_800x600,
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodySmall!.color,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(children: [
                                        Container(
                                          height: 100,
                                          child: ListView.separated(
                                            itemCount: listImageGallery.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsetsDirectional.only(end: 10, top: 15),
                                                    width: 120,
                                                    height: 80,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: listImageGallery[index].image != ''
                                                          ? CachedNetworkImage(
                                                              imageUrl: listImageGallery[index].image,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image(
                                                              image: FileImage(File(listImageGallery[index].imageFile!.path)),
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 110,
                                                    top: 5,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        if (listImageGallery[index].imageFile != null) {
                                                          setState(() {
                                                            listImageGallery.removeAt(index);
                                                          });
                                                        } else {
                                                          if (await Methods.checkConnectivity()) {
                                                            loadRemoveGalleryImage(listImageGallery[index]);
                                                          } else {
                                                            Methods.showSnackBar(context, Strings.err_internet_not_connected);
                                                          }
                                                        }
                                                      },
                                                      child: Methods.getAssetsWhiteIconWithBG(ColorsApp.primary, Images.ic_close, 5, 20, 20),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                            separatorBuilder: (context, index) => SizedBox(
                                              width: 10,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        ElevatedButton(
                                          onPressed: () async {
                                            List<XFile?> file = await _picker.pickMultiImage();
                                            setState(() {
                                              for (var itemFile in file) {
                                                listImageGallery.add(new ItemGallery(id: 0, image: '', imageFile: itemFile));
                                              }
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: ColorsApp.primary),
                                          child: Text('Add More'),
                                        )
                                      ]),
                                    ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  Strings.video_type,
                                  style: TextStyle(
                                    color: !SharedPref.isDarkMode() ? ColorsApp.text_bb : ColorsApp.text_bb_dark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).inputDecorationTheme.fillColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                                    style: BorderStyle.solid,
                                    width: 1.0,
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  dropdownColor: !SharedPref.isDarkMode() ? ColorsApp.bgCardNews : ColorsApp.bgCardNews_dark,
                                  items: listVideoType.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      videoFile = null;
                                      videoName = Strings.video_name;
                                      textInpCntVideoUrl.text = '';
                                      selectedVideoType = value!;
                                    });
                                  },
                                  value: selectedVideoType,
                                  underline: SizedBox(),
                                ),
                              ),
                              SizedBox(height: 15),
                              selectedVideoType == VIDEO_TYPE_URL
                                  ? TextField(
                                      controller: textInpCntVideoUrl,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.url,
                                      decoration: Methods.getEditTextInputDecoration(Strings.video_url),
                                      style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).inputDecorationTheme.fillColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 1.5,
                                          color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(videoName)),
                                          ElevatedButton(
                                              onPressed: () async {
                                                videoFile = await _picker.pickVideo(source: ImageSource.gallery);
                                                if (videoFile != null) {
                                                  setState(() {
                                                    videoName = videoFile!.name;
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(backgroundColor: ColorsApp.primary),
                                              child: Text('Browse')),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      child: DropdownButton<ItemCategories>(
                        isExpanded: true,
                        dropdownColor: !SharedPref.isDarkMode() ? ColorsApp.bgCardNews : ColorsApp.bgCardNews_dark,
                        items: listCategories.map<DropdownMenuItem<ItemCategories>>((ItemCategories value) {
                          return DropdownMenuItem<ItemCategories>(
                            value: value,
                            child: Text(
                              value.name,
                              style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                        value: selectedCategory,
                        underline: SizedBox(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: textInpCntTitle,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      decoration: Methods.getEditTextInputDecoration(Strings.news_title),
                      style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        openDatePicker(context);
                      },
                      child: TextField(
                        controller: textInpCntDate,
                        enabled: false,
                        decoration: Methods.getEditTextInputDecoration(Strings.date),
                        style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: textInpCntTags,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      decoration: Methods.getEditTextInputDecoration(Strings.add_tags),
                      style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                      onChanged: (value) {
                        if (value.contains(',')) {
                          setState(() {
                            listTags.add(value.replaceAll(',', ''));
                            textInpCntTags.clear();
                          });
                        }
                      },
                    ),
                    if (listTags.length > 0) SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: listTags.map((e) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(color: ColorsApp.primary, borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                e,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    listTags.remove(e);
                                  });
                                },
                                child: Image(width: 15, height: 15, image: AssetImage(Images.ic_close_circle)),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: textInpCntDescription,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 10,
                      decoration: Methods.getEditTextInputDecoration(Strings.description),
                      style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Theme.of(context).bottomNavigationBarTheme.backgroundColor, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              child: ElevatedButton(
                onPressed: () async {
                  if (await Methods.checkConnectivity()) {
                    if (validate()) {
                      loadUploadNews();
                    }
                  } else {
                    Methods.showSnackBar(context, Strings.err_internet_not_connected);
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
                  Strings.update_news,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validate() {
    if (selectedNewsType == NEWS_TYPE_VIDEO && selectedVideoType == VIDEO_TYPE_URL && textInpCntVideoUrl.text.trim() == '') {
      Methods.showSnackBar(context, Strings.err_enter_video_url);
      return false;
    } else if (selectedNewsType == NEWS_TYPE_VIDEO && selectedVideoType == VIDEO_TYPE_LOCAL && videoFile == null) {
      Methods.showSnackBar(context, Strings.err_select_video);
      return false;
    } else if (selectedCategory.id == 0) {
      Methods.showSnackBar(context, Strings.err_select_category);
      return false;
    } else if (textInpCntTitle.text.trim() == '') {
      Methods.showSnackBar(context, Strings.err_enter_news_title);
      return false;
    } else {
      return true;
    }
  }

  loadUploadNews() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CupertinoActivityIndicator(
              color: ColorsApp.primary,
              radius: 15,
            ),
          ),
        ),
      ),
    );
    ItemSuccess? itemSuccess;
    try {
      itemSuccess = await new ApiCLient().getNewsEdit(
          Constants.METHOD_EDIT_NEWS,
          SharedPref.getUserID().toString(),
          widget.itemNews.id.toString(),
          selectedCategory.id.toString(),
          selectedNewsType,
          selectedVideoType,
          textInpCntVideoUrl.text,
          textInpCntTitle.text,
          textInpCntDate.text,
          listTags.join(','),
          textInpCntDescription.text,
          featuredImage != null ? featuredImage!.path : '',
          listImageGallery,
          videoFile != null ? videoFile!.path : '');

      if (itemSuccess != null) {
        if (itemSuccess.success == '1') {
          Navigator.pop(context, true);
        }
        Methods.showSnackBar(context, itemSuccess.message);
      } else {}
    } catch (e) {}

    Navigator.pop(context);
  }

  loadRemoveGalleryImage(ItemGallery itemGallery) async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CupertinoActivityIndicator(
              color: ColorsApp.primary,
              radius: 15,
            ),
          ),
        ),
      ),
    );
    ItemSuccess? itemSuccess;
    try {
      itemSuccess = await new ApiCLient().getGalleryDelete(Constants.METHOD_REMOVE_GALLERY_IMAGE, itemGallery.id.toString());

      if (itemSuccess != null) {
        setState(() {
          listImageGallery.remove(itemGallery);
        });
        Methods.showSnackBar(context, itemSuccess.message);
      } else {}
    } catch (e) {}

    Navigator.pop(context);
  }

  loadCategories() async {
    // pageNumber = pageNumber + 1;
    if (Constants.arrayListCategories.length == 0) {
      Constants.arrayListCategories
          .addAll((await new ApiCLient().getCategories(Constants.METHOD_CATEGORIES, SharedPref.getUserID().toString())) as Iterable<ItemCategories>);

      setState(() {
        listCategories.addAll(Constants.arrayListCategories);
      });
    } else {
      listCategories.addAll(Constants.arrayListCategories);
    }

    for (var itemCat in listCategories) {
      if (itemCat.id == widget.itemNews.categoryID) {
        selectedCategory = itemCat;
        break;
      }
    }

    setState(() {});
  }

  Future<void> openDatePicker(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        textInpCntDate.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }
}
