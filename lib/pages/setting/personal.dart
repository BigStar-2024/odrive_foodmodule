
import 'package:flutter/material.dart';
import 'package:odrive/pages/setting/personaledit.dart';

import '../../components/appbar.dart';
import '../../themes/theme.dart';

class PersonalScreen extends StatefulWidget
{
  final String userid;
  const PersonalScreen({required this.userid, super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen>
{
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Personal Information"),
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 16.0),
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
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name", style: text18GreyScale800),
                                    SizedBox(height: 6.0),
                                    Text("Dang Dihn", style: text16GrayScale90),
                                  ],
                                ),
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
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Email", style: text18GreyScale800),
                                    SizedBox(height: 6.0),
                                    Text("dangdinhbao0318@gmail.com", style: text16GrayScale90),
                                  ],
                                ),
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
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Date of birth", style: text18GreyScale800),
                                    SizedBox(height: 6.0),
                                    Text("07/03/2003", style: text16GrayScale90),
                                  ],
                                ),
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
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Gender", style: text18GreyScale800),
                                    SizedBox(height: 6.0),
                                    Text("Male", style: text16GrayScale90),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, color: greyColor800, size: 20),
                              ],
                            ),
                          )
                      ),
                      Divider(height: 1.0, color: greyColor800),
                    ],
                  )
              ),
            ],
          ),
        )

        // SingleChildScrollView(
        //     child: Stack(
        //         children: [
        //           Container(
        //             width: size.width,
        //             margin: EdgeInsets.all(24.0),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: [
        //                 SizedBox(height: 16.0),
        //                 GestureDetector(
        //                     onTap: (){
        //
        //                     },
        //                     child: Container(
        //                       padding: EdgeInsets.symmetric(vertical: 20.0),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           Text("Personal Information", style: text16GrayScale90),
        //                           Icon(Icons.arrow_forward_ios, color: greyColor800, size: 20),
        //                         ],
        //                       ),
        //                     )
        //                 ),
        //                 Divider(height: 1.0, color: greyColor800),
        //                 GestureDetector(
        //                     onTap: (){
        //
        //                     },
        //                     child: Container(
        //                       padding: EdgeInsets.symmetric(vertical: 20.0),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           Text("Personal Editing", style: text16GrayScale90),
        //                           Icon(Icons.arrow_forward_ios, color: greyColor800, size: 20),
        //                         ],
        //                       ),
        //                     )
        //                 ),
        //                 Divider(height: 1.0, color: greyColor800),
        //                 GestureDetector(
        //                     onTap: (){
        //
        //                     },
        //                     child: Container(
        //                       padding: EdgeInsets.symmetric(vertical: 20.0),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           Text("Change Password", style: text16GrayScale90),
        //                           Icon(Icons.arrow_forward_ios, color: greyColor800, size: 20),
        //                         ],
        //                       ),
        //                     )
        //                 ),
        //                 Divider(height: 1.0, color: greyColor800),
        //                 GestureDetector(
        //                     onTap: (){
        //
        //                     },
        //                     child: Container(
        //                       padding: EdgeInsets.symmetric(vertical: 20.0),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           Text("Help", style: text16GrayScale90),
        //                           Icon(Icons.arrow_forward_ios, color: greyColor800, size: 20),
        //                         ],
        //                       ),
        //                     )
        //                 ),
        //                 Divider(height: 1.0, color: greyColor800),
        //                 SizedBox(height: 40),
        //                 GestureDetector(
        //                   onTap: () async {
        //
        //                   },
        //                   child: Container(
        //                     width: size.width - size.width / 5,
        //                     height: 50,
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(20),
        //                         color: primaryColor),
        //                     child: Center(
        //                       child: Text(
        //                         'Log out',
        //                         style: text16White,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           )
        //         ]
        //     )
        // )
    );
  }
}