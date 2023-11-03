import 'package:flutter_news_app/items/itemComments.dart';
import 'package:flutter_news_app/pages/bottomsheet_report.dart';
import 'package:flutter_news_app/resources/strings.dart';
import 'package:flutter_news_app/utils/methods.dart';
import 'package:flutter_news_app/utils/sharedpref.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';
import '../resources/images.dart';

class CommentModel extends StatelessWidget {
  final ItemComments itemComments;
  const CommentModel({super.key, required this.itemComments});

  @override
  Widget build(BuildContext context) {
    GlobalKey _menuKey = GlobalKey();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: !SharedPref.isDarkMode() ? ColorsApp.border_comment : ColorsApp.border_comment_dark,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  foregroundImage: NetworkImage(itemComments.userImage),
                  backgroundImage: AssetImage(Images.ic_profile),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemComments.userName,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      itemComments.date,
                      style: TextStyle(
                        color: !SharedPref.isDarkMode() ? ColorsApp.text_comment_date : ColorsApp.text_comment_date_dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                IconButton(
                    key: _menuKey,
                    onPressed: () {
                      final RenderBox renderBox = _menuKey.currentContext?.findRenderObject() as RenderBox;
                      final Size size = renderBox.size;
                      final Offset offset = renderBox.localToGlobal(Offset.zero);
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(offset.dx, offset.dy + size.height, offset.dx + size.width, offset.dy + size.height),
                        items: [
                          PopupMenuItem<String>(
                            child: Text(Strings.report),
                            value: Strings.report,
                            onTap: () {
                              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    ),
                                    builder: (context) {
                                      return BottomSheetReport(
                                        itemNews: null,
                                        itemComment: itemComments,
                                        reportType: 'Comment',
                                        reportSubmit: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    });
                              });
                            },
                          ),
                        ],
                      );
                    },
                    icon: Image(width: 5, image: AssetImage(Images.ic_more))),
              ],
            ),
            SizedBox(height: 10),
            Methods.getHorizontalGreyLine(1.0),
            SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                itemComments.comment,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
