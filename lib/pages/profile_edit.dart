import 'package:flutter_news_app/resources/images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/utils/methods.dart';

import '../apiservice/apiclient.dart';
import '../items/itemSuccess.dart';
import '../resources/colors.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/sharedpref.dart';
import 'dart:io';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  ImagePicker _picker = ImagePicker();
  XFile? uploadImage;
  late ScrollController scrollController;
  double appBarRadius = 30.0, expandedAppBarHeight = 250.0;
  bool isAppBarExpanded = true;

  final _formKey = GlobalKey<FormState>();

  late final textInpControllerName = TextEditingController(text: SharedPref.getUserName());
  late final textInpControllerEmail = TextEditingController(text: SharedPref.getUserEmail());
  late final textInpControllerPhone = TextEditingController(text: SharedPref.getUserPhone());
  final textInpControllerPassword = TextEditingController();
  final textInpControllerCPassword = TextEditingController();

  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(
        () {
          if (getAppBarExpanded) {
            if (!isAppBarExpanded) {
              isAppBarExpanded = true;
              setState(() {
                appBarRadius = 0;
              });
            }
          } else {
            if (isAppBarExpanded) {
              isAppBarExpanded = false;
              setState(() {
                appBarRadius = 30;
              });
            }
          }
        },
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(appBarRadius),
                      ),
                    ),
                    title: Text(Strings.edit_profile,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    expandedHeight: expandedAppBarHeight,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(appBarRadius), bottomRight: Radius.circular(appBarRadius)),
                        gradient: LinearGradient(
                          begin: AlignmentDirectional.topEnd,
                          end: AlignmentDirectional.bottomStart,
                          colors: [ColorsApp.gradient1, ColorsApp.gradient2],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(appBarRadius), bottomRight: Radius.circular(appBarRadius)),
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.topEnd,
                            end: AlignmentDirectional.bottomStart,
                            colors: [ColorsApp.gradient1, ColorsApp.gradient2],
                          ),
                          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(Images.bg_profile_appbar)),
                        ),
                        child: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: Container(
                            padding: EdgeInsets.only(bottom: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    if (uploadImage == null)
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(SharedPref.getUserImage()),
                                      ),
                                    if (uploadImage != null)
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(File(uploadImage!.path)),
                                      ),
                                    Positioned(
                                      left: 66,
                                      top: 72,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: GestureDetector(
                                          child: Image.asset(Images.ic_upload),
                                          onTap: () async {
                                            uploadImage = await _picker.pickImage(source: ImageSource.gallery);
                                            if (uploadImage == null) {
                                            } else {
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: ColorsApp.bg_white_30,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SharedPref.getUserName()),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ];
              },
              body: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 25),
                        TextFormField(
                          controller: textInpControllerName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: Methods.getEditTextInputDecoration(Strings.name),
                          style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return Strings.err_enter_valid_name;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: textInpControllerEmail,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: Methods.getEditTextInputDecoration(Strings.email),
                          style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                          validator: (text) {
                            if (text == null || text.isEmpty || !(text.contains('@'))) {
                              return Strings.err_enter_valid_email;
                            }
                            return null;
                          },
                          enabled: SharedPref.getLoginType() == Constants.LOGIN_TYPE_NORMAL,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: textInpControllerPassword,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: Methods.getEditTextInputDecoration(Strings.password),
                          style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          controller: textInpControllerCPassword,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: Methods.getEditTextInputDecoration(Strings.cpassword),
                          style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                          validator: (text) {
                            if (text != textInpControllerPassword.text) {
                              return Strings.err_password_not_matched;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: textInpControllerPhone,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.phone,
                          decoration: Methods.getEditTextInputDecoration(Strings.phone),
                          style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return Strings.err_enter_valid_phone;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: ElevatedButton(
              onPressed: () async {
                if (await Methods.checkConnectivity()) {
                  if (_formKey.currentState!.validate()) {
                    loadProfileEdit();
                  }
                } else {
                  Methods.showSnackBar(context, Strings.err_internet_not_connected);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                backgroundColor: ColorsApp.primary,
              ),
              child: Text(
                Strings.update,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  bool get getAppBarExpanded {
    return scrollController.hasClients && scrollController.offset > (expandedAppBarHeight - kToolbarHeight);
  }

  loadProfileEdit() async {
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
      itemSuccess = await new ApiCLient().getProfileEdit(
          Constants.METHOD_PROFILE_UPDATE,
          SharedPref.getUserID().toString(),
          textInpControllerName.text,
          textInpControllerEmail.text,
          textInpControllerPhone.text,
          textInpControllerPassword.text,
          uploadImage != null ? uploadImage!.path : '');
    } catch (e) {}

    Navigator.pop(context);

    try {
      if (itemSuccess != null) {
        if (itemSuccess.success == '1') {
          SharedPref.setUserInfo(SharedPref.getUserID(), textInpControllerName.text, textInpControllerEmail.text, textInpControllerPhone.text,
              itemSuccess.userImage, '', SharedPref.getLoginType(), SharedPref.isReporter());
          if (textInpControllerPassword.text != '') {
            SharedPref.setUserPassword('');
            SharedPref.setIsRemember(false);
          }
          Methods.showSnackBar(context, itemSuccess.message);
          Navigator.pop(context, true);
        } else {
          Methods.showSnackBar(context, itemSuccess.message);
        }
      }
    } catch (e) {}
  }
}
