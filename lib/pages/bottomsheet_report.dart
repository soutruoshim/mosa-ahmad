import 'package:flutter_news_app/items/itemComments.dart';
import 'package:flutter/material.dart';

import '../apiservice/apiclient.dart';
import '../items/itemNews.dart';
import '../items/itemSuccess.dart';
import '../resources/colors.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';

class BottomSheetReport extends StatefulWidget {
  final ItemNews? itemNews;
  final ItemComments? itemComment;
  final Function reportSubmit;
  final String reportType;
  const BottomSheetReport({super.key, required this.itemNews, required this.itemComment, required this.reportType, required this.reportSubmit});

  @override
  _BottomSheetReportState createState() => _BottomSheetReportState();
}

class _BottomSheetReportState extends State<BottomSheetReport> with SingleTickerProviderStateMixin {
  final textInpControllerReport = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        child: Wrap(children: [
          Container(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 35,
                      height: 4,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: !SharedPref.isDarkMode() ? ColorsApp.line_vertical_grey_80 : ColorsApp.line_vertical_grey_dark,
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      Strings.report_news,
                      style: TextStyle(
                        color: ColorsApp.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 1,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: !SharedPref.isDarkMode() ? ColorsApp.line_vertical_grey_80 : ColorsApp.line_vertical_grey_dark,
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: textInpControllerReport,
                      textInputAction: TextInputAction.newline,
                      minLines: 5,
                      maxLines: 5,
                      onSubmitted: (value) {
                        if (SharedPref.isLogged()) {
                          if (widget.reportType == 'News') {
                            loadReport(context, widget.itemNews!.id.toString(), textInpControllerReport.text);
                          } else {
                            loadReport(context, widget.itemComment!.id.toString(), textInpControllerReport.text);
                          }
                        } else {
                          widget.reportSubmit.call();
                          Methods.showSnackBar(context, Strings.login_to_continue);
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        filled: true,
                        fillColor: !SharedPref.isDarkMode() ? Colors.white : ColorsApp.edittext_comment,
                        hintText: Strings.enter_report,
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(Strings.cancel, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ColorsApp.primary,
                              side: BorderSide(color: ColorsApp.primary),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (SharedPref.isLogged()) {
                                if (widget.reportType == 'News') {
                                  loadReport(context, widget.itemNews!.id.toString(), textInpControllerReport.text);
                                } else {
                                  loadReport(context, widget.itemComment!.id.toString(), textInpControllerReport.text);
                                }
                              } else {
                                widget.reportSubmit.call();
                                Methods.showSnackBar(context, Strings.login_to_continue);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(Strings.submit, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsApp.primary,
                              shape: StadiumBorder(),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        ]),
      ),
    );
  }

  loadReport(BuildContext context, String postID, String message) async {
    Methods.showLoaderDialog(context, Strings.msg_loading);

    ItemSuccess? itemSuccess;
    try {
      itemSuccess = await new ApiCLient().getReport(Constants.METHOD_REPORTS, SharedPref.getUserID().toString(), postID, widget.reportType, message);

      if (itemSuccess != null) {
        Methods.showSnackBar(context, itemSuccess.message);
      } else {
        Methods.showSnackBar(context, Strings.err_server);
      }
    } catch (e) {}

    Navigator.pop(context);
    widget.reportSubmit.call();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
