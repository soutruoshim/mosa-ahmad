import 'package:flutter_news_app/models/appbar_model.dart';
import 'package:flutter_news_app/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class WebView extends StatelessWidget {
  var htmlData, pageName;

  WebView({super.key, required this.pageName, required this.htmlData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarCustom(appBarTitle: pageName, isSettings: false),
        body: SingleChildScrollView(child: Html(data: htmlData)),
      ),
    );
  }
}
