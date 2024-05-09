import 'package:flutter/material.dart';
import 'package:odrive/pages/auth/auth.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/auth/register.dart';
import 'package:odrive/pages/home/home.dart';
import 'package:odrive/pages/panier/panier.dart';
import 'package:odrive/pages/splashScreen.dart';
import 'package:odrive/pages/suivie/suivie.dart';
import 'package:odrive/pages/wallet/wallet.dart';
import 'package:odrive/themes/theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("after init");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color myPrimaryColor = primaryColor;

    // Créer une palette de couleurs avec votre couleur personnalisée
    MaterialColor myPrimarySwatch = MaterialColor(
      myPrimaryColor.value,
      <int, Color>{
        50: myPrimaryColor.withOpacity(0.1),
        100: myPrimaryColor.withOpacity(0.2),
        200: myPrimaryColor.withOpacity(0.3),
        300: myPrimaryColor.withOpacity(0.4),
        400: myPrimaryColor.withOpacity(0.5),
        500: myPrimaryColor.withOpacity(0.6),
        600: myPrimaryColor.withOpacity(0.7),
        700: myPrimaryColor.withOpacity(0.8),
        800: myPrimaryColor.withOpacity(0.9),
        900: myPrimaryColor.withOpacity(1.0),
      },
    );
    return MaterialApp(
      title: 'Mon Application Flutter',
      theme: ThemeData(
        primarySwatch: myPrimarySwatch,
      ),
      debugShowCheckedModeBanner: false,
      home:
          SplashScreen(), // Définissez votre Splash Screen comme écran d'accueil
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth':
            return PageTransition(
              child: AuthScreen(),
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
          case '/login':
            return PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
          case '/register':
            return PageTransition(
              child: RegisterScreen(),
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
          case '/accueil':
            return PageTransition(
              child: HomeScreen(),
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );

          case '/panier':
            return PageTransition(
              child: PanierScreen(),
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
          case '/wallet':
            return PageTransition(
              child: WalletScreen(),
              type: PageTransitionType.bottomToTop,
              settings: settings,
            );
        }
      },
    );
  }
}
