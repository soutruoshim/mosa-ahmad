import 'dart:io';

import 'package:flutter_news_app/items/itemUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/pages/register.dart';
import 'package:flutter_news_app/resources/colors.dart';
import 'package:flutter_news_app/resources/strings.dart';
import 'package:flutter_news_app/utils/methods.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../apiservice/apiclient.dart';
import '../resources/images.dart';
import '../utils/auth_google.dart';
import '../utils/constants.dart';
import '../utils/sharedpref.dart';
import 'forgotpassword.dart';

class Login extends StatefulWidget {
  final isFromApp;

  const Login({super.key, required this.isFromApp});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isCheckBoxRemember = false, isCheckBoxTerms = false;
  final mq = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  final textInpControllerEmail = TextEditingController();
  final textInpControllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.size.height,
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                          backgroundColor: ColorsApp.primary,
                        ),
                        child: Text(Strings.skip),
                        onPressed: () {
                          if (!widget.isFromApp) {
                            Methods.openDashBoardPage(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      style: TextStyle(
                        color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                        fontWeight: FontWeight.w400,
                        fontSize: 30,
                        fontFamily: 'SairaStencil',
                        letterSpacing: 1,
                      ),
                      Strings.welcome,
                    ),
                    Text(
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                      Strings.sign_in_continue,
                    ),
                    SizedBox(height: 45),
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
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textInpControllerPassword,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
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
                    SizedBox(height: 35),
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckBoxRemember,
                          activeColor: ColorsApp.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: (onChanged) {
                            setState(() {
                              isCheckBoxRemember = !isCheckBoxRemember;
                            });
                          },
                        ),
                        Text(
                          Strings.remember_me,
                          style: TextStyle(
                            color: !SharedPref.isDarkMode() ? ColorsApp.login_remember : ColorsApp.login_remember_dark,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(child: SizedBox(height: 1)),
                        TextButton(
                          child: Text(
                            Strings.forgot_password,
                            style: TextStyle(
                              color: !SharedPref.isDarkMode() ? ColorsApp.login_remember : ColorsApp.login_remember_dark,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ForgotPassword();
                            }));
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (await Methods.checkConnectivity()) {
                          if (_formKey.currentState!.validate()) {
                            loadLogin();
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
                        Strings.log_in,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 15),
                    if (Platform.isAndroid)
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
                              onTap: () async {
                                _launchUrl(Uri.parse(Strings.url_terms_condition));
                              },
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        Strings.or_continue_with,
                        style: TextStyle(
                          color: !SharedPref.isDarkMode() ? ColorsApp.login_remember : ColorsApp.login_remember_dark,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                                backgroundColor: !SharedPref.isDarkMode() ? ColorsApp.button_social : ColorsApp.button_social_dark,
                                foregroundColor: !SharedPref.isDarkMode() ? ColorsApp.text_title : ColorsApp.text_title_dark,
                                elevation: 1,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                side: BorderSide(color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark)),
                            onPressed: () async {
                              if (await Methods.checkConnectivity()) {
                                Methods.showLoaderDialog(context, Strings.msg_loading);

                                try {
                                  User? user = await AuthGoogle.signInWithGoogle(context: context);
                                  Navigator.pop(context);
                                  if (user != null) {
                                    loadSocial(Constants.LOGIN_TYPE_GOOGLE, user.uid, user.displayName!, user.email!);
                                  }
                                } catch (e) {
                                  Navigator.pop(context);
                                  Methods.showSnackBar(context, Strings.err_google_sign_in);
                                }
                              } else {
                                Methods.showSnackBar(context, Strings.err_internet_not_connected);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 12,
                                  child: Image.asset(Images.ic_google),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  Strings.google,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (Platform.isIOS || Platform.isMacOS) SizedBox(height: 10),
                    if (Platform.isIOS || Platform.isMacOS)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                            backgroundColor: !SharedPref.isDarkMode() ? ColorsApp.button_social : ColorsApp.button_social_dark,
                            foregroundColor: !SharedPref.isDarkMode() ? ColorsApp.text_title : ColorsApp.text_title_dark,
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            side: BorderSide(color: !SharedPref.isDarkMode() ? ColorsApp.edittext_border : ColorsApp.edittext_border_dark)),
                        onPressed: () async {
                          if (await Methods.checkConnectivity()) {
                            //Methods.showLoaderDialog(context, Strings.msg_loading);
                            print("Apple Login");
                            appleSign();
                            // Method for apple login, remember to dismiss loader by uncommenting below line
                            // Navigator.pop(context);
                          } else {
                            Methods.showSnackBar(context, Strings.err_internet_not_connected);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 12,
                              child: Image.asset(Images.ic_apple),
                            ),
                            SizedBox(width: 10),
                            Text(
                              Strings.apple,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Strings.dont_have_ac,
                          style: TextStyle(
                            color: !SharedPref.isDarkMode() ? ColorsApp.login_remember : ColorsApp.login_remember_dark,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          child: Text(
                            Strings.sign_up,
                            style: TextStyle(color: ColorsApp.primary, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (builder) {
                              return Register();
                            }));
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

  void appleSign() async {
    AuthorizationResult authorizationResult = await TheAppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (authorizationResult.status) {
      case AuthorizationStatus.authorized:
        print("authorized");
        try {
          AppleIdCredential? appleCredentials = authorizationResult.credential;
          OAuthProvider oAuthProvider = OAuthProvider("apple.com");
          OAuthCredential oAuthCredential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleCredentials!.identityToken!),
              accessToken: String.fromCharCodes(appleCredentials.authorizationCode!));

          // print('User Name = ${appleCredentials.fullName!.givenName!} ${appleCredentials.fullName!.familyName!}');
          // print('User Email = ${appleCredentials.email}');
          // print('User ID = ${appleCredentials.identityToken.hashCode}');

          String name, email, hashCode;

          if (appleCredentials.fullName != null && appleCredentials.fullName!.givenName != null && appleCredentials.email != null) {
            name = appleCredentials.fullName!.givenName! + ' ' + appleCredentials.fullName!.familyName!;
            email = appleCredentials.email!;
            hashCode = appleCredentials.identityToken.hashCode.toString();

            SharedPref.setAppleID(hashCode);
            SharedPref.setAppleName(name);
            SharedPref.setAppleEmail(email);
          } else {
            hashCode = SharedPref.getAppleID();
            name = SharedPref.getAppleName();
            email = SharedPref.getAppleEmail();
          }

          loadSocial(Constants.LOGIN_TYPE_APPLE, hashCode, name, email);

          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
          if (userCredential.user != null) {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return Dashboard();
            // }));
            Methods.openDashBoardPage(context);
          }
        } catch (e) {
          print("apple auth failed $e");
        }

        break;
      case AuthorizationStatus.error:
        print("error" + authorizationResult.error.toString());
        break;
      case AuthorizationStatus.cancelled:
        print("cancelled");
        break;
      default:
        print("none of the above: default");
        break;
    }
  }

  loadLogin() async {
    Methods.showLoaderDialog(context, Strings.msg_sigin_in);

    ItemUser? itemUser = await new ApiCLient().getLogin(Constants.METHOD_LOGIN, textInpControllerEmail.text, textInpControllerPassword.text);

    Navigator.pop(context);

    if (itemUser != null) {
      if (itemUser.success == '1') {
        SharedPref.setUserInfo(itemUser.userID!, itemUser.userName, itemUser.userEmail, itemUser.userPhone, itemUser.userImage, '',
            Constants.LOGIN_TYPE_NORMAL, itemUser.isReporter);
        SharedPref.setUserPassword(textInpControllerPassword.text);
        SharedPref.setIsRemember(isCheckBoxRemember);
        SharedPref.setIsLogged(true);

        Methods.openDashBoardPage(context);

        Methods.showSnackBar(context, itemUser.message);
      } else {
        Methods.showSnackBar(context, itemUser.message);
      }
    }
  }

  loadSocial(String loginType, String socialID, String name, String email) async {
    Methods.showLoaderDialog(context, Strings.msg_sigin_in);

    ItemUser? itemUser = await new ApiCLient().getSocialLogin(Constants.METHOD_SOCIAL_LOGIN, loginType, socialID, name, email);

    Navigator.pop(context);

    if (itemUser != null) {
      if (itemUser.success == '1') {
        SharedPref.setUserInfo(
            itemUser.userID!, itemUser.userName, itemUser.userEmail, itemUser.userPhone, itemUser.userImage, '', loginType, itemUser.isReporter);
        SharedPref.setUserPassword('');
        SharedPref.setIsRemember(false);
        SharedPref.setIsLogged(true);

        Methods.openDashBoardPage(context);

        Methods.showSnackBar(context, itemUser.message);
      } else {
        Methods.showSnackBar(context, itemUser.message);
      }
    }
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}
