
import 'package:flutter/material.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../themes/theme.dart';

class AddAddressScreen extends StatefulWidget
{
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}
class _AddAddressScreenState extends State<AddAddressScreen>
{
  bool _error = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Add Address"),
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
                      SizedBox(height: 16.0),
                      Text(
                        Languages.of(context)!.labelEmail,
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: Languages.of(context)!.labelPlaceholderEmail,
                        keyboardType: TextInputType.text,
                        controller: emailController,
                        error: _error,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "City",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: "City",
                        keyboardType: TextInputType.text,
                        controller: cityController,
                        error: _error,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "District",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 12),
                      RoundedTextField(
                        hintText: "District",
                        keyboardType: TextInputType.text,
                        controller: districtController,
                        error: _error,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Detail Address",
                        style: text16GrayScale100,
                      ),
                      SizedBox(height: 12),
                      RoundedTextField(
                        hintText: "Enter detail address",
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        error: _error,
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