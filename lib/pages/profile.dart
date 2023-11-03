import 'package:flutter_news_app/items/itemNews.dart';
import 'package:flutter_news_app/items/itemSuccess.dart';
import 'package:flutter_news_app/models/news_model.dart';
import 'package:flutter_news_app/models/tablet/news_model_tablet.dart';
import 'package:flutter_news_app/pages/news_by_fav.dart';
import 'package:flutter_news_app/pages/profile_edit.dart';
import 'package:flutter_news_app/utils/methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../apiservice/apiclient.dart';
import '../items/itemUsers.dart';
import '../resources/colors.dart';
import '../resources/images.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/sharedpref.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    if (Constants.isProfileLoaded) {
      return ProfileUI();
    } else {
      return Center(
          child: FutureBuilder<ItemUser?>(
        future: loadProfile(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            ItemUser itemUser = snapshot.data;
            SharedPref.setUserInfo(itemUser.userID!, itemUser.userName, itemUser.userEmail, itemUser.userPhone, itemUser.userImage, '',
                SharedPref.getLoginType(), itemUser.isReporter);
            return ProfileUI();
          } else if (snapshot.hasError) {
            return Methods.getErrorEmpty(Strings.err_connecting_server);
          } else {
            return CustomProgressBar();
          }
        },
      ));
    }
  }

  Future<ItemUser?> loadProfile() async {
    return await new ApiCLient().getProfile(Constants.METHOD_PROFILE, SharedPref.getUserID().toString());
  }
}

class ProfileUI extends StatefulWidget {
  const ProfileUI({super.key});

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  late ScrollController scrollController;
  double appBarRadius = 30.0, expandedAppBarHeight = 250.0;
  bool isAppBarExpanded = true, isInternet = false;
  List<ItemNews>? listNews = [];
  bool isLoading = true;

  @override
  void initState() {
    if (SharedPref.isReporter()) {
      loadUserNews();
    }
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
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        new SliverAppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(appBarRadius),
            ),
          ),
          title: Text(Strings.profile,
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
                  padding: EdgeInsetsDirectional.fromSTEB(25, 35, 25, 35),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(SharedPref.getUserImage()),
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                SharedPref.getUserEmail(),
                                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 5),
                              Text(SharedPref.getUserPhone(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  )),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return NewsByFav();
                                  }));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  decoration: BoxDecoration(color: ColorsApp.bg_white_30, borderRadius: BorderRadius.circular(30)),
                                  child: Text(Strings.favourite,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 5, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Image.asset(Images.ic_edit),
                  onPressed: () async {
                    bool isChanged = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ProfileEdit();
                    }));
                    if (isChanged) {
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 10, 10, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Image.asset(Images.ic_delete),
                  onPressed: () async {
                    bool? flag = await Methods.showAlertBottomDialog(
                        context, Strings.delete_account, Strings.delete_account_msg, Strings.cancel, Strings.delete);
                    if (flag != null) {
                      if (flag) {
                        loadDeleteAccount();
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        SliverPadding(
          padding: EdgeInsetsDirectional.fromSTEB(15, 15, 0, 20),
          sliver: SliverToBoxAdapter(
            child: Text(Strings.hello + ' ' + SharedPref.getUserName(),
                style: TextStyle(
                    color: !SharedPref.isDarkMode() ? ColorsApp.text_bb : ColorsApp.text_bb_dark, fontSize: 18, fontWeight: FontWeight.w600)),
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 20),
          sliver: SliverToBoxAdapter(child: Methods.getHorizontalGreyLine(1)),
        ),
        !SharedPref.isReporter()
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 55),
                  child: ElevatedButton(
                      onPressed: () {
                        loadReporterRequest();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        backgroundColor: ColorsApp.primary,
                      ),
                      child: Text(Strings.apply_as_reporter)),
                ),
              )
            : !isLoading
                ? listNews == null
                    ? SliverToBoxAdapter(child: Methods.getErrorEmpty(Strings.err_connecting_server))
                    : listNews!.length > 0
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                            childCount: listNews!.length,
                            (context, index) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: SharedPref.getDeviceType() == 'mobile'
                                      ? NewsModel(itemNews: listNews![index], height: Constants.newsItemHeight, isNewsEdit: true)
                                      : NewsModelTablet(itemNews: listNews![index], height: Constants.newsItemHeight, isNewsEdit: true));
                            },
                          ))
                        : SliverToBoxAdapter(
                            child: isInternet
                                ? Methods.getErrorEmpty(Strings.err_no_data_found)
                                : Methods.getErrorEmpty(Strings.err_internet_not_connected),
                          )
                : SliverToBoxAdapter(child: CustomProgressBar()),
      ],
    );
  }

  bool get getAppBarExpanded {
    return scrollController.hasClients && scrollController.offset > (expandedAppBarHeight - kToolbarHeight);
  }

  loadUserNews() async {
    if (await Methods.checkConnectivity()) {
      isInternet = true;
      try {
        isLoading = true;
        listNews = await new ApiCLient().getNewsByUser(Constants.METHOD_NEWS_BY_USER, SharedPref.getUserID().toString());
      } catch (e) {}

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

  loadReporterRequest() async {
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

    ItemSuccess? itemSuccess = await new ApiCLient().getReporterRequest(Constants.METHOD_REPORTER_REQUEST, SharedPref.getUserID().toString());
    if (itemSuccess != null) {
      Methods.showSnackBar(context, itemSuccess.message);
    } else {
      Methods.showSnackBar(context, Strings.err_connecting_server);
    }
    Navigator.pop(context);
  }

  loadDeleteAccount() async {
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

    ItemSuccess? itemSuccess = await new ApiCLient().getDeleteUserAccount(Constants.METHOD_DELETE_USER_ACCOUNT, SharedPref.getUserID().toString());
    if (itemSuccess != null) {
      Navigator.pop(context);
      Methods.showSnackBar(context, itemSuccess.message);
      Methods.logout(context, false);
    } else {
      Methods.showSnackBar(context, Strings.err_connecting_server);
    }
  }
}
