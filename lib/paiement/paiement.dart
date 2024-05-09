import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/suivie/suivie.dart';
import 'package:odrive/themes/theme.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:event_bus/event_bus.dart';

// Créez une classe d'événement pour représenter l'intégration de l'utilisateur avec Google
class UserGoogleIntegrationEvent {}

// Créez une instance de l'EventBus
EventBus eventBus = EventBus();

class PaiementScreen extends StatefulWidget {
  dynamic dataComplet;
  double totalMontant;
  double excedant;
  dynamic reduction;
  String cardNumber = '';
  PaiementScreen(
      {Key? key,
      required this.dataComplet,
      required this.totalMontant,
      required this.excedant,
      required this.reduction})
      : super(key: key);

  @override
  State<PaiementScreen> createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {
  int selectedCardIndex = -1;
  int selectedMobileMoney = -1;
  bool selectedCardVisa = false;
  int selectedValue = 1;
  String otp = "";
  String numero_paiement = "";
  OtpFieldController otpController = OtpFieldController();
  StreamSubscription<UserGoogleIntegrationEvent>? subscription;
  List<dynamic> basket = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _loading = false;
  dynamic dataCompletReformated = {};
  List<MyData> pallierData = [];

  TextEditingController _controller = TextEditingController();
  String _visaCardNumber = '';
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> cardInfo = [
    {
      'text': 'ORANGE',
      'image': 'orange.png',
    },
    {
      'text': 'MTN',
      'image': 'mtn.png',
    },
    {
      'text': 'MOOV',
      'image': 'moov.png',
    },
    {
      'text': 'WAVE',
      'image': 'wave.png',
    },
    {
      'text': 'Wallet',
      'image': 'moov.png',
    },
    {
      'text': 'à la livraison',
      'image': 'orange.png',
    },
  ];

  String expiryDate = '';
  String cardNumber = '';
  String cardHolderName = '';
  String cvvCode = '';

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    print("object");
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      //isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void addOrderDetailsToBasket(Map<String, dynamic> dataCompletFormated) async {
    List<dynamic> _basket = [];
    if (dataCompletFormated.containsKey('orderdetails')) {
      List<dynamic> orderDetails = dataCompletFormated['orderdetails'];
      for (var detail in orderDetails) {
        print(detail);
        var response = await getFoodById(detail["foodid"].toString());
        if (response["error"] == "0") {
          Map<String, dynamic> basketItem = {
            "id": response["food"]["id"].toString(),
            "name": response["food"]["name"].toString(),
            "published": response["food"]["published"].toString(),
            "restaurant": response["food"]["restaurant"].toString(),
            "restaurantName": response["food"]["restaurantName"].toString(),
            "image": response["food"]["image"].toString(),
            "desc": response["food"]["desc"].toString(),
            "ingredients": response["food"]["ingredients"].toString(),
            "nutritions": response["food"]["nutritionsdata"],
            "extras": (detail["extrasdata"] as List<dynamic>)
                .where((item) => item["extrascount"] > 0)
                .map((item) => {
                      "name": item["extras"],
                      "price": double.parse(item["extrasprice"])
                          .toInt(), //mettre en int
                      "count": item["extrascount"],
                      "id": item["extrasid"],
                      "image": item["image"],
                    })
                .toList(),
            "foodsreviews": response["food"]["foodsreviews"],
            "variants": response["food"]["variants"],
            "restaurantPhone": response["food"]["restaurantPhone"].toString(),
            "restaurantMobilePhone":
                response["food"]["restaurantMobilePhone"].toString(),
            "price": double.parse(response["food"]["price"]),
            "discountprice": double.parse(response["food"]["discountprice"]),
            "category": response["food"]["category"].toString(),
            "fee": response["food"]['fee'].toString(),
            "discount": "",
            "rproducts": response["food"]['rproducts'],
            "ver": "1",
            "tax": dataCompletFormated["default_tax"],
            "delivered": false,
            "count": detail["count"],
            "imagesFiles": response["food"].containsKey("imagesFiles")
                ? response["food"]["imagesFiles"]
                : []
            // Ajoutez ici d'autres champs nécessaires à partir de dataComplet
            // Par exemple : "restaurantName": dataComplet["restaurant"]["name"].toString(),
          };
          _basket.add(basketItem);
        }
      }
    }
    setState(() {
      basket = _basket;
    });
    print(basket);
  }

  dynamic reformatOrderDetails(dynamic dataComplet) {
    List<dynamic> orderDetails = dataComplet['orderdetails'];
    Map<int, Map<String, dynamic>> reorganizedMap = {};

    for (var item in orderDetails) {
      int foodId = item['foodid'];

      if (item['count'] > 0) {
        if (!reorganizedMap.containsKey(foodId)) {
          reorganizedMap[foodId] = item;
          reorganizedMap[foodId]!['extrasdata'] =
              []; // Ajouter extrasdata avec une liste vide
        }
      } else {
        if (reorganizedMap.containsKey(foodId)) {
          reorganizedMap[foodId]!['extrasdata'].add(item);
        } else {
          // Créer une nouvelle entrée pour le plat avec la liste extrasdata
          reorganizedMap[foodId] = {
            ...item,
            'count': 0,
            'extrasdata': [item]
          };
        }
      }
    }

    List<Map<String, dynamic>> reorganizedList = reorganizedMap.values.toList();

    // Mettre à jour la liste orderdetails dans dataComplet avec les détails réorganisés
    dataComplet['orderdetails'] = reorganizedList;

    return dataComplet;
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
                          ? 'Votre paiement à echouer '
                          : 'Paiement effectuer',
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
                              : 'Vous pouvez suivre votre commande',
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
                                  Navigator.of(context).pop()
                                  : Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SuivieScreen(
                                                order_id: widget
                                                    .dataComplet["order"]["id"],
                                              )),
                                    );
                              ; // Fermer le popup
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      !etat
                                          ? 'Réessayer'
                                          : 'Suivre ma commande',
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

  void startExecution(idFromClient, method, myBasket) {
    print(myBasket);
    // Créez un Timer périodique qui s'exécutera toutes les 20 secondes
    Timer.periodic(Duration(seconds: 10), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Vérifiez le statut du paiement
      print("object__________________________--------_____---__--_-__-");
      var responseStatus = await checkStatus(idFromClient);
      if (responseStatus["status"] == "SUCCESSFUL") {
        print("faileddddddddd");
        await savePaiement(responseStatus, widget.dataComplet["order"]["id"]);
        setState(() {
          _loading = false;
        });
        // Affichez un message en cas d'échec du paiement
        SuccesEchecDialog(false);
        timer.cancel();
      } else if (responseStatus["status"] == "FAILED") {
        await savePaiement(responseStatus, widget.dataComplet["order"]["id"]);
        print(widget.reduction);

        String uuid = prefs.getString("uuid") ?? "";
        String phone = prefs.getString("userPhone") ?? "";
        String address = prefs.getString("myAdresse") ?? "";
        String lat = prefs.getString("myLatitude") ?? "";
        String lng = prefs.getString("myLongitude") ?? "";
        String restaurant =
            widget.dataComplet["order"]["restaurant"].toString();
        double total = widget.totalMontant;
        String fee = (double.parse(widget.dataComplet["restaurant"]["fee"]) +
                widget.excedant)
            .toStringAsFixed(0);

        String tax = widget.dataComplet["default_tax"];

        var response = await resetBasket(uuid);
        if (response["error"] == "0") {
          addToBasket(myBasket, uuid, tax, "hint", restaurant, method, fee, "1",
              address, phone, total, lat, lng, "false", "");
        } else {
          Fluttertoast.showToast(msg: response["error"]);
        }

        int points = calculatePoints(
            pallierData, int.parse(widget.totalMontant.toStringAsFixed(0)));
        if (points > 0) {
          var response = await addPoint(points);
          if (response["error"] == "0") {
            print("points-------------------------");
            print(points);
            print("points-------------------------");
          }
        }

        // Affichez un message en cas de succès du paiement

        // Arrêtez la boucle d'exécution car le paiement est réussi
        timer.cancel();
        if (widget.reduction != null) {
          await updateOrderCoupon(widget.reduction["couponName"],
              widget.dataComplet["order"]["id"].toString());
        }
        setState(() {
          _loading = false;
        });
        SuccesEchecDialog(true);
      } else {
        await savePaiement(responseStatus, widget.dataComplet["order"]["id"]);
      }
    });
  }

  void startExecutionWave(idFromClient) async {
    // Vérifiez le statut du paiement
    print("object__________________________--------_____---__--_-__-");
    var responseStatus = await checkStatus(idFromClient);
    if (responseStatus["status"] == "SUCCEED") {
      await savePaiement(responseStatus, widget.dataComplet["order"]["id"]);
      setState(() {
        _loading = false;
      });
      // Affichez un message en cas d'échec du paiement
      SuccesEchecDialog(false);
    } else if (responseStatus["status"] == "FAILED") {
      await savePaiement(responseStatus, widget.dataComplet["order"]["id"]);
      if (widget.reduction != null) {
        await updateOrderCoupon(widget.reduction["couponName"],
            widget.dataComplet["order"]["id"].toString());
      }
      int points = calculatePoints(
          pallierData, int.parse(widget.totalMontant.toStringAsFixed(0)));
      if (points > 0) {
        var response = await addPoint(points);
        if (response["error"] == "0") {
          print("points-------------------------");
          print(points);
          print("points-------------------------");
        }
      }
      setState(() {
        _loading = false;
      });
      // Affichez un message en cas de succès du paiement
      SuccesEchecDialog(true);

      // Arrêtez la boucle d'exécution car le paiement est réussi

    } else {
      await savePaiement(responseStatus, widget.dataComplet["order"]["id"]);
      setState(() {
        _loading = false;
      });
      // Affichez un message en cas de succès du paiement
      SuccesEchecDialog(false);

      // Arrêtez la boucle d'exécution car le paiement est réussi

    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler());
    // TODO: implement initState
    super.initState();
    dataCompletReformated = reformatOrderDetails(widget.dataComplet);
    print(dataCompletReformated);
    addOrderDetailsToBasket(dataCompletReformated);
    /* if (widget.totalMontant > 3000) {
      cardInfo = [
        {
          'text': 'ORANGE',
          'image': 'orange.png',
        },
        {
          'text': 'MTN',
          'image': 'mtn.png',
        },
        {
          'text': 'MOOV',
          'image': 'moov.png',
        },
        {
          'text': 'WAVE',
          'image': 'wave.png',
        },
        {
          'text': 'Wallet',
          'image': 'moov.png',
        }
      ];
    } */
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  /* Future<void> launchWave(String url) async {
    print(url);
    /* inal Uri toLaunch = Uri(
      scheme: Uri.parse(url).scheme,
      host: Uri.parse(url).host,
      path: Uri.parse(url).path,
    );
    print(url); */
    Uri uri = Uri.parse(url);
    print(uri);
    await launchUrl(uri);
    /* if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    } */
  } */

  Future<void> launchWave(String url) async {
    print(url);
    await launch(url);

    /*}  else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    } */
  }

  SimpleDialog buildSingleChoiceDialog(BuildContext context) {
    //int selectedValue = 1;

    return SimpleDialog(
      title: Text('Choose an option'),
      children: [
        RadioListTile(
          title: Text('Orange Money'),
          value: 1,
          groupValue: selectedValue,
          onChanged: (value) {
            selectedValue = value!;
            Navigator.pop(context, selectedValue);
          },
        ),
        RadioListTile(
          title: Text('Moov Money'),
          value: 2,
          groupValue: selectedValue,
          onChanged: (value) {
            selectedValue = value!;
            Navigator.pop(context, selectedValue);
          },
        ),
        RadioListTile(
          title: Text('MTN Money'),
          value: 3,
          groupValue: selectedValue,
          onChanged: (value) {
            selectedValue = value!;
            Navigator.pop(context, selectedValue);
          },
        ),
        RadioListTile(
          title: Text('Wave'),
          value: 4,
          groupValue: selectedValue,
          onChanged: (value) {
            selectedValue = value!;
            Navigator.pop(context, selectedValue);
          },
        ),
        ButtonBar(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedValue);
              },
              child: Text('OK'),
            ),
          ],
        ),
      ],
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
      appBar: MyAppBar(titleText: "Paiement"),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCardIndex = -1;
                        selectedCardVisa = true;
                        _scrollToBottom();
                      });
                    },
                    child: Column(
                      children: [
                        CreditCardWidget(
                            cardNumber: cardNumber,
                            expiryDate: expiryDate,
                            cardHolderName: cardHolderName,
                            cvvCode: cvvCode,
                            showBackView: false,
                            cardBgColor: primaryColor,
                            onCreditCardWidgetChange: (p) {
                              print("ppppppppppp");
                              print(p);
                            }),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                horizontalRow(),
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
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedCardIndex = index;
                              selectedMobileMoney = index;
                              selectedCardVisa = false;
                              _scrollToBottom();
                            });
                            print(selectedMobileMoney);
                            /* if (selectedCardIndex == 0) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return buildSingleChoiceDialog(context);
                                },
                              ).then((value) {
                                print(value);
                                setState(() {
                                  selectedMobileMoney = value;
                                });
                                print("+++++++++++++++++++++++++++++++++++");
                              });
                            } */
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: selectedCardIndex,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCardIndex = value!;
                                  });
                                  print(selectedCardIndex);
                                  print(
                                      "selectedCardIndex------------------------------------------");
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
                                child:
                                    cardInfo[index]['image'] == "paiement.png"
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
                ),
                SizedBox(
                  height: 55,
                ),
                Column(
                  children: [
                    selectedCardIndex == 0 ||
                            selectedCardIndex == 1 ||
                            selectedCardIndex == 2 ||
                            selectedCardIndex == 3
                        ? Padding(
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
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    selectedCardVisa
                        ? Column(
                            children: [
                              CreditCardForm(
                                  cardNumber: cardNumber,
                                  expiryDate: expiryDate,
                                  cardHolderName: cardHolderName,
                                  cvvCode: cvvCode,
                                  onCreditCardModelChange:
                                      onCreditCardModelChange,
                                  themeColor: primaryColor,
                                  formKey: formKey,
                                  cardNumberDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Numéro de la carte',
                                    hintText: 'XXXX XXXX XXXX XXXX',
                                  ),
                                  expiryDateDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Date d\'expiration',
                                    hintText: 'MM/AA',
                                  ),
                                  cvvCodeDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'CVV',
                                    hintText: 'CVV',
                                  ),
                                  cardHolderDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Titulaire de la carte',
                                    hintText: 'Nom complet',
                                  ))
                            ],
                          )
                        : Container(),
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
                        : Container()
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String completName = prefs.getString("userName") ?? "";
                      var palier_response = await getPointPalier();
                      if (palier_response["error"] == "0") {
                        pallierData = parseMyData(palier_response["pallier"]);
                      }
                      List<String> nameParts = completName.split(' ');
                      String name = nameParts.isNotEmpty ? nameParts.first : '';
                      String prenoms = nameParts.sublist(1).join(' ');
                      DateTime now = DateTime.now();
                      var idFromClient =
                          "${now.millisecondsSinceEpoch}T${widget.dataComplet["order"]["id"]}C";
                      if (selectedCardIndex != -1 || !_loading) {
                        /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaiementScreen()),
              ); */
                        if (selectedCardIndex == 0) {
                          var response = await paiementom(
                              idFromClient,
                              prefs.getString("userEmail"),
                              name,
                              prenoms,
                              numero_paiement,
                              otp,
                              widget.totalMontant.toStringAsFixed(0));
                          print(
                              "responseeeeeee-------------------------------");
                          print(response);
                          if (response["status"] == "SUCCESSFUL") {
                            await savePaiement(
                                response, widget.dataComplet["order"]["id"]);
                            if (widget.reduction != null) {
                              await updateOrderCoupon(
                                  widget.reduction["couponName"],
                                  widget.dataComplet["order"]["id"].toString());
                            }

                            int points = calculatePoints(
                                pallierData,
                                int.parse(
                                    widget.totalMontant.toStringAsFixed(0)));
                            if (points > 0) {
                              var response = await addPoint(points);
                              if (response["error"] == "0") {
                                print("points-------------------------");
                                print(points);
                                print("points-------------------------");
                              }
                            }
                            setState(() {
                              _loading = false;
                            });
                            SuccesEchecDialog(true);
                          } else if (response["status"] == "FAILED") {
                            await savePaiement(
                                response, widget.dataComplet["order"]["id"]);

                            setState(() {
                              _loading = false;
                            });
                            SuccesEchecDialog(false);
                          } else {
                            startExecution(
                                idFromClient, "ORANGE MONEY", basket);
                          }
                        }
                        if (selectedCardIndex == 2) {
                          var response = await paiementmoov(
                              idFromClient,
                              prefs.getString("userEmail"),
                              name,
                              prenoms,
                              numero_paiement,
                              widget.totalMontant.toStringAsFixed(0));

                          if (response["status"] == "SUCCESSFUL") {
                            await savePaiement(
                                response, widget.dataComplet["order"]["id"]);
                            if (widget.reduction != null) {
                              await updateOrderCoupon(
                                  widget.reduction["couponName"],
                                  widget.dataComplet["order"]["id"].toString());
                            }

                            int points = calculatePoints(
                                pallierData,
                                int.parse(
                                    widget.totalMontant.toStringAsFixed(0)));
                            if (points > 0) {
                              var response = await addPoint(points);
                              if (response["error"] == "0") {
                                print("points-------------------------");
                                print(points);
                                print("points-------------------------");
                              }
                            }
                            setState(() {
                              _loading = false;
                            });
                            SuccesEchecDialog(true);
                          } else if (response["status"] == "FAILED") {
                            await savePaiement(
                                response, widget.dataComplet["order"]["id"]);
                            setState(() {
                              _loading = false;
                            });
                            SuccesEchecDialog(false);
                          } else {
                            startExecution(idFromClient, "MOOV MONEY", basket);
                          }
                        }

                        if (selectedCardIndex == 1) {
                          print("paiementMtn");
                          var response = await paiementmtn(
                              idFromClient,
                              prefs.getString("userEmail"),
                              name,
                              prenoms,
                              numero_paiement,
                              widget.totalMontant.toStringAsFixed(0));

                          if (response["status"] == "SUCCESSFUL") {
                            await savePaiement(
                                response, widget.dataComplet["order"]["id"]);
                            if (widget.reduction != null) {
                              await updateOrderCoupon(
                                  widget.reduction["couponName"],
                                  widget.dataComplet["order"]["id"].toString());
                            }

                            int points = calculatePoints(
                                pallierData,
                                int.parse(
                                    widget.totalMontant.toStringAsFixed(0)));
                            if (points > 0) {
                              var response = await addPoint(points);
                              if (response["error"] == "0") {
                                print("points-------------------------");
                                print(points);
                                print("points-------------------------");
                              }
                            }
                            setState(() {
                              _loading = false;
                            });
                            SuccesEchecDialog(true);
                          } else if (response["status"] == "FAILED") {
                            await savePaiement(
                                response, widget.dataComplet["order"]["id"]);
                            setState(() {
                              _loading = false;
                            });
                            SuccesEchecDialog(false);
                          } else {
                            startExecution(idFromClient, "MTN MONEY", basket);
                          }
                        }
                        if (selectedCardIndex == 3) {
                          var response = await paiementwave(
                              idFromClient,
                              prefs.getString("userEmail"),
                              name,
                              prenoms,
                              numero_paiement,
                              widget.totalMontant.toStringAsFixed(0));
                          print(response);

                          if (response["status"] == "INITIATED" ||
                              response["status"] == "PENDING") {
                            await savePaiement(
                                response, widget.dataComplet["order"]["id"]);
                            await launchWave(response["payment_url"]);
                            subscription = eventBus
                                .on<UserGoogleIntegrationEvent>()
                                .listen((event) {
                              // Faites ce que vous devez faire lorsque l'événement se produit
                              startExecutionWave(idFromClient);
                            });
                          }
                        }
                        if (selectedCardIndex == 4) {
                          String uuid = prefs.getString("uuid") ?? "";
                          String phone = prefs.getString("userPhone") ?? "";
                          String address = prefs.getString("myAdresse") ?? "";
                          String lat = prefs.getString("myLatitude") ?? "";
                          String lng = prefs.getString("myLongitude") ?? "";
                          String restaurant = widget.dataComplet["order"]
                                  ["restaurant"]
                              .toString();
                          double total = widget.totalMontant;
                          String fee = (double.parse(
                                      widget.dataComplet["restaurant"]["fee"]) +
                                  widget.excedant)
                              .toStringAsFixed(0);

                          String tax = widget.dataComplet["default_tax"];
                          print("herrrreeeee1");

                          var response_wallet = await payOnWallet(total);
                          print(response_wallet);
                          if (response_wallet.containsKey("error")) {
                            print("herrrreeeee2");
                            if (response_wallet["error"].toString() == "0") {
                              print("object");
                              var response = await resetBasket(uuid);
                              print("object2");
                              if (response["error"] == "0") {
                                addToBasket(
                                    basket,
                                    uuid,
                                    tax,
                                    "hint",
                                    restaurant,
                                    "WALLET",
                                    fee,
                                    "1",
                                    address,
                                    phone,
                                    total,
                                    lat,
                                    lng,
                                    "false",
                                    "");
                              } else {
                                Fluttertoast.showToast(
                                    msg: response["error"],
                                    backgroundColor: errorColor);
                              }
                              setState(() {
                                _loading = false;
                              });
                              SuccesEchecDialog(true);
                            } else if (response_wallet["error"].toString() ==
                                "1") {
                              setState(() {
                                _loading = false;
                              });
                              Fluttertoast.showToast(
                                  msg: "Votre solde est insuffisant",
                                  backgroundColor: errorColor,
                                  toastLength: Toast.LENGTH_LONG);
                            } else {
                              setState(() {
                                _loading = false;
                              });
                              Fluttertoast.showToast(
                                  msg: response_wallet["error"],
                                  backgroundColor: errorColor,
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          } else {
                            setState(() {
                              _loading = false;
                            });
                            print("herrrreeeee3");
                            Fluttertoast.showToast(
                                msg:
                                    "Une erreur s'est produite! Verifiez votre connexion");
                          }
                        }
                        if (selectedCardIndex == 5) {
                          if (widget.totalMontant > 3000) {
                            Fluttertoast.showToast(
                                msg:
                                    'paiement à la livraison seulement pour les montant inférieur à 3000 FCFA',
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: redColor,
                                toastLength: Toast.LENGTH_LONG);
                            setState(() {
                              _loading = false;
                            });
                          } else {
                            String uuid = prefs.getString("uuid") ?? "";
                            String phone = prefs.getString("userPhone") ?? "";
                            String address = prefs.getString("myAdresse") ?? "";
                            String lat = prefs.getString("myLatitude") ?? "";
                            String lng = prefs.getString("myLongitude") ?? "";
                            String restaurant = widget.dataComplet["order"]
                                    ["restaurant"]
                                .toString();
                            double total = widget.totalMontant;
                            String fee = (double.parse(widget
                                        .dataComplet["restaurant"]["fee"]) +
                                    widget.excedant)
                                .toStringAsFixed(0);

                            String tax = widget.dataComplet["default_tax"];

                            var response = await resetBasket(uuid);
                            if (response["error"] == "0") {
                              addToBasket(
                                  basket,
                                  uuid,
                                  tax,
                                  "hint",
                                  restaurant,
                                  "À LA LIVRAISON",
                                  fee,
                                  "1",
                                  address,
                                  phone,
                                  total,
                                  lat,
                                  lng,
                                  "false",
                                  "");
                            } else {
                              Fluttertoast.showToast(msg: response["error"]);
                            }
                            setState(() {
                              _loading = false;
                            });
                            SuccesEchecDialog(true);
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: selectedCardIndex == -1 || _loading
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
      // Position du bouton flottant
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler();

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        eventBus.fire(UserGoogleIntegrationEvent());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
    }
  }
}

class MyData {
  final int id;
  final int montant;
  final int nbrePoint;

  MyData({
    required this.id,
    required this.montant,
    required this.nbrePoint,
  });

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      id: json['id'],
      montant: int.parse(json['montant']),
      nbrePoint: int.parse(json['nbre_point']),
    );
  }
}

List<MyData> parseMyData(dynamic parsed) {
  //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<MyData>((json) => MyData.fromJson(json)).toList();
}

int calculatePoints(List<MyData> dataList, int montant) {
  // Trier la liste par montant croissant
  dataList.sort((a, b) => a.montant.compareTo(b.montant));

  // Vérifier si le montant exact existe
  for (var data in dataList) {
    if (data.montant == montant) {
      return data.nbrePoint;
    }
  }

  // Si le montant exact n'existe pas, trouver le montant le plus proche
  int nearestMontant = dataList.first.montant;
  for (var data in dataList) {
    if ((montant - data.montant).abs() < (montant - nearestMontant).abs()) {
      nearestMontant = data.montant;
    }
  }

  // Faire une règle de trois pour obtenir le nombre de points
  for (var data in dataList) {
    if (data.montant == nearestMontant) {
      double ratio = montant / nearestMontant;
      return (data.nbrePoint * ratio).round();
    }
  }

  // Si aucun montant n'est trouvé, retourner zéro
  return 0;
}

class VisaCardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (text.length > 0 && (text.length % 5) == 0) {
      final newText = '${oldValue.text} ';
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }
}
