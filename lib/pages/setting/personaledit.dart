
import 'package:flutter/material.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../themes/theme.dart';

class PersonalEditScreen extends StatefulWidget
{
  final String userid;
  const PersonalEditScreen({required this.userid, super.key});

  @override
  State<PersonalEditScreen> createState() => _PersonalEditScreenState();
}
enum SingingCharacter { male, female }
class _PersonalEditScreenState extends State<PersonalEditScreen>
{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  bool _error = false;

  DateTime _selectedDate = DateTime.now();
  int selectedCardIndex = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Personal Editing"),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: blackColor,
                                child: Text(
                                  'D',
                                  style: text40BoldWhite,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: greyColor800
                                    ),
                                    child: Icon(Icons.edit, color: Colors.white),
                                  ),
                                )
                              ),
                            ],
                          )

                        ],
                      ),


                      SizedBox(height: 16.0),
                      Text(
                        Languages.of(context)!.labelFullName,
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: Languages.of(context)!.labelPlaceholderFullName,
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        error: _error,
                      ),
                      SizedBox(height: 20),
                      Text(
                        Languages.of(context)!.labelEmail,
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: Languages.of(context)!.labelPlaceholderEmail ,
                        keyboardType: TextInputType.text,
                        controller: emailController,
                        error: _error,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Date of birth",
                        style: text16GrayScale100
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: "Enter your birth" ,
                        keyboardType: TextInputType.datetime,
                        controller: birthController,
                        error: _error,
                      ),
                      SizedBox(height: 20),
                      Text(
                          "Sex",
                          style: text16GrayScale100
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * 0.4,
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: greyScale60Color,
                                width: 1.0,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCardIndex = 1;
                                });
                              },
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Transform.scale(
                                      scale: 1.5,
                                      child: Radio<int>(
                                        value: 1,
                                        groupValue: selectedCardIndex,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCardIndex = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      "Male",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          Container(
                            width: size.width * 0.4,
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: greyScale60Color,
                                width: 1.0,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCardIndex = 2;
                                });
                              },
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Transform.scale(
                                      scale: 1.5,
                                      child: Radio<int>(
                                        value: 2,
                                        groupValue: selectedCardIndex,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCardIndex = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      "Female",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
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
                        'Save',
                        style: text16White,
                      ),
                    ),
                  ),
                ),
              )
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