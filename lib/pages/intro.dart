import 'package:flutter_news_app/resources/images.dart';
import 'package:flutter_news_app/utils/methods.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';
import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter_news_app/resources/strings.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Methods.getPageBgBoxDecoration(),
        child: Onboarding(
          pages: [
            getPageModelDesign(Images.ic_intro_1, Strings.intro1MainText, Strings.intro1SubText),
            getPageModelDesign(Images.ic_intro_2, Strings.intro2MainText, Strings.intro2SubText),
            getPageModelDesign(Images.ic_intro_3, Strings.intro3MainText, Strings.intro3SubText),
          ],
          onPageChange: (index) {
            pageIndex = index;
          },
          startPageIndex: 0,
          footerBuilder: (context, dragDistance, pagesLength, setIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: CustomIndicator(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      shouldPaint: true,
                      indicator: Indicator(
                        activeIndicator: ActiveIndicator(
                          color: ColorsApp.indicatorActive,
                        ),
                        closedIndicator: ClosedIndicator(
                          color: ColorsApp.indicatorClosed,
                        ),
                        indicatorDesign: IndicatorDesign.polygon(
                          polygonDesign: PolygonDesign(
                            polygon: DesignType.polygon_circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  pageIndex == pagesLength - 1 ? startButton() : skipButton(index: setIndex),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  skipButton({void Function(int)? index}) {
    return TextButton(
      onPressed: () {
        if (index != null) {
          pageIndex = 2;
          index(2);
        }
      },
      child: Text(
        'Skip',
        selectionColor: ColorsApp.bgBottomNavBarItemUnSelected,
        style: TextStyle(
          color: !SharedPref.isDarkMode() ? Colors.grey[600] : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  startButton() {
    return ElevatedButton(
      onPressed: () {
        Methods.openDashBoardPage(context);

      },
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        padding: EdgeInsets.fromLTRB(17, 6, 17, 6),
        backgroundColor: ColorsApp.primary,
      ),
      child: Text(
        Strings.get_started,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  PageModel getPageModelDesign(imageName, textMain, textSub) {
    return PageModel(
      widget: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Stack(
                children: [
                  Image.asset(Images.bg_intro, width: double.maxFinite, height: 200, fit: BoxFit.contain),
                  Padding(
                    padding: EdgeInsets.all(50),
                    child: Image.asset(
                      imageName,
                      width: double.maxFinite,
                      height: 170,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                '$textMain',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                  fontWeight: FontWeight.w400,
                  fontSize: 32,
                  fontFamily: 'SairaStencil',
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$textSub',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: !SharedPref.isDarkMode() ? ColorsApp.text_90 : ColorsApp.text_90_dark,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  fontSize: 17,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
