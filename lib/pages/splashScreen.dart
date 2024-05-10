import 'dart:async';

import 'package:flutter/material.dart';
import 'package:odrive/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/Language/languages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkPersistentLogin();
  }

  void checkPersistentLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("loggedIn") == true;
    bool? firstUse = prefs.getBool("user_first_use");

    Timer(const Duration(seconds: 3), () {
      // Utilisateur déjà connecté, rediriger directement vers l'écran d'accueil
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Utilisateur non connecté, rediriger vers l'écran d'onboarding
        Navigator.pushReplacementNamed(context, '/auth');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              "assets/splash/tyms.png",
              height: size.height * 0.2,
              fit: BoxFit.cover,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
