import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/components/loading.dart';
import 'package:odrive/pages/commande/commande.dart';
import 'package:odrive/constante/utils.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/appbar.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({super.key});

  @override
  State<PanierScreen> createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  bool _loading = false;
  bool _couponLoading = false;
  bool _applique = false;
  List<dynamic> orderDetails = [];
  TextEditingController _couponController = TextEditingController();
  dynamic dataComplet = {};
  List foodIds = [];
  List categoryIds = [];
  dynamic reduction;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getBasket();
  }

  getFoodsCategories() async {
    // Parcourir chaque objet dans la liste orderdetails
    dataComplet["orderdetails"].forEach((data) {
      // Ajouter foodid à la liste foodIds
      foodIds.add(data["foodid"]);
      // Ajouter category à la liste categoryIds
      categoryIds.add(data["category"]);
    });
  }

  _getBasket() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await getBasket(prefs.getString("uuid") ?? "");

    if (response["error"] == "0" && response["orderdetails"].isNotEmpty) {
      setState(() {
        dataComplet = response;
        orderDetails = reformatOrderDetails(response["orderdetails"])
            .map((food) => FoodItem(
            name: food["food"],
            price: double.parse(food["foodprice"]).toInt(),
            id: food["foodid"],
            image: food["image"],
            count: food["count"],
            countExtras: food["extrascount"],
            desc: food["desc"],
            extras: food["extrasdata"]))
            .toList();
      });
      /* await getFoodsCategories();
      if (dataComplet["order"]["couponName"] != "") {
        var check_response = await checkCoupon(
            dataComplet["order"]["couponName"],
            categoryIds,
            dataComplet["order"]["restaurant"].toString(),
            foodIds,
            dataComplet["order"]["id"].toString());
      } */
      setState(() {
        categoryIds = [];
        foodIds = [];
      });
      //await getFoodsCategories();
    } else if (response["error"] == "1") {
      print("eheeeeeeeeeeeeeeeeeeee");
      setState(() {
        dataComplet = {};
        orderDetails = [];
      });
      print("dataComplet--------------------");
      print(dataComplet);
    } else {
      Fluttertoast.showToast(msg: "Erreur verifiez votre connexion");
    }
    print("--------------------------------orderDetail");
    print(response["orderdetails"]);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        titleText: 'Panier',
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                orderDetails.isNotEmpty
                    ? Column(
                  children: [
                    Column(
                      children: orderDetails.map((foodItem) {
                        return Stack(
                          children: [
                            Card(
                              margin: EdgeInsets.all(16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    // Image carrée à gauche
                                    Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              '$serverImages${foodItem.image}'), // Remplacez par le chemin de votre image
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.0),
                                    // Textes au milieu en 3 colonnes
                                    Expanded(child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  foodItem.name,
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                  sliceString(foodItem.desc, 16),
                                                  style: TextStyle(fontSize: 14.0),
                                                ),
                                                SizedBox(height: 2.0),
                                                Text(
                                                  '${foodItem.totalPrice} F',
                                                  style: TextStyle(fontSize: 16.0, color: primaryColor),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                              ],
                                            )),

                                            Container(
                                              width: 100,
                                              height: 40,
                                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: greyScale60Color,
                                                  width: 1.0,
                                                ),
                                                color: whiteColor,
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        foodItem.decrementCount();
                                                        setState(() {});
                                                      },
                                                      child: Icon(Icons.remove),
                                                    ),
                                                    Text(
                                                      '${foodItem.count}',
                                                      style: text16GrayScale100,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        foodItem.incrementCount();
                                                        setState(() {});
                                                      },
                                                      child: Icon(Icons.add),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (foodItem.extras.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Extras:',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Column(
                                                children: foodItem.extras
                                                    .map<Widget>((extra) {
                                                  return Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(extra[
                                                          "extras"])),
                                                      SizedBox(
                                                        width: 5,
                                                      ),

                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          "${extra["extrasprice"].toString()}F"),
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          )
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16.0,
                              right: 16.0,
                              child: GestureDetector(
                                onTap: () async {
                                  // Action à effectuer lorsque l'utilisateur appuie sur la croix
                                  print(foodItem.id);
                                  print(dataComplet["order"]["id"]);
                                  var response = await deleteFromBasket(
                                      foodItem.id,
                                      dataComplet["order"]["id"]);
                                  print(response);
                                  if (response["error"] == "0") {
                                    setState(() {
                                      orderDetails.removeWhere((panierItem) =>
                                      panierItem.id == foodItem.id);
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Plat supprimé du panier");
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "une erreur s'est produite");
                                  }
                                },
                                child: Container(
                                  width: 24.0,
                                  height: 24.0,
                                  child: Icon(
                                    Icons.close,
                                    color: primaryColor,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Stack(
                        children: [
                          !_applique
                              ? TextField(
                            controller: _couponController,
                            decoration: InputDecoration(
                              hintText: 'Code du coupon',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(30.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey),
                                borderRadius:
                                BorderRadius.circular(30.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.blue),
                                borderRadius:
                                BorderRadius.circular(30.0),
                              ),
                            ),
                          )
                              : TextField(
                            controller: TextEditingController(
                                text: dataComplet["order"]
                                ["couponName"]),
                            enabled: false,
                            decoration: InputDecoration(
                              //hintText: 'Code du coupon',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(30.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey),
                                borderRadius:
                                BorderRadius.circular(30.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.blue),
                                borderRadius:
                                BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          !_applique
                              ? Positioned(
                            right: 0.0,
                            child: Container(
                              height: 50.0,
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(30.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                    successColor, // Couleur de fond du bouton
                                  ),
                                  onPressed: () async {
                                    if (_couponLoading == false) {
                                      setState(() {
                                        _couponLoading = true;
                                      });

                                      await getFoodsCategories();
                                      // Action lorsque le bouton est pressé
                                      var response =
                                      await checkCoupon(
                                          _couponController
                                              .text,
                                          categoryIds,
                                          dataComplet["order"]
                                          ["restaurant"]
                                              .toString(),
                                          foodIds,
                                          dataComplet["order"]
                                          ["id"]
                                              .toString());
                                      if (response["error"] ==
                                          "0") {
                                        Fluttertoast.showToast(
                                            msg: "coupon appliqué");
                                        setState(() {
                                          reduction = response;
                                        });
                                        _applique = true;

                                        //_getBasket();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: response["error"]);

                                        //_getBasket();
                                      }
                                      setState(() {
                                        _couponLoading = false;
                                        foodIds = [];
                                        // Ajouter category à la liste categoryIds
                                        categoryIds = [];
                                      });
                                    }
                                  },
                                  child: _couponLoading
                                      ? CircularProgressIndicator()
                                      : Text('Appliquer', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontSize: 14
                                      ),),
                                ),
                              ),
                            ),
                          )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          // Action lorsque le bouton "Paiement" est pressé
                          print(orderDetails);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommandeScreen(
                                    orderDetails: orderDetails,
                                    dataComplet: dataComplet,
                                    lat: double.parse(
                                        prefs.getString("myLatitude") ??
                                            "0.0"),
                                    lng: double.parse(
                                        prefs.getString("myLongitude") ??
                                            "0.0"),
                                    reduction: reduction)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor, // Couleur de fond du bouton
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text('Paiement',
                              style: Theme.of(context).textTheme.titleSmall),
                        ),
                      ),
                    )
                  ],
                )
                    : !_loading ?
                Container(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: fixPadding * 3),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/favorie/smile.gif"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: fixPadding),
                        Text(
                          "No Order",
                          textAlign: TextAlign.center,
                          style: text24GreyScale100,
                        ),
                        SizedBox(height: fixPadding),
                        Text(
                          "Sorry, you have no orders in your cart, please add your order to your cart.",
                          textAlign: TextAlign.center,
                          style: text20GreyScale700,
                        )
                      ],
                    ),
                  ),
                ) : Container()
              ],
            ),
          ),
          _loading
              ? LoadingWidget()
              : Container(),
        ],
      )
    );
  }
}

class FoodItem {
  String name;
  int price;
  int count = 1; // Initial count
  int countExtras = 1; // Initial count
  int id;
  String image;
  String desc;
  List<dynamic> extras;

  FoodItem(
      {required this.name,
        required this.price,
        required this.id,
        required this.image,
        required this.count,
        required this.countExtras,
        required this.desc,
        required this.extras});

  void incrementCount() {
    count++;
    for (var extra in extras) {
      extra["extrascount"] += 1;
    }
  }

  void decrementCount() {
    if (count > 1) {
      count--;
      for (var extra in extras) {
        extra["extrascount"] -= 1;
      }
    }
  }

  Map<String, dynamic> tostring() {
    return {
      "name": name,
      "price": price,
      "id": id,
      "image": image,
      "count": count,
      "extras": extras
    };
  }

  //int get totalPrice => price * count;
  int get totalPrice {
    int total = price * count;

    // Ajouter le coût des extras au total
    for (var extra in extras) {
      total +=
          (double.parse(extra["extrasprice"]) * extra["extrascount"]).toInt();
    }

    return total;
  }
}

List<Map<String, dynamic>> reformatOrderDetails(List<dynamic> orderDetails) {
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
        reorganizedMap[foodId] = item;
        reorganizedMap[foodId]!['extrasdata'] =
        []; // Ajouter extrasdata avec une liste vide
      }
    }
  }

  List<Map<String, dynamic>> reorganizedList = reorganizedMap.values.toList();

  return reorganizedList;
}