import 'package:flutter_news_app/items/itemSuccess.dart';
import 'package:flutter_news_app/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../apiservice/apiclient.dart';
import '../models/appbar_model.dart';
import '../resources/colors.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final textInpControllerEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_rounded,
              color: SharedPref.isDarkMode() ? Colors.white : Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            Strings.forgot_password,
            style: TextStyle(
              color: Theme.of(context).appBarTheme.titleTextStyle!.color,
              fontWeight: FontWeight.w400,
              fontFamily: 'SairaStencil',
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    Strings.forgot_password,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  Strings.forgot_password_inst,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !SharedPref.isDarkMode() ? ColorsApp.login_remember : ColorsApp.login_remember_dark,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 60),
                Form(
                  key: _formKey,
                  child: TextFormField(
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
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (await Methods.checkConnectivity()) {
                      if (_formKey.currentState!.validate()) {
                        loadForgotPassword(context);
                      }
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
                    Strings.send,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 55),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loadForgotPassword(context) async {
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

    ItemSuccess? itemSuccess = await new ApiCLient().getForgotPassword(Constants.METHOD_FORGOT_PASSWORD, textInpControllerEmail.text);

    Navigator.pop(context);

    if (itemSuccess != null) {
      Methods.showSnackBar(context, itemSuccess.message);
    }
  }
}
