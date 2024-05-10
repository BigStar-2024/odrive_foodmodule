import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:odrive/components/loading.dart';
import 'package:odrive/components/loginbuttons.dart';
import 'package:odrive/themes/theme.dart';
import 'package:odrive/localization/Language/languages.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _loading = false;

  setLoading(bool status){
    setState(() {
      _loading = status;
    });
  }

  connexionBtn(size) {
    return GestureDetector(
      onTap: () {
        print("login");
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        width: size.width - fixPadding * 4,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor
        ),
        child: Center(
          child: Text(
            Languages.of(context)!.labelSignup,
            style: Theme.of(context).textTheme.titleSmall
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: size.width,
            child: Image.asset(
              'assets/auth/background.png', // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            height: size.height * 0.8,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.25, 0.4, 1.0],
                  colors: [Theme.of(context).backgroundColor.withOpacity(0), Theme.of(context).backgroundColor.withOpacity(0.8), Theme.of(context).backgroundColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height / 10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/splash/tyms.png',
                  ),
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
                            Navigator.pushNamed(context, '/register');
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
            ),
          ),
          _loading
              ? LoadingWidget()
              : Container(),
        ],
      ),
    );
  }
}
