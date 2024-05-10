import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/components/loading.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/themes/theme.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';

class Wallet1Screen extends StatefulWidget {
  const Wallet1Screen({super.key});

  @override
  State<Wallet1Screen> createState() => _Wallet1ScreenState();
}

class _Wallet1ScreenState extends State<Wallet1Screen> {
  bool hidden = true;
  dynamic walletLog = {"walletlog": []};
  String balans = "0";
  bool _loading = false;
  bool _loadingSheet = false;
  int selectedCardIndex = -1;
  String otp = "";
  String numero_paiement = "";
  OtpFieldController otpController = OtpFieldController();
  bool rechargement = false;
  bool rechargementDetail = false;
  TextEditingController montantController = TextEditingController();

  List<Map<String, dynamic>> cardInfo = [
    {
      'text': 'ORANGE',
      'image': 'orange.png',
    },
    {
      'text': 'MOOV',
      'image': 'moov.png',
    },
    {
      'text': 'MTN',
      'image': 'mtn.png',
    },
  ];

  // Fonction pour obtenir le texte correspondant à arrival
  String getArrivalText(int arrival) {
    return arrival == 0 ? "paiement" : "rechargement";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getWalletGb();
    _getWalletLog();
  }

  @override
  void dispose() {
    //subscription!.cancel();
    super.dispose();
  }

  refreshPage() {
    setState(() {
      rechargement = false;
      rechargementDetail = false;
    });
    Navigator.pop(context);
    _getWalletGb();
    _getWalletLog();
  }

  _getWalletGb() async {
    setState(() {
      _loading = true;
    });
    var response = await walletgb();
    if (response["error"].toString() == "0") {
      setState(() {
        balans = response["balance"];
      });
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _getWalletLog() async {
    var response = await getWalletById();
    if (response["error"] == "0") {
      if (response["walletlog"].isNotEmpty) {
        print("walletlog---------");
        print(response);
        setState(() {
          walletLog = response;
        });
      } else {
        print("herre");
      }
    } else {
      Fluttertoast.showToast(msg: "Une erreur s'est produite");
    }
  }

  void _showChargeModal(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    showModalBottomSheet<void>(
      context: context,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            void Function(void Function()) setState) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            height: selectedCardIndex == 0 ? 500 : 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.width,
                  height: 44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IntlPhoneField(
                            languageCode: "fr",
                            invalidNumberMessage: "Numéro incorrecte",
                            decoration: InputDecoration(
                              labelText: 'Numéro du paiement',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'CI',
                            onChanged: (phone) {
                              print(phone.number);
                              print(phone.completeNumber);
                              setState(() {
                                numero_paiement = phone.number;
                              });
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          RoundedTextField(
                            hintText: 'Entrez le montant du rechargement',
                            keyboardType: TextInputType.number,
                            controller: montantController,
                            error: false,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          selectedCardIndex == 0
                              ? Column(
                            children: [
                              Text(
                                "Composez le code ci-dessous pour obtenir le code OTP à 4 chiffres",
                                textAlign: TextAlign.center,
                                style: text16GrayScale100,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "#144*82#",
                                textAlign: TextAlign.center,
                                style: text16Primary,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              OTPTextField(
                                  controller: otpController,
                                  length: 4,
                                  width:
                                  MediaQuery.of(context).size.width,
                                  textFieldAlignment:
                                  MainAxisAlignment.spaceAround,
                                  fieldWidth: 45,
                                  fieldStyle: FieldStyle.box,
                                  outlineBorderRadius: 8,
                                  style: TextStyle(fontSize: 17),
                                  onChanged: (pin) {
                                    print("Changed: " + pin);
                                  },
                                  onCompleted: (pin) {
                                    print("Completed: " + pin);
                                    setState(() {
                                      otp = pin;
                                    });
                                  }),
                              SizedBox(
                                height: 32,
                              ),
                            ],
                          )
                              : Container(),

                          Container(
                            width: size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _loading = true;
                                });
                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                String completName =
                                    prefs.getString("userName") ?? "";
                                int userId = prefs.getInt("userId") ?? 0;

                                List<String> nameParts = completName.split(' ');
                                String name =
                                nameParts.isNotEmpty ? nameParts.first : '';
                                String prenoms = nameParts.sublist(1).join(' ');
                                DateTime now = DateTime.now();
                                var idFromClient =
                                    "${now.millisecondsSinceEpoch}T${userId}W";
                                var response = await paiementom(
                                    idFromClient,
                                    prefs.getString("userEmail"),
                                    name,
                                    prenoms,
                                    numero_paiement,
                                    otp,
                                    montantController.text);
                                print(
                                    "responseeeeeee-------------------------------");
                                print(response);
                                if (response["status"] == "SUCCESSFUL") {
                                  /* await savePaiement(response,
                                        widget.dataComplet["order"]["id"]); */

                                  var response =
                                  await walletTopUp(montantController.text);
                                  if (response["error"].toString() == "0") {
                                    setState(() {
                                      _loading = false;
                                    });
                                    SuccesEchecDialog(true);
                                  } else {
                                    setState(() {
                                      _loading = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Une erreur s'est produite");
                                  }
                                } else if (response["status"] == "FAILED") {
                                  setState(() {
                                    _loading = false;
                                  });
                                  SuccesEchecDialog(false);
                                } else {
                                  startExecution(idFromClient, "ORANGE MONEY");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: numero_paiement == ""
                                    ? greyScale60Color
                                    : primaryColor, // Couleur de fond du bouton
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                child: Text('Payer',
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                )

              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: MyAppBar(titleText: "Wallet"),
      body:Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Texte "F"
                    Text(
                      "F ",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Abel",
                          fontWeight: FontWeight
                              .bold), // Définir la taille de la police selon vos préférences
                    ),
                    // Montant
                    Text(
                      !hidden ? balans : "******",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Abel",
                          fontWeight: FontWeight
                              .bold), // Définir la taille de la police selon vos préférences
                    ),
                    // Bouton pour afficher ou cacher le montant
                    IconButton(
                      icon: Icon(hidden
                          ? Icons.visibility
                          : Icons
                          .visibility_off), // Utiliser l'icône "visibility" pour afficher
                      onPressed: () {
                        // Logique pour afficher ou cacher le montant
                        setState(() {
                          hidden = !hidden;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Charged by",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Abel",
                            fontWeight: FontWeight.bold)
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(cardInfo.length, (index) =>
                          GestureDetector(
                            onTap: () async{
                              setState(() {
                                selectedCardIndex = index;
                                _showChargeModal(context);
                              });
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                    "assets/paiement/${cardInfo[index]['image']}"),
                                SizedBox(height: 8.0),
                                Text(
                                  cardInfo[index]['text'],
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    )
                  ],
                ),
                SizedBox(height: 24),
                Text("Historique des transactions",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Abel",
                        fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 12.0),
                walletLog["walletlog"].isNotEmpty ?
                  Expanded(child: Container(
                    child: ListView(
                      children:  walletLog["walletlog"].map<Widget>((log) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("${log["id"]}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Abel",
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(width: 12.0),
                                      Text(getArrivalText(log["arrival"]),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Abel",
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(width: 4.0),
                                      log["arrival"] == 0 ? Icon(Icons.call_made, color: Colors.red, size: 12.0,) : Icon(Icons.call_received, color: Colors.blue, size: 12.0),
                                    ],
                                  ),
                                  Text(
                                    log["arrival"] == 0
                                        ? !hidden
                                        ? "F -${log["amount"]}"
                                        : "F -******"
                                        : !hidden
                                        ? "F +${log["amount"]}"
                                        : "F +******",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: log["arrival"] == 0
                                            ? errorColor
                                            : successColor,
                                        fontFamily: "Abel",
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Divider(
                                height: 5,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ))
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Aucun historique trouvé",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Abel",
                          fontWeight: FontWeight.w300),
                    )
                  ],
                )
              ],
            )
          ),
          _loading
              ? LoadingWidget()
              : Container(),
        ],
      )
    );
  }

  connexionBtn(size) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Column(
              children: List.generate(
                cardInfo.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Radio<int>(
                          value: index,
                          groupValue: selectedCardIndex,
                          onChanged: (value) async {
                            /* setState(() {
                                  selectedCardIndex = value!;
                                  print(
                                      "value___________------______----_____-----______---");
                                  print(value);
                                }); */
                            await showSheet2(value, size);
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                          width: 5,
                        ),
                        Text(
                          cardInfo[index]['text'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Expanded(
                          child: cardInfo[index]['image'] == "paiement.png"
                              ? Image.asset(
                                  "assets/paiement/${cardInfo[index]['image']}",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showSheet2(index, size) async {
    if (_loadingSheet) {
      await showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.8, // Définir la hauteur à 80% de l'écran
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          });
    } else {
      await showModalBottomSheet(
        isScrollControlled:
            true, // Pour rendre le bottom sheet plein écran lorsqu'il est ouvert
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.8, // Définir la hauteur à 80% de l'écran
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: IntlPhoneField(
                      languageCode: "fr",
                      invalidNumberMessage: "Numéro incorrecte",
                      decoration: InputDecoration(
                        labelText: 'Numéro du paiement',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'CI',
                      onChanged: (phone) {
                        print(phone.number);
                        print(phone.completeNumber);
                        setState(() {
                          numero_paiement = phone.number;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  index == 0
                      ? Column(
                          children: [
                            Text(
                              "Composez le code ci-dessous pour obtenir le code OTP à 4 chiffres",
                              textAlign: TextAlign.center,
                              style: text16GrayScale100,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "#144*82#",
                              textAlign: TextAlign.center,
                              style: text16Primary,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            OTPTextField(
                                controller: otpController,
                                length: 4,
                                width: MediaQuery.of(context).size.width,
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldWidth: 45,
                                fieldStyle: FieldStyle.box,
                                outlineBorderRadius: 15,
                                style: TextStyle(fontSize: 17),
                                onChanged: (pin) {
                                  print("Changed: " + pin);
                                },
                                onCompleted: (pin) {
                                  print("Completed: " + pin);
                                  setState(() {
                                    otp = pin;
                                  });
                                }),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadingSheet = true;
                      });
                      print(_loadingSheet);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: numero_paiement == "" || otp == ""
                          ? greyScale60Color
                          : primaryColor, // Couleur de fond du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text('Payer', style: TextStyle(fontSize: 18.0)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void SuccesEchecDialog(bool etat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Arrondir les coins
          ),
          elevation: 0, // Supprimer l'ombre
          backgroundColor: Colors.transparent, // Fond transparent
          child: Container(
            //width: 327,
            //height: 380,
            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: etat
                        ? DecorationImage(
                            image: AssetImage(
                                "assets/paiement/succes.gif"), // Image depuis les assets
                            fit: BoxFit.fill,
                          )
                        : DecorationImage(
                            image: AssetImage(
                                "assets/paiement/echec.gif"), // Image depuis les assets
                            fit: BoxFit.fill,
                          ),
                    borderRadius: BorderRadius.circular(
                        50), // Arrondir les coins de l'image
                  ),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: Text(
                      !etat
                          ? 'Votre rechargement à echouer '
                          : 'Rechargement effectuer',
                      textAlign: TextAlign.center,
                      style: text20Secondary,
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                Row(
                    //width: double.infinity,
                    children: [
                      Expanded(
                        child: Text(
                          !etat
                              ? 'Merci de bien vouloir réessayer après avoir vérifié votre compte'
                              : 'Votre rechargement à été accepter',
                          textAlign: TextAlign.center,
                          style: text14GrayScale900,
                        ),
                      ),
                    ]),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 48,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          width: 263,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Color(0xFF03443C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              !etat
                                  ?
                                  // Actions lorsque le bouton est cliqué
                                  refreshPage()
                                  : refreshPage();
                              // Fermer le popup
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      !etat ? 'Réessayer' : 'OK',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFFEFEFE),
                                        fontSize: 16,
                                        fontFamily: 'Abel',
                                        fontWeight: FontWeight.w400,
                                        height: 0.09,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void startExecution(idFromClient, method) {
    // Créez un Timer périodique qui s'exécutera toutes les 20 secondes
    Timer.periodic(Duration(seconds: 10), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Vérifiez le statut du paiement
      print("object__________________________--------_____---__--_-__-");
      var responseStatus = await checkStatus(idFromClient);
      if (responseStatus["status"] == "SUCCESSFUL") {
        print("faileddddddddd");

        setState(() {
          _loading = false;
        });
        // Affichez un message en cas d'échec du paiement
        SuccesEchecDialog(false);
        timer.cancel();
      } else if (responseStatus["status"] == "FAILED") {
        var response = await walletTopUp(montantController.text);

        // Affichez un message en cas de succès du paiement

        // Arrêtez la boucle d'exécution car le paiement est réussi
        timer.cancel();

        setState(() {
          _loading = false;
        });
        SuccesEchecDialog(true);
      }
    });
  }
}
