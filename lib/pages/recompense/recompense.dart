import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/commande/commandes.dart';
import 'package:odrive/pages/favorite/favorite.dart';
import 'package:odrive/pages/home/home.dart';
import 'package:odrive/pages/recompense/scan.dart';
import 'package:odrive/pages/restaurant/restaurant.dart';
import 'package:odrive/themes/theme.dart';
import 'package:odrive/widget/haversine.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecompenseScreen extends StatefulWidget {
  final PointsUpdateNotifier notifier;
  RecompenseScreen({super.key, required this.notifier});

  @override
  State<RecompenseScreen> createState() => _RecompenseScreenState();
}

class _RecompenseScreenState extends State<RecompenseScreen> {
  List<String> monthNames = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre'
  ];
  List<dynamic> ExchangeCategory = [
    {"id": 1, "name": "Pour toi", "icon": ""},
    {"id": 2, "name": "Tendance de ${DateTime.now().month}", "icon": ""},
    {"id": 3, "name": "Promotions", "icon": ""}
  ];

  String SelectedName = "Pour toi";
  List<dynamic> foodData = [];
  List<dynamic> foodOfMonth = [];
  List<dynamic> foods = [];
  double lat = 0.0;
  double lng = 0.0;
  bool _loading = false;
  Map<String, dynamic> mainData = {};
  String taxe = "0";
  List<dynamic> restaurantData = [];
  dynamic favoriteData = {};
  String uuid = "";
  String qrData = "";
  int point = 0;
  TextEditingController textController = TextEditingController();
  TextEditingController reductionController = TextEditingController();

  String enteredText = "";
  String reductionText = "";

  List<dynamic> pointData = [];

  bool panierExist = false;
  double totalPanier = 0.0;
  int _itemCount = 0;

  Future<void> fetchAndSetPoints() async {
    var point_response = await getPoints();
    if (point_response["error"] == "0") {
      setState(() {
        point = point_response["points"];
      });
    } else {
      setState(() {
        point = 0;
      });
    }
  }

  int calculatePoints(List<dynamic> dataList, int point) {
    // Trier la liste par montant croissant
    dataList.sort((a, b) => a["point"].compareTo(b["point"]));

    // Vérifier si le montant exact existe
    for (var data in dataList) {
      if (data["point"] == point) {
        return data["montant"];
      }
    }

    // Si le montant exact n'existe pas, trouver le montant le plus proche
    int nearestMontant = int.parse(dataList.first["point"]);
    for (var data in dataList) {
      if ((point - int.parse(data["point"])).abs() <
          (point - nearestMontant).abs()) {
        nearestMontant = int.parse(data["point"]);
      }
    }

    // Faire une règle de trois pour obtenir le nombre de points
    for (var data in dataList) {
      if (int.parse(data["point"]) == nearestMontant) {
        double ratio = point / nearestMontant;
        return (double.parse(data["montant"]) * ratio).round();
      }
    }

    // Si aucun montant n'est trouvé, retourner zéro
    return 0;
  }

  @override
  void initState() {
    // TODO: implement initState
    // Écoutez les mises à jour des points

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("FirebaseMessaging.onMessage----- ${message.messageId}");
      print("Firebase messaging:onMessage: $message");
      print("Firebase message: ${message.data}");

      var tranfert = message.data["title"];
      if (tranfert != null && tranfert == 'Transfert de point') {
        await fetchAndSetPoints();
      }
    });
    _getMain();
    _getFavorite();
    _getFoodOfMonth();
    super.initState();

    _getItemCount();
    _getBasket();
  }

  Future<double> calculateTotal(Map<String, dynamic> responseData) async {
    List<dynamic> orderDetails = responseData['orderdetails'];
    double total = 0.0;

    orderDetails.forEach((orderDetail) {
      int count = orderDetail['count'];
      double foodPrice = double.parse(orderDetail['foodprice']);
      int extrasCount = orderDetail['extrascount'];
      double extrasPrice = double.parse(orderDetail['extrasprice']);

      double itemTotal = (count * foodPrice) + (extrasCount * extrasPrice);
      total += itemTotal;
    });

    return total;
  }

  _getBasket() async {
    /* setState(() {
      _loading = true;
    }); */
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await getBasket(prefs.getString("uuid") ?? "");
    print("response _getBaskettttttttt");
    print(response);
    if (response["error"] == "0" && response["orderdetails"].isNotEmpty) {
      double montantTotal = await calculateTotal(response);
      setState(() {
        totalPanier = montantTotal;
        panierExist = true;
      });
    } else {
      setState(() {
        panierExist = false;
      });
    }
  }

  _getItemCount() async {
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var countItem = await getItemCount(prefs.getString("uuid") ?? "");
    print(countItem);
    if (countItem["error"] == '0') {
      setState(() {
        _itemCount = countItem["item_count"];
      });
    }
    /* _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      
    }); */
  }

  _getFavorite() async {
    var response = await getFavorite();
    if (response["error"] == "0") {
      favoriteData = response;
    }
  }

  _getFoodOfMonth() async {
    var response = await foodsOfMonth();
    if (response["error"].toString() == "0") {
      setState(() {
        foodOfMonth = response["foods"];
      });
    } else {
      Fluttertoast.showToast(
          msg: "Une erreur s'est produite verifiez votre connexion");
    }
  }

  _getMain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _loading = true;
      lat = double.parse(prefs.getString("myLatitude") ?? "0.0");
      lng = double.parse(prefs.getString("myLongitude") ?? "0.0");
      uuid = prefs.getString("uuid") ?? "";
    });

    var point_response = await getPoints();
    if (point_response["error"] == "0") {
      setState(() {
        point = point_response["points"];
      });
    } else {
      setState(() {
        point = 0;
      });
    }
    var qr_response = await getQrCode();
    if (qr_response["error"] == "0") {
      setState(() {
        qrData = qr_response["qr_code"];
      });
    }
    mainData = await getMain();
    if (mainData["success"] == true) {
      setState(() {
        print("1111111111");
        taxe = mainData["default_tax"];
        restaurantData = mainData["restaurants"];
      });
      await addHaversineDistance(restaurantData, lat, lng);
      print("restaurantData-----------------");
      print(restaurantData[0]["distance"]);
      var mainDataSecond = await getSecondMain();
      if (mainDataSecond["error"].toString() == "0") {
        setState(() {
          //foodData = mainDataSecond["foods"];
          foods = mainDataSecond["foods"];
          foodData = foods;
          /* if (mainData["settings"]["rows"].contains("banner1")) {
            banner = true;
            bannerData = mainDataSecond['banner1'];
          }
          promotions = mainDataSecond['foods2']
              .where((food) => double.parse(food['discountprice']) != 0.0)
              .toList();
          foods = mainDataSecond['foods2']; */
        });
        //print(promotions);
      } else {
        print(mainDataSecond);
      }
      _loading = false;
    } else {
      print(mainData);
    }
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Navigator.pop(context);
    fetchAndSetPoints();
  }

  addHaversineDistance(List<dynamic> restaurantData, double userLatitude,
      double userLongitude) async {
    for (var restaurant in restaurantData) {
      final double restaurantLatitude = double.parse(restaurant['lat']);
      final double restaurantLongitude = double.parse(restaurant['lng']);

      final double distance = Haversine.calculateDistance(
          userLatitude, userLongitude, restaurantLatitude, restaurantLongitude);

      restaurant['distance'] = distance;
    }
  }

  void SuccesEchecDialog(bool etat, reduction, amount, coupon) {
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
                      !etat ? 'Votre paiement à echouer ' : 'Points échanger',
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
                              : 'Vous avez obtenu $reduction% de reduction sur votre prochaine commande d\'au moins $amount FCFA avec ce code coupon \n$coupon',
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
                                  : copyToClipboard(coupon); // Fermer le popup
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      !etat ? 'Réessayer' : 'Copier le coupon',
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

  List<dynamic> getFoodsBydiscount(List<dynamic> foods) {
    return foods
        .where((food) => double.parse(food["discountprice"]) > 0)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(titleText: "Echange de recompense"),
      body: _loading
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
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          //width: 327,
                          //height: 207,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Color(0xFFF2F2F2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Vos points",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Color(0xFF171725),
                                        fontSize: 18,
                                        fontFamily: 'Abel',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomPaint(
                                painter: MyCustomLine(
                                    point: double.parse(point.toString())),
                                size: Size(350.0, 50.0),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  //mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '$point',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF03443C),
                                            fontSize: 24,
                                            fontFamily: 'Abel',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Points',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF03443C),
                                            fontSize: 16,
                                            fontFamily: 'Abel',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            // Utilisez un TextEditingController pour contrôler le champ de saisie

                                            return AlertDialog(
                                              title: Text(
                                                  'obtenir des reductions'),
                                              content: TextField(
                                                controller: reductionController,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Entrez le nombre de point à échanger'),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Annuler'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Valider'),
                                                  onPressed: () async {
                                                    // Récupérez la valeur saisie lorsque l'utilisateur appuie sur Valider
                                                    reductionText =
                                                        reductionController
                                                            .text;
                                                    Navigator.of(context).pop();
                                                    var palier_response =
                                                        await getPallierWallet();
                                                    print(palier_response);
                                                    if (palier_response
                                                        .containsKey("error")) {
                                                      if (palier_response[
                                                              "error"] ==
                                                          "0") {
                                                        pointData =
                                                            palier_response[
                                                                "pallier"];
                                                        var montantWallet =
                                                            calculatePoints(
                                                                pointData,
                                                                int.parse(
                                                                    reductionText));
                                                        updatePoint(int.parse(
                                                            reductionText));
                                                        walletTopUp(
                                                            montantWallet);
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Points échangés");
                                                        fetchAndSetPoints();
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Une erreur s'est produite");
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Une erreur s'est produite");
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 126.64,
                                        height: 40,
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 8),
                                        decoration: ShapeDecoration(
                                          color: Color(0xFF332C45),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(23),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Echanger ',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Abel',
                                                fontWeight: FontWeight.w400,
                                                height: 0.09,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Container(
                                                width: 43.64,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/recompense/recompense.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? uid = prefs.getString("uuid");
                          print(uid);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              // Utilisez un TextEditingController pour contrôler le champ de saisie

                              return AlertDialog(
                                title: Text('Nombre de point'),
                                content: TextField(
                                  controller: textController,
                                  decoration: InputDecoration(
                                      hintText: 'Entrez le nombre de point'),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Annuler'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Valider'),
                                    onPressed: () {
                                      // Récupérez la valeur saisie lorsque l'utilisateur appuie sur Valider
                                      enteredText = textController.text;
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ScanScreen(
                                                  uuid: uid!,
                                                  pointTransfert: int.parse(
                                                      enteredText)))).then(
                                          (value) {
                                        if (value != "") {
                                          Fluttertoast.showToast(msg: value);
                                          fetchAndSetPoints();
                                        }
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: AutoLayoutHorizontal(
                          uuid: qrData,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: HorizontalExchangeList(
                          exchangeData: ExchangeCategory,
                          selectName: getCurrentMonthName(SelectedName),
                          onCategorySelected: (category, name) {
                            setState(() {
                              print("category------------------------");
                              print(category);
                              //selectedCategory = category;
                              //foodsFiltre = getFoodsByCategoryId(selectedCategory, foods);
                              //categorieName = name;
                              SelectedName = name;
                              if (category == 1) {
                                foodData = foods;
                              } else if (category == 2) {
                                foodData = foodOfMonth;
                              } else if (category == 3) {
                                foodData = getFoodsBydiscount(foods);
                              }
                            });
                            //print("selectedCategory-------------------");
                            //print(selectedCategory);
                            //print(foods);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: buildCardColumn(
                            foodData,
                            lat,
                            lng,
                            MediaQuery.of(context).size.width,
                            taxe,
                            favoriteData, () {
                          _getItemCount();
                          _getBasket();
                        }),
                      )
                    ],
                  ),
                ),
                panierExist
                    ? Positioned(
                        bottom: 15, // Aligner en bas de la page
                        left: 0, // Aligner à gauche de la page
                        right: 0, // Aligner à droite de la page
                        child: ButtonCheckout(
                          montant: totalPanier,
                          itemcount: _itemCount,
                          updateItemCounts: () {
                            _getItemCount();
                            _getBasket();
                          },
                        ))
                    : Container()
              ],
            ),
      bottomNavigationBar: MyBottomBarRecompense(),
    );
  }
}

class MyBottomBarRecompense extends StatefulWidget {
  @override
  _MyBottomBarRecompenseState createState() => _MyBottomBarRecompenseState();
}

class _MyBottomBarRecompenseState extends State<MyBottomBarRecompense> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 375,
      height: 70,
      padding: const EdgeInsets.only(top: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xFFFCFCFC),
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 20,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  //width: 76,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                child: Stack(children: [
                                  //Yoane
                                  SvgPicture.asset(
                                    "assets/home/home.svg",
                                    height: 24,
                                    width: 24,
                                    //color: primaryColor,
                                  )
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Home',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF66707A),
                          fontSize: 14,
                          fontFamily: 'Abel',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteScreen()));
                  },
                  child: Container(
                    //width: 76,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                child: Stack(children: [
                                  //Yoane
                                  SvgPicture.asset(
                                    "assets/home/heart.svg",
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Favorie',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF03443C),
                            fontSize: 14,
                            fontFamily: 'Abel',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommandesScreen()));
                  },
                  child: Container(
                    //width: 76,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                child: Stack(children: [
                                  SvgPicture.asset(
                                    "assets/home/order.svg",
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Commande',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF66707A),
                            fontSize: 14,
                            fontFamily: 'Abel',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 33),
                Container(
                  //width: 76,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              child: Stack(children: [
                                SvgPicture.asset(
                                  "assets/recompense/gift.svg",
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Reward',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF66707A),
                          fontSize: 14,
                          fontFamily: 'Abel',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* class PointCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 327,
          height: 207,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFFF2F2F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 40,
                top: 81,
                child: Text(
                  '10',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontSize: 12,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                ),
              ),
              Positioned(
                left: 74,
                top: 78,
                child: Text(
                  '20',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontSize: 12,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                ),
              ),
              Positioned(
                left: 107,
                top: 75,
                child: Text(
                  '30',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF9CA4AB),
                    fontSize: 12,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                ),
              ),
              Positioned(
                left: 140,
                top: 72,
                child: Text(
                  '40',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF9CA4AB),
                    fontSize: 12,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                ),
              ),
              Positioned(
                left: 173,
                top: 69,
                child: Text(
                  '50',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF9CA4AB),
                    fontSize: 12,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                ),
              ),
              Positioned(
                left: 206,
                top: 66,
                child: Text(
                  '60',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF9CA4AB),
                    fontSize: 12,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                ),
              ),
              Positioned(
                left: 239,
                top: 63,
                child: Text(
                  '70',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF9CA4AB),
                    fontSize: 12,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                ),
              ),
              Positioned(
                left: 271,
                top: 60,
                child: Text(
                  '80',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF9CA4AB),
                    fontSize: 12,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 81,
                child: Container(
                  width: 295,
                  height: 38,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 29,
                        top: 0,
                        child: Container(
                          width: 237,
                          height: 27,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 21,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF03443C),
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 33,
                                top: 18,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF03443C),
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 66,
                                top: 15,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFBFC6CC),
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 99,
                                top: 12,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFBFC6CC),
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 132,
                                top: 9,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFBFC6CC),
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 165,
                                top: 6,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFBFC6CC),
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 198,
                                top: 3,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFBFC6CC),
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 231,
                                top: 0,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFBFC6CC),
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 143,
                child: Container(
                  width: 287,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        //width: 99.36,
                        height: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '20',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF03443C),
                                fontSize: 24,
                                fontFamily: 'Abel',
                                fontWeight: FontWeight.w400,
                                height: 0.06,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Points',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF03443C),
                                fontSize: 16,
                                fontFamily: 'Abel',
                                fontWeight: FontWeight.w400,
                                height: 0.09,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 42),
                      Container(
                        width: 126.64,
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        decoration: ShapeDecoration(
                          color: Color(0xFF332C45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Exchange ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Abel',
                                fontWeight: FontWeight.w400,
                                height: 0.09,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 43.64,
                              height: 36,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://via.placeholder.com/44x36"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 32,
                top: 24,
                child: Text(
                  'Your points',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontSize: 18,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                    height: 0.09,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} */

class MyCustomLine extends CustomPainter {
  double point;
  MyCustomLine({required this.point});
  @override
  void paint(Canvas canvas, Size size) {
    Paint blackPaint = Paint()..color = whiteColor;
    Paint redPaint = Paint()..color = greyScale40Color;
    Paint pointPaint = Paint()..color = secondaryColor;
    TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 10.0);

    // Coordonnées des points
    Offset pointA = Offset(0.0, size.height); // Coin inférieur gauche
    Offset pointB = Offset(size.width, size.height); // Coin inférieur droit
    Offset pointC = Offset(size.width, 0.0); // Coin supérieur droit

    // Dessine le fond du triangle
    Path backgroundPath = Path()
      ..moveTo(pointA.dx, pointA.dy)
      ..lineTo(pointB.dx, pointB.dy)
      ..lineTo(pointC.dx, pointC.dy)
      ..close();
    canvas.drawPath(backgroundPath, redPaint);

    // Dessine le dégradé jaune
    Paint yellowGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [secondaryColor, greyScale40Color],
        stops: [
          point / 100,
          point / 100
        ], // 0.0 pour la couleur jaune et 1.0 pour le gris
      ).createShader(Rect.fromPoints(pointA, pointC));
    canvas.drawPath(backgroundPath, yellowGradientPaint);

    // Dessine les côtés du triangle avec des bords arrondis
    Path trianglePath = Path()
      ..moveTo(pointA.dx, pointA.dy)
      ..lineTo(pointB.dx, pointB.dy)
      ..cubicTo(
          pointB.dx, pointB.dy, pointC.dx, pointC.dy, pointB.dx, pointB.dy)
      ..close();
    canvas.drawPath(trianglePath, blackPaint);

    // Dessine les points le long de l'hypoténuse avec des valeurs
    List<Offset> points = [];
    List<int> values =
        List.generate(11, (index) => index * 10); // Valeurs de 0 à 100
    double hypotenuseLength = sqrt(pow(size.width, 2) + pow(size.height, 2));
    double distanceBetweenPoints = hypotenuseLength / 10;
    double currentDistance = 0;

    while (currentDistance <= hypotenuseLength) {
      double t = currentDistance / hypotenuseLength;
      double x = pointA.dx + t * (pointC.dx - pointA.dx);
      double y = pointA.dy + t * (pointC.dy - pointA.dy);
      points.add(Offset(x, y));
      currentDistance += distanceBetweenPoints;
    }

    for (int i = 0; i < points.length; i++) {
      Offset point = points[i];
      // Dessine le cercle blanc pour la bordure
      canvas.drawCircle(point, 5.0, Paint()..color = whiteColor);
      // Dessine le cercle intérieur correspondant à la couleur du point
      canvas.drawCircle(point, 3.0, pointPaint);
      TextSpan span = TextSpan(
        style: textStyle,
        text: values[i].toString(),
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(point.dx, point.dy - tp.height));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HorizontalExchangeList extends StatelessWidget {
  List<dynamic> exchangeData;
  final Function(int, String)? onCategorySelected;
  String selectName;

  HorizontalExchangeList(
      {required this.exchangeData,
      this.onCategorySelected,
      required this.selectName});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: exchangeData.length,
        itemBuilder: (context, index) {
          return Row(children: [
            GestureDetector(
              onTap: () {
                if (onCategorySelected != null) {
                  onCategorySelected!(
                      exchangeData[index]["id"], exchangeData[index]["name"]);
                }
              },
              child: exchangeBtn(
                  getCurrentMonthName(exchangeData[index]["name"]),
                  selectName,
                  exchangeData[index]["icon"]),
            ),
            SizedBox(width: 15),
          ] // Espaceur entre les boutons
              );
        },
      ),
    );
  }
}

exchangeBtn(String categoryName, String selectName, String icon) {
  return Container(
    width: 150,
    //height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: categoryName == selectName ? secondaryColor : greyScale30Color),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != "" ? SvgPicture.asset(icon) : Container(),
          Text(
            categoryName,
            style: categoryName == selectName ? text16White : text16neutral90,
          ),
        ],
      ),
    ),
  );
}

String getCurrentMonthName(String exchangeName) {
  String newText = "";
  if (exchangeName.contains(DateTime.now().month.toString())) {
    List<String> monthNames = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    DateTime now = DateTime.now();
    newText = exchangeName.replaceAll(
        DateTime.now().month.toString(), monthNames[now.month - 1]);
  } else {
    newText = exchangeName;
  }

  return newText;
}

class AutoLayoutHorizontal extends StatelessWidget {
  String uuid;
  AutoLayoutHorizontal({required this.uuid});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //width: 327,
          //height: 92,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 180,
                child: Text(
                  'Scannez le Qr Code pour gagner plus de point',
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontSize: 18,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 62),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    Container(
                      width: 60,
                      height: 60,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 2.50,
                            top: 2.50,
                            child: Container(
                              width: 55,
                              height: 55,
                              child: PrettyQr(
                                data: uuid,
                                size: 55,
                                elementColor: successColor,
                                errorCorrectLevel: QrErrorCorrectLevel.L,
                              ),
                              /* decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://via.placeholder.com/55x55"),
                                  fit: BoxFit.fill,
                                ),
                              ) */
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PointsUpdateNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get onUpdate => _controller.stream;

  void notifyUpdate() {
    _controller.add(null);
  }
}
