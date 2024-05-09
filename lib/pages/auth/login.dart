import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/themes/theme.dart';

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

  connexionBtn(size) {
    return GestureDetector(
      onTap: () async {
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
        width: size.width - size.width / 5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: connexion ? primaryColor : greyScale30Color),
        child: Center(
          child: Text(
            'Se connecter',
            style: connexion ? text16White : text16GrayScale90,
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
      appBar: MyAppBar(
        titleText: 'Se connecter',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Numero de téléphone',
                    style: text16GrayScale100,
                  ),
                  SizedBox(height: 15),
                  RoundedTextField(
                    hintText: 'Entrez votre numéro de téléphone',
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                    error: _error,
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Mot de passe',
                    style: text16GrayScale100,
                  ),
                  SizedBox(height: 8),
                  RoundedPasswordField(
                    hintText: 'Entrez votre mot de passe',
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
                          "Numéro ou mot de passe incorrecte",
                          style: text16Error,
                        )
                      : Container(),
                  SizedBox(height: 50),
                  connexionBtn(size),
                  SizedBox(height: 20),
                  horizontalRow(),
                  SizedBox(height: 20),
                  connexionGlBtn(size),
                  SizedBox(height: 10),
                  connexionFbBtn(size),
                  SizedBox(height: 10),
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
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: Text(
                            "S'inscrire",
                            style: text14WhitePrimary,
                          ))
                    ],
                  )
                ],
              ),
              _loading
                  ? Center(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        height: size
                            .height, // Ajustez la hauteur du loader selon vos besoins
                        child: Center(
                          child: SpinKitThreeBounce(
                            color: primaryColor,
                            size: 30.0,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  MyAppBar({required this.titleText});
  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 3,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: greyScale90Color),
        onPressed: () {
          // Action à effectuer lorsqu'on appuie sur la flèche de retour
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        titleText,
        style: text20GrayScale100,
      ),
    );
  }
}

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final bool error;

  const RoundedTextField(
      {required this.hintText,
      this.keyboardType,
      this.obscureText = false,
      required this.controller,
      required this.error});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: errorColor)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: error
              ? BorderSide(color: errorColor)
              : BorderSide(color: greyShade3),
        ),
      ),
    );
  }
}

class RoundedPasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool error;

  const RoundedPasswordField(
      {required this.hintText,
      required this.controller,
      required this.onChanged,
      required this.error});

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: widget.error
                ? BorderSide(color: errorColor)
                : BorderSide(color: greyShade3)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: widget.error
              ? BorderSide(color: errorColor)
              : BorderSide(color: greyShade3),
        ),
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
