import 'dart:io' as Device;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../apiservice/apiclient.dart';
import '../items/itemSuccess.dart';
import '../resources/colors.dart';
import '../resources/strings.dart';
import '../utils/constants.dart';
import '../utils/methods.dart';
import '../utils/sharedpref.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isCheckBoxTerms = false;
  final mq = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  final _formKey = GlobalKey<FormState>();

  final textInpControllerName = TextEditingController();
  final textInpControllerEmail = TextEditingController();
  final textInpControllerPassword = TextEditingController();
  final textInpControllerCPassword = TextEditingController();
  final textInpControllerPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.size.height,
      width: mq.size.width,
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      style: TextStyle(
                        color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                        fontWeight: FontWeight.w400,
                        fontSize: 30,
                        fontFamily: 'SairaStencil',
                        letterSpacing: 1,
                      ),
                      Strings.sign_up,
                    ),
                    SizedBox(height: 45),
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
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: textInpControllerPassword,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: Methods.getEditTextInputDecoration(Strings.password),
                      style: TextStyle(color: !SharedPref.isDarkMode() ? Colors.black : Colors.white),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return Strings.err_enter_valid_password;
                        }
                        return null;
                      },
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
                        if (text == null || text.isEmpty) {
                          return Strings.err_enter_valid_password;
                        } else if (text != textInpControllerPassword.text) {
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
                      // validator: (text) {
                      //   if (text == null || text.isEmpty) {
                      //     return Strings.err_enter_valid_phone;
                      //   }
                      //   return null;
                      // },
                    ),
                    SizedBox(height: 10),
                    if (Device.Platform.isAndroid)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isCheckBoxTerms,
                            activeColor: ColorsApp.primary,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onChanged: (onChanged) {
                              setState(() {
                                isCheckBoxTerms = !isCheckBoxTerms;
                              });
                            },
                          ),
                          Text(
                            Strings.i_read_agreed,
                            style: TextStyle(
                              color: !SharedPref.isDarkMode() ? ColorsApp.login_remember : ColorsApp.login_remember_dark,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: GestureDetector(
                              child: Text(
                                Strings.terms_of_use,
                                style: TextStyle(color: ColorsApp.primary, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                _launchUrl(Uri.parse(Strings.url_terms_condition));
                              },
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (await Methods.checkConnectivity()) {
                          if (_formKey.currentState!.validate()) {
                            loadRegister();
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
                        Strings.register,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Strings.already_have_ac,
                          style: TextStyle(
                            color: !SharedPref.isDarkMode() ? ColorsApp.login_remember : ColorsApp.login_remember_dark,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          child: Text(
                            Strings.log_in,
                            style: TextStyle(color: ColorsApp.primary, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  loadRegister() async {
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

    ItemSuccess? itemSuccess = await new ApiCLient().getRegister(Constants.METHOD_REGISTER, textInpControllerName.text, textInpControllerEmail.text,
        textInpControllerPhone.text, textInpControllerPassword.text);

    Navigator.pop(context);

    if (itemSuccess != null) {
      if (itemSuccess.success == '1') {
        Navigator.pop(context);
        Methods.showSnackBar(context, itemSuccess.message);
      } else {
        Methods.showSnackBar(context, itemSuccess.message);
      }
    }
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
