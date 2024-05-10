
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odrive/components/toastr.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../localization/locale_constants.dart';
import '../../model/language_model.dart';
import '../../themes/theme.dart';

class LanguageScreen extends StatefulWidget
{
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}
class _LanguageScreenState extends State<LanguageScreen>
{

  String selectedLanguageCode = 'en';

  @override
  void initState(){
    super.initState();

    getLanguage();
  }

  getLanguage() async {
    String code = await getLocaleLanguage(context);
    setState(() {
      selectedLanguageCode = code;
    });
  }

  setLanguage() async {
    changeLanguage(context, selectedLanguageCode);
    ToastService.showSuccessToast("Set up successfully");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(titleText: "Language"),
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child:Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: ListView.builder(
                          itemCount: LanguageModel.languageList().length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                setState(() {
                                  selectedLanguageCode = LanguageModel.languageList().elementAt(index).languageCode;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: greyScale50Color, // Choose the color you want for the border
                                      width: 1.0, // Adjust the width of the border
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(LanguageModel.languageList().elementAt(index).name, style: text18GreyScale100),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Radio<String>(
                                        value: LanguageModel.languageList().elementAt(index).languageCode,
                                        groupValue: selectedLanguageCode,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedLanguageCode = LanguageModel.languageList().elementAt(index).languageCode;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      )
                  )
              ),
              Container(
                child: GestureDetector(
                  onTap: () async {
                    setLanguage();
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