import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:odrive/themes/theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  connexionBtn(size) {
    return GestureDetector(
      onTap: () {
        print("login");
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        width: size.width - size.width / 5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: primaryColor),
        child: Center(
          child: Text(
            'Sign in',
            style: text16White,
          ),
        ),
      ),
    );
  }

  connexionFbBtn(size) {
    return Container(
      width: size.width - size.width / 5,
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
              'Continuer avec Facebook',
              style: text16White,
            ),
          ],
        ),
      ),
    );
  }

  connexionGlBtn(size) {
    return Container(
      width: size.width - size.width / 5,
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
              'Continuer avec Google',
              style: text16White,
            ),
          ],
        ),
      ),
    );
  }

  connexionApBtn(size) {
    return Container(
      width: size.width - size.width / 5,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: blackColor),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/auth/apple.png"),
            SizedBox(width: 10),
            Text(
              'Continuer avec Apple',
              style: text16White,
            ),
          ],
        ),
      ),
    );
  }

  horizontalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100.0,
          height: 1.0, // Hauteur de la première ligne horizontale
          color: greyColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('ou'),
        ),
        Container(
          width: 100.0,
          height: 1.0, // Hauteur de la deuxième ligne horizontale
          color: greyColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/auth/background.png'), // Remplacez par le chemin de votre image
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: [0.25, 1.0],
                colors: [Colors.transparent, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height / 5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/splash/odrive_1.png', // Remplacez par le chemin de votre image
                    width: 200.0, // Ajustez la largeur selon vos besoins
                    height: 200.0, // Ajustez la hauteur selon vos besoins
                  ),
                  SizedBox(
                      height:
                          20.0), // Ajoutez un espace entre l'image et le bouton
                  connexionBtn(size),
                  heightSpace,
                  heightSpace,
                  horizontalRow(),
                  heightSpace,
                  heightSpace,
                  connexionGlBtn(size),
                  heightSpace,
                  heightSpace,
                  connexionFbBtn(size),
                  heightSpace,
                  heightSpace,
                  connexionApBtn(size),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pas encore de compte?",
                        style: text14GrayScale100,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "S'inscrire",
                            style: text14WhitePrimary,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
          /* Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/splash/odrive_1.png",
                  height: size.height * 0.1,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ) */
        ],
      ),
    );
  }
}
