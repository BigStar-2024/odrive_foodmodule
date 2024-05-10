
import 'package:flutter/material.dart';
import 'package:odrive/pages/setting/password.dart';
import 'package:odrive/pages/setting/personal.dart';
import 'package:odrive/pages/setting/personaledit.dart';

import '../../components/appbar.dart';
import '../../themes/theme.dart';

class MyAccountScreen extends StatefulWidget
{
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen>
{
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "My Account"),
        body: SingleChildScrollView(
            child: Stack(
                children: [
                  Container(
                    width: size.width,
                    margin: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16.0),
                        GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => PersonalScreen(userid: "1"),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Personal Information", style: text16GrayScale90),
                                  Icon(Icons.arrow_forward_ios, color: greyColor800, size: 20),
                                ],
                              ),
                            )
                        ),
                        Divider(height: 1.0, color: greyColor800),
                        GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => PersonalEditScreen(userid: "1"),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Personal Editing", style: text16GrayScale90),
                                  Icon(Icons.arrow_forward_ios, color: greyColor800, size: 20),
                                ],
                              ),
                            )
                        ),
                        Divider(height: 1.0, color: greyColor800),
                        GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => PasswordScreen(userid: "1"),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Change Password", style: text16GrayScale90),
                                  Icon(Icons.arrow_forward_ios, color: greyColor800, size: 20),
                                ],
                              ),
                            )
                        ),
                        Divider(height: 1.0, color: greyColor800),
                        GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, "/help");
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Help", style: text16GrayScale90),
                                  Icon(Icons.arrow_forward_ios, color: greyColor800, size: 20),
                                ],
                              ),
                            )
                        ),
                        Divider(height: 1.0, color: greyColor800),
                        SizedBox(height: 40),
                        GestureDetector(
                          onTap: () async {

                          },
                          child: Container(
                            width: size.width - size.width / 5,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: primaryColor),
                            child: Center(
                              child: Text(
                                'Log out',
                                style: text16White,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
            )
        )
    );
  }
}