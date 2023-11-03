import 'package:flutter_news_app/ads/banner_admob.dart';
import 'package:flutter_news_app/utils/constants.dart';
import 'package:flutter_news_app/pages/upload_news.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/pages/home.dart';
import 'package:flutter_news_app/pages/categories.dart';
import 'package:flutter_news_app/pages/news_by_latest.dart';
import 'package:flutter_news_app/pages/profile.dart';
import 'package:flutter_news_app/resources/colors.dart';

import '../ads/banner_wortise.dart';
import '../resources/images.dart';
import '../resources/strings.dart';
import '../utils/methods.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();

  static _DashboardState of(BuildContext context) => context.findAncestorStateOfType<_DashboardState>()!;
}

class _DashboardState extends State<Dashboard> {
  int selectedBottomNavPos = 0;
  final pages = [
    Home(),
    LatestNews(),
    Categories(),
    Profile(),
  ];

  @override
  void initState() {
    loadAppDetails(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Methods.showAlertBottomDialog(context, Strings.exit_app, Strings.sure_exit, Strings.cancel, Strings.exit_app) ?? false;
      },
      child: Container(
        decoration: Methods.getPageBgBoxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: pages[selectedBottomNavPos],
          floatingActionButton: Visibility(
            visible: SharedPref.isLogged() && SharedPref.isReporter(),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UploadNews();
                }));
              },
              backgroundColor: ColorsApp.primary,
              child: Icon(Icons.upload, color: Colors.white),
            ),
          ),
          // bottomNavigationBar: customBottomNav(),
          bottomNavigationBar: customBottomNavBar(),
        ),
      ),
    );
  }

  Widget customBottomNav() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 44,
                height: 38,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                decoration: BoxDecoration(
                    color: selectedBottomNavPos == 0
                        ? ColorsApp.bgBottomNavBarItemSelected
                        : !SharedPref.isDarkMode()
                            ? ColorsApp.bgBottomNavBarItemUnSelected
                            : ColorsApp.bgBottomNavBarItemUnSelected_dark,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      selectedBottomNavPos = 0;
                    });
                  },
                  icon: Icon(
                    Icons.home_outlined,
                    color: selectedBottomNavPos == 0 ? Colors.white : ColorsApp.bottomNavItem,
                    size: 23,
                  ),
                ),
              ),
              Container(
                width: 44,
                height: 38,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                decoration: BoxDecoration(
                    color: selectedBottomNavPos == 1
                        ? ColorsApp.bgBottomNavBarItemSelected
                        : !SharedPref.isDarkMode()
                            ? ColorsApp.bgBottomNavBarItemUnSelected
                            : ColorsApp.bgBottomNavBarItemUnSelected_dark,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      selectedBottomNavPos = 1;
                    });
                  },
                  icon: Icon(
                    Icons.list,
                    color: selectedBottomNavPos == 1 ? Colors.white : ColorsApp.bottomNavItem,
                    size: 23,
                  ),
                ),
              ),
              Container(
                width: 44,
                height: 38,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                decoration: BoxDecoration(
                    color: selectedBottomNavPos == 2
                        ? ColorsApp.bgBottomNavBarItemSelected
                        : !SharedPref.isDarkMode()
                            ? ColorsApp.bgBottomNavBarItemUnSelected
                            : ColorsApp.bgBottomNavBarItemUnSelected_dark,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      selectedBottomNavPos = 2;
                    });
                  },
                  icon: Icon(
                    Icons.live_tv,
                    color: selectedBottomNavPos == 2 ? Colors.white : ColorsApp.bottomNavItem,
                    size: 23,
                  ),
                ),
              ),
              Container(
                width: 44,
                height: 38,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                decoration: BoxDecoration(
                    color: selectedBottomNavPos == 3
                        ? ColorsApp.bgBottomNavBarItemSelected
                        : !SharedPref.isDarkMode()
                            ? ColorsApp.bgBottomNavBarItemUnSelected
                            : ColorsApp.bgBottomNavBarItemUnSelected_dark,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      selectedBottomNavPos = 3;
                    });
                  },
                  icon: Icon(
                    Icons.category,
                    color: selectedBottomNavPos == 3 ? Colors.white : ColorsApp.bottomNavItem,
                    size: 23,
                  ),
                ),
              ),
              Container(
                width: 44,
                height: 38,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                decoration: BoxDecoration(
                    color: selectedBottomNavPos == 4
                        ? ColorsApp.bgBottomNavBarItemSelected
                        : !SharedPref.isDarkMode()
                            ? ColorsApp.bgBottomNavBarItemUnSelected
                            : ColorsApp.bgBottomNavBarItemUnSelected_dark,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () async {
                    try {
                      if (SharedPref.isLogged()) {
                        setState(() {
                          selectedBottomNavPos = 4;
                        });
                      } else {
                        Methods.openLoginPage(context, true);
                      }
                    } catch (e) {}
                  },
                  icon: Icon(
                    Icons.person_4_rounded,
                    color: selectedBottomNavPos == 4 ? Colors.white : ColorsApp.bottomNavItem,
                    size: 23,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Constants.adType == Constants.AD_TYPE_ADMOB ? BannerAdmob() : BannerWortise(),
        ),
      ],
    );
  }

  loadAppDetails(context) async {
    Methods.loadAppDetails(context, false, false, () {});
  }

  void openLatestTab() {
    setState(() {
      selectedBottomNavPos = 1;
    });
  }

  Widget customBottomNavBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          type: BottomNavigationBarType.shifting,
          currentIndex: selectedBottomNavPos,
          items: [
            BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: selectedBottomNavPos == 0 ? ColorsApp.bgBottomNavBarItemSelected : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(50))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image: AssetImage(Images.ic_home),
                        width: 23,
                        color: selectedBottomNavPos == 0 ? Colors.white : ColorsApp.primary,
                      ),
                      if (selectedBottomNavPos == 0) SizedBox(width: 5),
                      if (selectedBottomNavPos == 0) Text(Strings.home, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: selectedBottomNavPos == 1 ? ColorsApp.bgBottomNavBarItemSelected : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(50))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image: AssetImage(Images.ic_latest),
                        width: 23,
                        color: selectedBottomNavPos == 1 ? Colors.white : ColorsApp.primary,
                      ),
                      if (selectedBottomNavPos == 1) SizedBox(width: 5),
                      if (selectedBottomNavPos == 1) Text(Strings.latest, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: selectedBottomNavPos == 2 ? ColorsApp.bgBottomNavBarItemSelected : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(50))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image: AssetImage(Images.ic_category),
                        width: 23,
                        color: selectedBottomNavPos == 2 ? Colors.white : ColorsApp.primary,
                      ),
                      if (selectedBottomNavPos == 2) SizedBox(width: 5),
                      if (selectedBottomNavPos == 2) Text(Strings.categories, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: selectedBottomNavPos == 3 ? ColorsApp.bgBottomNavBarItemSelected : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(50))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image: AssetImage(Images.ic_bottom_profile),
                        width: 23,
                        color: selectedBottomNavPos == 3 ? Colors.white : ColorsApp.primary,
                      ),
                      if (selectedBottomNavPos == 3) SizedBox(width: 5),
                      if (selectedBottomNavPos == 3) Text(Strings.profile, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                label: ''),
          ],
          onTap: (value) {
            if (value != 3 || SharedPref.isLogged()) {
              setState(() {
                selectedBottomNavPos = value;
              });
            } else {
              Methods.openLoginPage(context, true);
            }
          },
        ),
      ),
    );
  }
}
