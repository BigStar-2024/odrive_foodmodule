
import 'package:flutter/material.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../themes/theme.dart';

class HelpScreen extends StatefulWidget
{
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}
class _HelpScreenState extends State<HelpScreen>
{

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Help"),
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
                      SizedBox(height: 16.0),
                      Text(
                        "Help",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),

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