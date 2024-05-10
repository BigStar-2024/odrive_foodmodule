
import 'package:flutter/material.dart';
import 'package:odrive/pages/setting/forgotpassword.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../themes/theme.dart';

class PasswordScreen extends StatefulWidget
{
  final String userid;
  const PasswordScreen({required this.userid, super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}
class _PasswordScreenState extends State<PasswordScreen>
{
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Change Password"),
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        "Old password",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedPasswordField(
                        hintText: Languages.of(context)!.labelPlaceholderPassword,
                        controller: oldPasswordController,
                        onChanged: (value) {

                        },
                        error: _error,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "New password",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedPasswordField(
                        hintText: Languages.of(context)!.labelPlaceholderPassword,
                        controller: passwordController,
                        onChanged: (value) {

                        },
                        error: _error,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Renter password",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedPasswordField(
                        hintText: Languages.of(context)!.labelPlaceholderPassword,
                        controller: confirmPasswordController,
                        onChanged: (value) {

                        },
                        error: _error,
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ForgotPasswordScreen(userid: "1"),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Forgot password?",
                          style: text16Primary,
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                child: GestureDetector(
                  onTap: () async {

                  },
                  child: Container(
                    width: size.width - size.width / 5,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryColor
                    ),
                    child: Center(
                      child: Text(
                        'Confirm',
                        style: text16White,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}