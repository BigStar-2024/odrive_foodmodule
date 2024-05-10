
import 'package:flutter/material.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../themes/theme.dart';

class AddWalletScreen extends StatefulWidget
{
  const AddWalletScreen({super.key});

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}
class _AddWalletScreenState extends State<AddWalletScreen>
{
  bool _error = false;
  TextEditingController bankController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardOwnerController = TextEditingController();
  TextEditingController cardExpireController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Associate Bank"),
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        "Bank",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: "Enter bank",
                        keyboardType: TextInputType.text,
                        controller: bankController,
                        error: _error,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Card Number",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: "Add card number",
                        keyboardType: TextInputType.text,
                        controller: cardNumberController,
                        error: _error,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Card Owner Name",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: "Enter card owner name",
                        keyboardType: TextInputType.text,
                        controller: bankController,
                        error: _error,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Expire date",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          hintText: 'MM/YY',
                        ),
                        keyboardType: TextInputType.datetime,
                        maxLength: 5,
                        controller: cardExpireController,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "CVV",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          hintText: 'CVV',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        obscureText: true,
                        controller: cardCvvController,
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