import 'package:flutter/material.dart';

import '../apiservice/apiclient.dart';
import '../items/itemComments.dart';
import '../items/itemNews.dart';
import '../items/itemSuccess.dart';
import '../models/comment_model.dart';
import '../resources/colors.dart';
import '../resources/images.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';

class BottomSheetComment extends StatefulWidget {
  final ItemNews itemNews;
  const BottomSheetComment({super.key, required this.itemNews});

  @override
  _BottomSheetCommentState createState() => _BottomSheetCommentState();
}

class _BottomSheetCommentState extends State<BottomSheetComment> with SingleTickerProviderStateMixin {
  final textInpControllerComment = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: !SharedPref.isDarkMode() ? ColorsApp.bg_comment_dialog : ColorsApp.bg_comment_dialog_dark,
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                Strings.comments,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 15, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 15),
              Text(
                widget.itemNews.totalComment,
                style: TextStyle(color: ColorsApp.primary, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Expanded(child: SizedBox(width: 15)),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image(width: 16, height: 16, image: AssetImage(Images.ic_close)),
              ),
            ],
          ),
          SizedBox(height: 15),
          Methods.getHorizontalGreyLine(1.5),
          SizedBox(height: 15),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                foregroundImage: NetworkImage(SharedPref.getUserImage()),
                backgroundImage: AssetImage(Images.ic_profile),
              ),
              SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: textInpControllerComment,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    if (SharedPref.isLogged()) {
                      loadAddComment(textInpControllerComment.text);
                    } else {
                      Methods.openLoginPage(context, true);
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    filled: true,
                    fillColor: !SharedPref.isDarkMode() ? Colors.white : ColorsApp.edittext_comment,
                    hintText: Strings.comments,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        width: 1.5,
                        color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        width: 1.5,
                        color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                  onTap: () {
                    if (SharedPref.isLogged()) {
                      loadAddComment(textInpControllerComment.text);
                    } else {
                      Methods.openLoginPage(context, true);
                    }
                  },
                  child: Icon(Icons.send)),
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: FutureBuilder(
              future: loadComments(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  // List<ItemComments> arrayList = snapshot.data;
                  widget.itemNews.arrayListComments = snapshot.data;
                  return ListView.separated(
                    controller: scrollController,
                    itemCount: widget.itemNews.arrayListComments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CommentModel(itemComments: widget.itemNews.arrayListComments[index]);
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 12,
                    ),
                  );
                } else {
                  return CustomProgressBar();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<ItemComments>?> loadComments() async {
    return await new ApiCLient().getComments(Constants.METHOD_COMMENT_LIST, widget.itemNews.id.toString());
  }

  loadAddComment(String comment) async {
    FocusManager.instance.primaryFocus?.unfocus();

    ItemSuccess? itemSuccess =
        await new ApiCLient().getAddComment(Constants.METHOD_POST_COMMENT, widget.itemNews.id.toString(), comment, SharedPref.getUserID().toString());

    if (itemSuccess != null) {
      widget.itemNews.arrayListComments
          .add(new ItemComments(itemSuccess.commentID!, comment, itemSuccess.date!, SharedPref.getUserName(), SharedPref.getUserImage()));
      Methods.showSnackBar(context, itemSuccess.message);
      setState(() {
        textInpControllerComment.clear();
        widget.itemNews.totalComment = (int.parse(widget.itemNews.totalComment) + 1).toString();
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.elasticOut);
        }
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
