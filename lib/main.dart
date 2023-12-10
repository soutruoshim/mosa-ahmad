import 'dart:io';

import 'package:flutter_news_app/pages/splash.dart';
import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter_news_app/resources/strings.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  await SharedPref.init();
  await Firebase.initializeApp();

  // OneSignal.shared.setAppId(Strings.onesignal_app_id);
  // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //   print("Accepted permission: $accepted");
  // });

  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en"), // english
        Locale("ar"), // arabic
      ],
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      // standard dark theme
      themeMode: !SharedPref.isDarkMode() ? ThemeMode.light : ThemeMode.dark,
      // device controls theme
      home: const Splash(),
    );
  }

  void changeTheme(bool isDarkMode) {
    setState(() {
      SharedPref.setIsDarkMode(isDarkMode);
    });
  }

  ThemeData lightTheme = new ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Inter',
    cardColor: ColorsApp.bgCardNews,
    appBarTheme: AppBarTheme(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: ColorsApp.appbar_title, fontSize: 20, fontWeight: FontWeight.w800)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: ColorsApp.bgBottomNavBar),
    textTheme: TextTheme(
      bodyLarge: TextStyle(backgroundColor: ColorsApp.bg_date, color: ColorsApp.text_title),
      bodyMedium: TextStyle(color: ColorsApp.text_comment_title),
      bodySmall: TextStyle(color: ColorsApp.text_90),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: ColorsApp.bg_edit_text,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 1.5, color: ColorsApp.edittext_border)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 1.5, color: ColorsApp.edittext_border)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(textStyle: MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.bold)))),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: ColorsApp.bg_bottomsheet, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
    checkboxTheme: CheckboxThemeData(
        side: BorderSide(width: 2, color: ColorsApp.border_checkbox),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        )),
  );

  ThemeData darkTheme = new ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    cardColor: ColorsApp.bgCardNews_dark,
    appBarTheme: AppBarTheme(
        actionsIconTheme: IconThemeData(color: ColorsApp.bg_icons_settings),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: ColorsApp.appbar_title_dark, fontSize: 20, fontWeight: FontWeight.w800)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: ColorsApp.bgBottomNavBar_dark),
    textTheme: TextTheme(
      bodyLarge: TextStyle(backgroundColor: ColorsApp.bg_date_dark, color: ColorsApp.text_title_dark),
      bodyMedium: TextStyle(color: ColorsApp.text_comment_title_dark),
      bodySmall: TextStyle(color: ColorsApp.text_90_dark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: ColorsApp.bg_edit_text_dark,
      hintStyle: TextStyle(color: Colors.white60),
      labelStyle: TextStyle(color: Colors.white60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 1.5, color: ColorsApp.edittext_border_dark)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 1.5, color: ColorsApp.edittext_border_dark)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(textStyle: MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.bold)))),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ColorsApp.bg_bottomsheet_dark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
    checkboxTheme: CheckboxThemeData(
        side: BorderSide(width: 2, color: ColorsApp.border_checkbox_dark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        )),
  );
}
