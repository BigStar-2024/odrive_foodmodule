
import 'package:flutter/material.dart';

import '../../components/appbar.dart';
import '../../themes/theme.dart';

class NotificationScreen extends StatefulWidget
{
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}
class _NotificationScreenState extends State<NotificationScreen>
{

  bool forAll = false;
  bool forPrompts = false;
  bool forCalls = false;
  bool forOrders = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Notification setting"),
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                              greyScale40Color, // Couleur de la bordure
                              width: 1.0, // Épaisseur de la bordure
                            ),
                            color: whiteColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Receive all notifications",
                              style: text16GrayScale100,
                            ),
                            Switch(
                              // This bool value toggles the switch.
                              value: forAll,
                              activeColor: primaryColor,
                              onChanged: (bool value) {
                                // This is called when the user toggles the switch.
                                setState(() {
                                  forAll = value;
                                  forPrompts = value;
                                  forCalls = value;
                                  forOrders = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                              greyScale40Color, // Couleur de la bordure
                              width: 1.0, // Épaisseur de la bordure
                            ),
                            color: whiteColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Prompts",
                              style: text16GrayScale100,
                            ),
                            Switch(
                              // This bool value toggles the switch.
                              value: forPrompts,
                              activeColor: primaryColor,
                              onChanged: (bool value) {
                                // This is called when the user toggles the switch.
                                setState(() {
                                  forPrompts = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                              greyScale40Color, // Couleur de la bordure
                              width: 1.0, // Épaisseur de la bordure
                            ),
                            color: whiteColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Calls",
                              style: text16GrayScale100,
                            ),
                            Switch(
                              // This bool value toggles the switch.
                              value: forCalls,
                              activeColor: primaryColor,
                              onChanged: (bool value) {
                                // This is called when the user toggles the switch.
                                setState(() {
                                  forCalls = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                              greyScale40Color, // Couleur de la bordure
                              width: 1.0, // Épaisseur de la bordure
                            ),
                            color: whiteColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Orders",
                              style: text16GrayScale100,
                            ),
                            Switch(
                              // This bool value toggles the switch.
                              value: forOrders,
                              activeColor: primaryColor,
                              onChanged: (bool value) {
                                // This is called when the user toggles the switch.
                                setState(() {
                                  forOrders = value;
                                });
                              },
                            )
                          ],
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