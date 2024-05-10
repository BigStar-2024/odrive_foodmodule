import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/components/loading.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/home/home.dart';
import 'package:odrive/pages/restaurant/restaurant.dart';
import 'package:odrive/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/appbar.dart';

class FoodScreen extends StatefulWidget {
  final int id_food;
  final dynamic data;
  final String taxe;
  const FoodScreen(
      {super.key,
      required this.id_food,
      required this.taxe,
      required this.data});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  int count = 1;
  String taille = ""; // Indice de la taille sélectionnée
  String price = "0";
  List<dynamic> supplementItems = [];
  TextEditingController _noteEditingController = TextEditingController();
  List<dynamic> basket = [];
  bool _loading = false;
  dynamic basketData = {};
  @override
  void initState() {
    // TODO: implement initState
    print(widget.data);
    print(widget.data["image"]);
    _getBasket();
    setState(() {
      if (double.parse(widget.data["discountprice"]).toInt() == 0) {
        price = widget.data["price"];
      } else {
        price = widget.data["discountprice"];
      }
    });
    super.initState();
    supplementItems = widget.data["extrasdata"]
        .map((supplement) => SupplementItem(
            name: supplement["name"],
            price: double.parse(supplement["price"]).toInt(),
            id: supplement["id"],
            image: supplement["image"]))
        .toList();
  }

  bool isIdInOrderDetails(dynamic data, int id) {
    if (data.containsKey("orderdetails")) {
      List<dynamic> orderDetails = data['orderdetails'];
      for (var detail in orderDetails) {
        if (detail['foodid'] == id) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  _getBasket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString("uuid") ?? "";
    var response = await getBasket(uuid);
    if (response["error"] == "0") {
      setState(() {
        basketData = response;
      });
      print("---------------basketData");
      print(basketData);
    } else if (response["error"] == "1") {
      setState(() {
        basketData = {};
      });
    } else {
      Fluttertoast.showToast(
          msg: "Une erreur c'est produite! Vérifiez votre connexion");
    }
  }

  void incrementCount() {
    setState(() {
      count++;
    });
  }

  void decrementCount() {
    setState(() {
      count--;
    });
  }

  addToCartBtn(size) {
    return GestureDetector(
      onTap: () async {
        print("add to cart");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(prefs.getString("uuid"));
        setState(() {
          _loading = true;
        });
        print(basket);
        bool isIdPresent = isIdInOrderDetails(basketData, widget.data["id"]);

        if (isIdPresent) {
          Fluttertoast.showToast(msg: "Ce plat est déja dans votre panier");
        } else {
          basket.add({
            "id": widget.data["id"].toString(),
            "name": widget.data["name"].toString(),
            "published": widget.data["published"].toString(),
            "restaurant": widget.data["restaurant"].toString(),
            "restaurantName": widget.data["restaurantName"].toString(),
            "image": widget.data["image"].toString(),
            "desc": widget.data["desc"].toString(),
            "ingredients": widget.data["ingredients"].toString(),
            "nutritions": widget.data["nutritionsdata"],
            "extras": supplementItems
                .where((supplementItem) => supplementItem.count > 0)
                .map((supplementItem) => {
                      "name": supplementItem.name,
                      "price": supplementItem.price,
                      "count": supplementItem.count,
                      "id": supplementItem.id,
                      "image": supplementItem.image,
                    })
                .toList(),
            "foodsreviews": widget.data["foodsreviews"],
            "variants": widget.data["variants"],
            "restaurantPhone": widget.data["restaurantPhone"].toString(),
            "restaurantMobilePhone":
                widget.data["restaurantMobilePhone"].toString(),
            "price": double.parse(price),
            "discountprice": double.parse(price),
            "category": widget.data["category"].toString(),
            "fee": widget.data['fee'].toString(),
            "discount": "",
            "rproducts": widget.data['rproducts'],
            "ver": "1",
            "tax": widget.taxe,
            "delivered": false,
            "count": count,
            "imagesFiles": []
          });
          print(basket);

          var response = await addToBasket(
              basket,
              prefs.getString("uuid") ?? "",
              widget.taxe.toString(),
              _noteEditingController.text,
              widget.data["restaurant"].toString(),
              "Cash on Delivery",
              widget.data["fee"].toString(),
              "0",
              "",
              "",
              0.0,
              "0.0",
              "0.0",
              "false",
              "");

          if (response["error"] == "0") {
            Navigator.pop(context, "Plat ajouter au panier");
          } else if (response["error"] == "1") {
            print("innnnnnn");
            Fluttertoast.showToast(
                msg: response["message"],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("ouuuuuuuuuuuut");
            Fluttertoast.showToast(
                msg: "Une erreur est survenu",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }

        setState(() {
          _loading = false;
        });
        //Navigator.pushReplacementNamed(context, '/login');
      },
      child: Container(
        // width: size.width - size.width / 5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: primaryColor),
        child: Center(
          child: Text(
            'Ajouter au panier',
            style: text16White,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        titleText: 'Option',
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    MyHeader(
                      image: widget.data["image"],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.data["name"],
                                style: text24GreyScale100,
                              ),
                              Text(
                                '\F ${double.parse(price).toInt()}',
                                style: text18Primary,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            widget.data["desc"],
                            style: text14GrayScale70,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Quantité",
                                style: text16GrayScale100,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                      greyScale60Color, // Couleur de la bordure
                                      width: 1.0, // Épaisseur de la bordure
                                    ),
                                    color: whiteColor),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (count > 1) {
                                            decrementCount();
                                          }
                                        },
                                        child: Icon(Icons.remove),
                                      ),
                                      Text(
                                        '$count',
                                        style: text16GrayScale100,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          incrementCount();
                                        },
                                        child: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16),

                          if (widget.data["variants"].isNotEmpty)
                            Divider(
                              color: greyScale70Color, // Couleur de la ligne
                              thickness: 1, // Épaisseur de la ligne
                            ),
                          if (widget.data["variants"].isNotEmpty)
                            SizedBox(
                              height: 16,
                            ),
                          if (widget.data["variants"].isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Taille"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    for (var variant in widget.data["variants"])
                                      variant["name"] == "S"
                                          ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              taille = variant["name"];
                                              if (double.parse(
                                                  variant["dprice"])
                                                  .toInt() ==
                                                  0) {
                                                price = variant["price"];
                                              } else {
                                                price = variant["dprice"];
                                              }
                                            });
                                          },
                                          child: _buildSizeCircle(
                                              variant["name"],
                                              isSelected: taille == "S"))
                                          : variant["name"] == "X"
                                          ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            taille = variant["name"];
                                            if (double.parse(
                                                variant["dprice"])
                                                .toInt() ==
                                                0) {
                                              price = variant["price"];
                                            } else {
                                              price = variant["dprice"];
                                            }
                                          });
                                        },
                                        child: _buildSizeCircle(
                                            variant["name"],
                                            isSelected: taille == "X"),
                                      )
                                          : variant["name"] == "XL"
                                          ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            taille = variant["name"];
                                            if (double.parse(variant[
                                            "dprice"])
                                                .toInt() ==
                                                0) {
                                              price =
                                              variant["price"];
                                            } else {
                                              price =
                                              variant["dprice"];
                                            }
                                          });
                                        },
                                        child: _buildSizeCircle(
                                            variant["name"],
                                            isSelected:
                                            taille == "XL"),
                                      )
                                          : Container()
                                    /* Container(
                                  width: size.width / 2,
                                  height: 40,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.data["variants"].length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedSizeIndex == index;
                                          });
                                          print(selectedSizeIndex);
                                          print(index);
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 8.0),
                                          child: _buildSizeCircle(
                                            widget.data["variants"][index],
                                            isSelected: selectedSizeIndex == index,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ), */
                                  ],
                                ),
                              ],
                            ),

                          SizedBox(
                            height: 40,
                          ),
                          if (widget.data["extrasdata"].isNotEmpty)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Supplements"),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Column(
                                  children: supplementItems.map((supplementItem) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 40,
                                              padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        supplementItem
                                                            .decrementCount();
                                                        setState(() {});
                                                      },
                                                      child: Icon(Icons.remove),
                                                    ),
                                                    Text(
                                                      '${supplementItem.count}',
                                                      style: text16GrayScale100,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        supplementItem
                                                            .incrementCount();
                                                        setState(() {});
                                                      },
                                                      child: Icon(Icons.add),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Text(supplementItem.name),
                                            Text("F ${supplementItem.totalPrice}"),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Divider(
                                          color: greyScale70Color,
                                          thickness: 1,
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              Text("Notes"),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextField(

                            controller: _noteEditingController,
                            maxLines: 3, // Pour permettre plusieurs lignes
                            decoration: InputDecoration(
                              labelText:
                              'Avez vous quelque chose à dire au restaurant?',
                              fillColor: greyColor,
                              labelStyle: TextStyle(fontSize: 14, color: greyScale700Color),
                              filled: true,

                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          addToCartBtn(size)
                        ],
                      ),
                    )
                  ],
                ),

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

Widget _buildSizeCircle(dynamic size, {required bool isSelected}) {
  print(size);
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isSelected ? primaryColor : Colors.grey, // Couleur du cercle
      border: Border.all(
        color: Colors.white, // Couleur de la bordure du cercle
        width: 2, // Épaisseur de la bordure
      ),
    ),
    child: Center(
      child: Text(
        size,
        style: TextStyle(
          color: Colors.white, // Couleur du texte
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class SupplementItem {
  String name;
  int price;
  int count = 0; // Initial count
  int id;
  String image;

  SupplementItem(
      {required this.name,
      required this.price,
      required this.id,
      required this.image});

  void incrementCount() {
    count++;
  }

  void decrementCount() {
    if (count > 0) {
      count--;
    }
  }

  int get totalPrice => price * count;
}
