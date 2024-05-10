
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:odrive/backend/api_calls.dart';

import '../localization/Language/languages.dart';
import '../pages/commande/commandes.dart';
import '../pages/favorite/favorite.dart';
import '../pages/recompense/recompense.dart';
import '../themes/theme.dart';

/*
* LoginButtonsWidget
* */

class LoginButtonsWidget extends StatefulWidget {
  Function(bool) setLoading;
  LoginButtonsWidget({super.key, required this.setLoading});
  @override
  _LoginButtonsWidgetState createState() => _LoginButtonsWidgetState();
}

class _LoginButtonsWidgetState extends State<LoginButtonsWidget> {

  static const List<String> scopes = <String>[
    'email'
  ];

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // serverClientId: '662724716216-7o24p8gu8v6tfse99kdjvp59oqnan2aq.apps.googleusercontent.com',
    scopes: scopes,
  );

  connexionFbBtn(size) {
    return Container(
      width: size.width - fixPadding * 4,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Color(0xFF415792)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons
                  .facebook, // Remplacez par l'icône que vous souhaitez utiliser
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              Languages.of(context)!.labelContinueFacebook,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }

  connexionGlBtn(size) {
    return GestureDetector(
      onTap: () async{
        try {
          final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
          if (googleSignInAccount != null) {
            GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
            print(googleSignInAuthentication);
            widget.setLoading(true);
            if(googleSignInAuthentication.accessToken != null){
              dynamic response = await googleLogin(googleSignInAuthentication.accessToken!);
              widget.setLoading(false);
              if (response["error"] == 0) {
                await postQrCode();
                Navigator.pushReplacementNamed(context, '/accueil');
              }
            }
            widget.setLoading(false);
          }
        } catch (error) {
          print(error);
        }
      },
      child: Container(
        width: size.width - fixPadding * 4,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Color(0xFF5384EE)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/auth/google.png"),
              SizedBox(width: 10),
              Text(
                Languages.of(context)!.labelContinueGoogle,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  connexionApBtn(size) {
    return GestureDetector(
      onTap: () async{
        try {
          final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
          if (googleSignInAccount != null) {
            GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
            print(googleSignInAuthentication);
            widget.setLoading(true);
            if(googleSignInAuthentication.accessToken != null){
              dynamic response = await googleLogin(googleSignInAuthentication.accessToken!);
              widget.setLoading(false);
              if (response["error"] == 0) {
                await postQrCode();
                Navigator.pushReplacementNamed(context, '/accueil');
              }
            }
            widget.setLoading(false);
          }
        } catch (error) {
          print(error);
        }
      },
      child: Container(
        width: size.width - fixPadding * 4,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/auth/apple.png"),
              SizedBox(width: 10),
              Text(
                Languages.of(context)!.labelContinueApple,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  horizontalRow(size) {
    dynamic width = size.width - fixPadding * 4;
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width / 2 - 30,
            height: 1.0, // Hauteur de la première ligne horizontale
            color: Theme.of(context).dividerColor,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              Languages.of(context)!.labelOr,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            width: width / 2 - 30,
            height: 1.0, // Hauteur de la deuxième ligne horizontale
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        horizontalRow(size),
        heightSpace,
        heightSpace,
        connexionGlBtn(size),
        heightSpace,
        connexionFbBtn(size),
        heightSpace,
        connexionApBtn(size),
      ],
    );
  }
}