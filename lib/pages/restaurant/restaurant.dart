import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/home/home.dart';
import 'package:odrive/pages/restaurant/restaurant_information.dart';
import 'package:odrive/pages/restaurant/reviews.dart';
import 'package:odrive/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantScreen extends StatefulWidget {
  final int id_restaurant;
  final double latitude;
  final double longitude;
  final String taxe;

  const RestaurantScreen(
      {super.key,
      required this.id_restaurant,
      required this.latitude,
      required this.longitude,
      required this.taxe});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  bool _loading = true;
  Map<String, dynamic> restaurantData = {};
  List<dynamic> foods = [];
  List<dynamic> foodsFiltre = [];
  int selectedCategory = 0;
  String categorieName = "Pour toi";
  String SelectedName = "";

  dynamic favoriteData = {};
  bool panierExist = false;
  double totalPanier = 0.0;
  int _itemCount = 0;
  @override
  void initState() {
    _getRestaurant(widget.id_restaurant);
    _getFavorite();
    // TODO: implement initState
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

  _getRestaurant(id_restaurant) async {
    var restaurant_call = await getRestaurant(id_restaurant.toString());
    setState(() {
      restaurantData = restaurant_call;
      for (var food in restaurantData["foods"]) {
        food["restaurant_name"] = restaurantData["restaurant"]["name"];
        food["lat"] = restaurantData["restaurant"]["lat"];
        food["lng"] = restaurantData["restaurant"]["lng"];
      }
      foods = restaurantData["foods"];
      foodsFiltre = restaurantData["foods"];
      _loading = false;
    });
  }

  List<dynamic> getFoodsByCategoryId(int categoryId, List<dynamic> foods) {
    return foods.where((food) => food["category"] == categoryId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: !_loading
                  ? Column(
                      children: [
                        Stack(children: [
                          Container(
                            height: size.height / 4 + 35,
                          ),
                          MyHeader(
                            image: restaurantData["restaurant"]["image"],
                          ),
                          Positioned(
                            bottom: -4,
                            left: 20,
                            child: CircleAvatar(
                              radius: 59,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: NetworkImage(
                                    "$serverImages${restaurantData["restaurant"]["image"]}"),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 20,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ]),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15.0, left: 25.0, right: 25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    restaurantData["restaurant"]["name"],
                                    style: text32GrayScale100,
                                  ),
                                  Icon(
                                    Icons.favorite_border,
                                    color: greyScale70Color,
                                    size: 35,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        restaurantData["restaurant"]["address"],
                                        style: text14GrayScale100,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Ouvert",
                                        style: TextStyle(color: Colors.green),
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RestaurantInformationScreen(
                                                    restaurant: restaurantData[
                                                        "restaurant"],
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.info_outline,
                                      color: blackColor,
                                      size: 35,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 30,
                                      ),
                                      Text("4.8 (1.2k)"),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset("assets/home/panier.png"),
                                      Text("99+ commandes")
                                    ],
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Commentaire",
                                      style: TextStyle(
                                        decoration: TextDecoration
                                            .underline, // Couleur du soulignement
                                        decorationThickness:
                                            2.0, // Épaisseur du soulignement
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewsScreen(
                                                    idRestaurant:
                                                        restaurantData[
                                                            "restaurant"]["id"],
                                                  )));
                                    },
                                  )
                                ],
                              ),
                              HorizontalCategoryList(
                                categoryData: restaurantData["categories"],
                                selectName: SelectedName,
                                onCategorySelected: (category, name) {
                                  setState(() {
                                    selectedCategory = category;
                                    foodsFiltre = getFoodsByCategoryId(
                                        selectedCategory, foods);
                                    categorieName = name;
                                    SelectedName = name;
                                  });
                                  print("selectedCategory-------------------");
                                  print(selectedCategory);
                                  print(foods);
                                },
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "$categorieName",
                                    textAlign: TextAlign.start,
                                    style: text20GrayScale100,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_forward_ios),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              HorizontalCardList(
                                promotionData: foodsFiltre,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                                taxe: widget.taxe,
                                favoriteData: favoriteData,
                                updateItemCount: () {
                                  _getItemCount();
                                  _getBasket();
                                },
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tous nos plats",
                                    textAlign: TextAlign.start,
                                    style: text20GrayScale100,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              buildCardColumn(
                                  foodsFiltre.reversed.toList(),
                                  widget.latitude,
                                  widget.longitude,
                                  size.width,
                                  widget.taxe,
                                  favoriteData, () {
                                _getItemCount();
                                _getBasket();
                              })

                              /* VerticalCardList(
                                promotionData: foodsFiltre.reversed.toList(),
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                              ), */
                            ],
                          ),
                        )
                      ],
                    )
                  : Container(),
            ),
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
      bottomNavigationBar: MyBottomBar(),
    );
  }
}

class MyHeader extends StatelessWidget {
  final String image;
  MyHeader({required this.image});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 4,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("$serverImages$image"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class HorizontalCategoryList extends StatelessWidget {
  List<dynamic> categoryData;
  final Function(int, String)? onCategorySelected;
  String selectName;

  HorizontalCategoryList(
      {required this.categoryData,
      this.onCategorySelected,
      required this.selectName});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryData.length,
        itemBuilder: (context, index) {
          return Row(children: [
            GestureDetector(
              onTap: () {
                if (onCategorySelected != null) {
                  onCategorySelected!(
                      categoryData[index]["id"], categoryData[index]["name"]);
                }
              },
              child: categoryBtn(categoryData[index]["name"], selectName),
            ),
            SizedBox(width: 15),
          ] // Espaceur entre les boutons
              );
        },
      ),
    );
  }
}

categoryBtn(String categoryName, String selectName) {
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
          Text(
            categoryName,
            style: categoryName == selectName ? text16White : text16neutral90,
          ),
        ],
      ),
    ),
  );
}

Widget buildCardColumn(List<dynamic> dataList, double lat, double lng, largeur,
    String taxe, favoriteData, VoidCallback? updateItemCount) {
  return Column(
    children: dataList
        .map((data) => buildCard(
            data, lat, lng, largeur, taxe, favoriteData, updateItemCount))
        .toList(),
  );
}

Widget buildCard(dynamic data, double lat, double lng, largeur, taxe,
    favoriteData, updateItemCount) {
  return Container(
    //width: 250, // Ajustez la largeur selon vos besoins
    // Ajoutez une marge entre les cartes
    child: ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      child: FoodCard(
        name: data['name']!,
        image: data['image']!,
        price: data['price']!,
        discountPrice: data['discountprice']!,
        restaurantName: data['restaurant_name'] ?? "",
        restaurantLat: data['lat'] ?? "0.0",
        restaurantLng: data['lng'] ?? "0.0",
        longitude: lng,
        latitude: lat,
        largeur: largeur,
        id: data['id']!,
        data: data,
        taxe: taxe,
        favoriteData: favoriteData,
        updateItemCount: updateItemCount,
      ),
    ),
  );
}
