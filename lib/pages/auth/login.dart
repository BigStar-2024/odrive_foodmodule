import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/components/loading.dart';
import 'package:odrive/components/loginbuttons.dart';
import 'package:odrive/localization/Language/languages.dart';
import 'package:odrive/themes/theme.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool connexion = false;
  bool _loading = false;
  bool _error = false;

  setLoading(bool status){
    setState(() {
      _loading = status;
    });
  }

  connexionBtn(size) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          _loading = true;
        });
        print("login");
        if (connexion) {
          dynamic response =
              await login(phoneNumberController.text, passwordController.text);

          if (response["error"] == 1) {
            print("erreur-----------");
            setState(() {
              _error = true;
            });
          }
          if (response["error"] == 0) {
            setState(() {
              _error = false;
            });
            await postQrCode();

            Navigator.pushReplacementNamed(context, '/accueil');
          }
        }
        setState(() {
          _loading = false;
        });
        //Navigator.pushReplacementNamed(context, '/login');
      },
      child: Container(
        width: size.width - fixPadding * 4,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: connexion ? Theme.of(context).primaryColor : MyAppColors.greyScale30Color),
        child: Center(
          child: Text(
            Languages.of(context)!.labelSignin,
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
      //   titleText: Languages.of(context)!.labelSignin,
      // ),
      body: Stack(
        children: [
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
                        Languages.of(context)!.labelPhone,
                        style: Theme.of(context).textTheme.bodyLarge
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
                        Languages.of(context)!.labelPassword,
                          style: Theme.of(context).textTheme.bodyLarge
                      ),
                      SizedBox(height: 8),
                      RoundedPasswordField(
                        hintText: Languages.of(context)!.labelPlaceholderPassword,
                        controller: passwordController,
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
                        Languages.of(context)!.labelPhonePasswordError,
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
                            Languages.of(context)!.textNoAccount,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16.0,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/register');
                              },
                              child: Text(
                                Languages.of(context)!.labelSignup,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    decoration: TextDecoration.underline
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ],
              ),
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


