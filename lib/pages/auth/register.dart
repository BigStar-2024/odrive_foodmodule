import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/components/loading.dart';
import 'package:odrive/components/loginbuttons.dart';
import 'package:odrive/localization/Language/languages.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/themes/theme.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool connexion = false;
  bool _loading = false;
  bool _error = false;

  setLoading(bool status){
    setState(() {
      _loading = status;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              Languages.of(context)!.textRegisteredSuccess,
              style: text18Neutral,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset("assets/register/confirm_ok.png"),
              ),
              SizedBox(height: 25),
              Center(
                child: Text(
                  phoneNumberController.text,
                  style: text16Primary,
                ),
              ),
              SizedBox(height: 15),
              Text(
                Languages.of(context)!.labelNumberAlreadyExist,
                style: text16Neutral,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              continueToHomeBtn(),
            ],
          ),
        );
      },
    );
  }

  continueToHomeBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/accueil');
      },
      child: Container(
        //width: size.width - size.width / 5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: primaryColor),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Languages.of(context)!.labelContinueOnHomepage,
                style: text16WhiteBold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  connexionBtn(size) {
    String errorMessage = Languages.of(context)!.labelCheckAllFields;
    return GestureDetector(
      onTap: () async {
        print("verify_otp");
        Navigator.pushNamed(context, '/verify_otp');
        // setState(() {
        //   _loading = true;
        // });
        // print("login");
        // if (connexion) {
        //   if (phoneNumberController.text.isNotEmpty &&
        //       passwordController.text.isNotEmpty &&
        //       passwordConfirmController.text.isNotEmpty &&
        //       nameController.text.isNotEmpty) {
        //     dynamic response = await register(
        //         emailController.text,
        //         passwordController.text,
        //         nameController.text,
        //         phoneNumberController.text,
        //         "phone",
        //         "");
        //     print("responssssssssssssseeeeeeeeeeee");
        //     print(response);
        //     print(
        //         "Le type de myVariable est : ${response["error"].runtimeType}");
        //     if (response["error"].toString() == "1") {
        //       print("erreur-----------");
        //       setState(() {
        //         _error = true;
        //       });
        //     }
        //     if (response["error"].toString() == "0") {
        //       print("no error");
        //       setState(() {
        //         _error = false;
        //       });
        //       _showSuccessDialog();
        //       //Navigator.pushReplacementNamed(context, '/accueil');
        //
        //     }
        //     if (response["error"].toString() == "3") {
        //       //print("no error");
        //       setState(() {
        //         errorMessage = Languages.of(context)!.labelNumberAlreadyExist;
        //         _error = true;
        //       });
        //     }
        //   } else {
        //     setState(() {
        //       _error = true;
        //     });
        //   }
        // }
        // setState(() {
        //   _loading = false;
        // });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: connexion ? Theme.of(context).primaryColor : MyAppColors.greyScale30Color),
        child: Center(
          child: Text(
            Languages.of(context)!.labelSignup,
            style: connexion ? Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white
            ) : Theme.of(context).textTheme.titleSmall?.copyWith(
                color: MyAppColors.greyScale90Color
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: MyAppBar(
      //   titleText: Languages.of(context)!.labelSignup,
      // ),SingleChildScrollView
        backgroundColor:Theme.of(context).backgroundColor,
      body: Stack(
        children: [

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(fixPadding * 2.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/splash/tyms.png",
                            height: size.height * 0.1,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text(
                        Languages.of(context)!.labelFullName,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 16.0,
                        ),
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
                        Languages.of(context)!.labelPhone,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: Languages.of(context)!.labelPlaceholderPhoneNumber,
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberController,
                        error: _error,
                      ),
                      SizedBox(height: 25),
                      Text(
                        Languages.of(context)!.labelEmail,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 15),
                      RoundedTextField(
                        hintText: Languages.of(context)!.labelPlaceholderEmail,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        error: _error,
                      ),
                      SizedBox(height: 25),
                      Text(
                        Languages.of(context)!.labelPassword,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8),
                      RoundedPasswordField(
                        hintText: Languages.of(context)!.labelPlaceholderPassword,
                        controller: passwordController,
                        onChanged: (value) {},
                        error: _error,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        Languages.of(context)!.labelPasswordConfirm,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8),
                      RoundedPasswordField(
                        hintText: Languages.of(context)!.labelPlaceholderPasswordConfirm,
                        controller: passwordConfirmController,
                        onChanged: (value) {
                          if (value.length > 0) {
                            setState(() {
                              connexion = true;
                            });
                          }
                          if (value.length == 0) {
                            setState(() {
                              connexion = false;
                            });
                          }
                        },
                        error: _error,
                      ),
                      SizedBox(height: 10),
                      _error
                          ? Text(
                        Languages.of(context)!.labelCheckAllFields,
                        style: text16Error,
                      )
                          : Container(),
                      SizedBox(height: 50),
                      connexionBtn(size),
                      heightSpace,
                      heightSpace,
                      LoginButtonsWidget(setLoading: setLoading),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Languages.of(context)!.textAlreadyRegistered,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16.0,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                              child: Text(
                                Languages.of(context)!.textToLogin,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    decoration: TextDecoration.underline
                                ),
                              ))
                        ],
                      ),
                      SizedBox(height: 64),
                    ],
                  ),

                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            height: 300,
            child: Image.asset(
              'assets/auth/topshape.png', // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            width: size.width,
            child: Image.asset(
              'assets/auth/bottomshape.png', // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          _loading
              ? LoadingWidget()
              : Container(),
        ],
      )
    );
  }
}
