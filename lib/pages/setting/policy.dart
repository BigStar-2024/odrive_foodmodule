
import 'package:flutter/material.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../themes/theme.dart';

class PolicyScreen extends StatefulWidget
{
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}
class _PolicyScreenState extends State<PolicyScreen>
{

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Security Policy"),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Terms",
                      style: text16GreyScale900,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
                      style: text14GrayScale70,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including",
                      style: text14GrayScale70,
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      "Changes with Service and Terms",
                      style: text16GreyScale900,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
                      style: text14GrayScale70,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including",
                      style: text14GrayScale70,
                    ),

                    SizedBox(height: 30.0),
                    Text(
                      "T & C",
                      style: text16GreyScale900,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including",
                      style: text14GrayScale70,
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}