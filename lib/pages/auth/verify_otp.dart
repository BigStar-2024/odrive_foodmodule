import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/components/appbar.dart';
import 'package:odrive/components/loading.dart';
import 'package:odrive/localization/Language/languages.dart';
import 'package:odrive/themes/theme.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<TextEditingController?> m_controller = [];
  bool connexion = false;
  bool _loading = false;
  bool _error = false;

  String otpCode = "";
  int  _counter = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        timer.cancel(); // Cancel the timer when the countdown is full
        Navigator.pop(context);
      }
    });
  }

  connexionBtn(size) {
    return GestureDetector(
      onTap: () async {
        // setState(() {
        //   _loading = true;
        // });
        if(connexion){
          print("verify otp continue");
          //if otp is true
          showSuccessDialog(otpCode);

          for(var i = 0; i < m_controller.length; i++){
            m_controller[i]!.text = '';
          }

          setState(() {
            connexion = false;
          });

        }
        // if (connexion) {
        //   dynamic response =
        //       await login(phoneNumberController.text, passwordController.text);
        //
        //   if (response["error"] == 1) {
        //     print("erreur-----------");
        //     setState(() {
        //       _error = true;
        //     });
        //   }
        //   if (response["error"] == 0) {
        //     setState(() {
        //       _error = false;
        //     });
        //     await postQrCode();
        //
        //     Navigator.pushReplacementNamed(context, '/accueil');
        //   }
        // }
        // setState(() {
        //   _loading = false;
        // });
        //Navigator.pushReplacementNamed(context, '/login');
      },
      child: Container(
        width: size.width - fixPadding * 4,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: connexion ? primaryColor : greyScale30Color),
        child: Center(
          child: Text(
            Languages.of(context)!.labelContinue,
            style: connexion ? text16White : text16GrayScale90,
          ),
        ),
      ),
    );
  }

  showSuccessDialog(String pin){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              Languages.of(context)!.textRegisteredSuccess,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                color: Colors.black
              ),
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
                  pin,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.black
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                Languages.of(context)!.textPhoneRegisteredSuccess,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
              heightSpace,
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
            borderRadius: BorderRadius.circular(20), color: MyAppColors.primaryColor),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Languages.of(context)!.labelContinueOnHomepage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  resendOtpVerification(){
    print("Resend OTP verification again...");
    setState(() {
      _counter = 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:Theme.of(context).backgroundColor,
      appBar: MyAppBar(
        titleText: Languages.of(context)!.labelOtp,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(fixPadding * 2.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  heightSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Languages.of(context)!.textConfirmCode,
                        style: Theme.of(context).textTheme.titleLarge
                      )
                    ],
                  ),
                  heightSpace,
                  heightSpace,
                  OtpTextField(
                    numberOfFields: 6,
                    fieldWidth: 50,
                    handleControllers: (List<TextEditingController?>? dd){
                        m_controller = dd!;
                    },
                    borderColor: const Color(0xFFE5E6EB),
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {
                    },
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    obscureText: true,
                    onSubmit: (String verificationCode){
                      setState(() {
                        otpCode = verificationCode;
                        connexion = true;
                      });
                    }, // end onSubmit
                  ),
                  heightSpace,
                  heightSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Languages.of(context)!.textSendVerificationCode("0724****"),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  heightSpace,
                  heightSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Languages.of(context)!.textNotReceived,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            resendOtpVerification();
                          },
                          child: Text(
                            Languages.of(context)!.textResponseSeconds(_counter),
                            style: text16Primary,
                          )
                      )
                    ],
                  ),
                  SizedBox(height: 36),
                  connexionBtn(size),
                ],
              ),
              _loading
                  ? LoadingWidget()
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
