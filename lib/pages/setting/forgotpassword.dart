
import 'package:flutter/material.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../themes/theme.dart';

class ForgotPasswordScreen extends StatefulWidget
{
  final String userid;
  const ForgotPasswordScreen({required this.userid, super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
{
  TextEditingController passwordController = TextEditingController();
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Forgot Password"),
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.0),
                      RoundedPasswordField(
                        hintText: Languages.of(context)!.labelPlaceholderPassword,
                        controller: passwordController,
                        onChanged: (value) {

                        },
                        error: _error,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Password reset link has been sent to your email.",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        "Please check mail box or spam:\ndinh********@gmail.com",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 24.0),
                      Container(
                        child: GestureDetector(
                          onTap: () async {

                          },
                          child: Container(
                            width: size.width,
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
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        "Haven’t receive the email? Sent OTP via SMS",
                        style: text16GrayScale100,
                      ),
                    ],
                  )
              ),

            ],
          ),
        )
    );
  }
}