import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/themes/theme.dart';

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

  String errorMessage = "Vérifiez tous les champs";
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Inscription réussite',
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
                'Votre numéro de téléphone a été enregistré avec succès.',
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
                'Continuer sur la page d\'accueil',
                style: text16WhiteBold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  connexionBtn(size) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _loading = true;
        });
        print("login");
        if (connexion) {
          if (phoneNumberController.text.isNotEmpty &&
              passwordController.text.isNotEmpty &&
              passwordConfirmController.text.isNotEmpty &&
              nameController.text.isNotEmpty) {
            dynamic response = await register(
                emailController.text,
                passwordController.text,
                nameController.text,
                phoneNumberController.text,
                "phone",
                "");
            print("responssssssssssssseeeeeeeeeeee");
            print(response);
            print(
                "Le type de myVariable est : ${response["error"].runtimeType}");
            if (response["error"].toString() == "1") {
              print("erreur-----------");
              setState(() {
                _error = true;
              });
            }
            if (response["error"].toString() == "0") {
              print("no error");
              setState(() {
                _error = false;
              });
              _showSuccessDialog();
              //Navigator.pushReplacementNamed(context, '/accueil');

            }
            if (response["error"].toString() == "3") {
              //print("no error");
              setState(() {
                errorMessage = "Ce numéro existe déja";
                _error = true;
              });
            }
          } else {
            setState(() {
              _error = true;
            });
          }
        }
        setState(() {
          _loading = false;
        });
      },
      child: Container(
        width: size.width - size.width / 5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: connexion ? primaryColor : greyScale30Color),
        child: Center(
          child: Text(
            'S\'inscrire',
            style: connexion ? text16White : text16GrayScale90,
          ),
        ),
      ),
    );
  }

  connexionFbBtn(size) {
    return GestureDetector(
      onTap: () {
        //_showSuccessDialog();
      },
      child: Container(
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
        titleText: 'S\'inscrire',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Nom complet',
                    style: text16GrayScale100,
                  ),
                  SizedBox(height: 15),
                  RoundedTextField(
                    hintText: 'Entrez votre nom complet',
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    error: _error,
                  ),
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
                    'Email',
                    style: text16GrayScale100,
                  ),
                  SizedBox(height: 15),
                  RoundedTextField(
                    hintText: 'Entrez votre Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
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
                    onChanged: (value) {},
                    error: _error,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Confirmation de mot de passe',
                    style: text16GrayScale100,
                  ),
                  SizedBox(height: 8),
                  RoundedPasswordField(
                    hintText: 'Confirmer votre mot de passe',
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
                          errorMessage,
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
                        "déja inscrit?",
                        style: text14GrayScale100,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "Se connecter",
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
