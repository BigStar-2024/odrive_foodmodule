import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odrive/localization/locale_constants.dart';
import 'package:odrive/pages/language/language.dart';
import 'package:odrive/pages/notification/notification.dart';
import 'package:odrive/pages/setting/help.dart';
import 'package:odrive/pages/setting/myaccount.dart';
import 'package:odrive/pages/setting/policy.dart';
import 'package:odrive/pages/wallet/wallet1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization/localizations_delegate.dart';
import 'package:odrive/pages/auth/auth.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/auth/register.dart';
import 'package:odrive/pages/auth/verify_otp.dart';
import 'package:odrive/pages/home/home.dart';
import 'package:odrive/pages/panier/panier.dart';
import 'package:odrive/pages/splashScreen.dart';
import 'package:odrive/pages/wallet/wallet.dart';
import 'package:odrive/themes/theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';

import 'model/language_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("after init");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

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
      // theme: ThemeData(
      //   primarySwatch: myPrimarySwatch,
      // ),
      theme: MyAppThemes.lightTheme,
      darkTheme: MyAppThemes.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      home: SplashScreen(), // Définissez votre Splash Screen comme écran d'accueil
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth':
            return PageTransition(
              child: AuthScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/login':
            return PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/register':
            return PageTransition(
              child: RegisterScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/verify_otp':
            return PageTransition(
              child: VerifyOtpScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/accueil':
            return PageTransition(
              child: HomeScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );

          case '/panier':
            return PageTransition(
              child: PanierScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/wallet':
            return PageTransition(
              child: Wallet1Screen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/myaccount':
            return PageTransition(
              child: MyAccountScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/language':
            return PageTransition(
              child: LanguageScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/notification':
            return PageTransition(
              child: NotificationScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/policy':
            return PageTransition(
              child: PolicyScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/help':
            return PageTransition(
              child: HelpScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
        }
      },
      supportedLocales: [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}