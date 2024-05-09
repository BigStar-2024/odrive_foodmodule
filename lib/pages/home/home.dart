import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/backend/firebase_notification.dart';
import 'package:odrive/constante/const.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/categories/categorie_list.dart';
import 'package:odrive/pages/commande/commandes.dart';
import 'package:odrive/pages/favorite/favorite.dart';
import 'package:odrive/pages/food/food.dart';
import 'package:odrive/pages/recompense/recompense.dart';
import 'package:odrive/pages/restaurant/map.dart';
import 'package:odrive/pages/restaurant/restaurant.dart';
import 'package:odrive/pages/search/search.dart';
import 'package:odrive/themes/theme.dart';
import 'package:http/http.dart' as http;
import 'package:odrive/widget/haversine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _itemCount = 0;
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _formattedAddress = "";
  String nomComplet = "";
  String email = "";

  Map<String, dynamic> mainData = {};
  Map<String, dynamic> mainDataSecond = {};
  dynamic favoriteData = {};
  List<dynamic> bannerData = [];
  List<dynamic> categories = [];
  List<dynamic> promotions = [];
  List<dynamic> foods = [];
  List<dynamic> restaurantData = [];
  List<dynamic> events = [
    {
      'description': 'Venez découvrir l\'after',
      'restaurant': 'Yoane Fast Food',
      'image': 'event.jpeg'
    },
    {
      'description': 'Venez découvrir l\'after',
      'restaurant': '1000 et 1 délice',
      'image': 'event.jpeg'
    },
    {
      'description': 'Venez découvrir l\'after',
      'restaurant': 'Big burger show',
      'image': 'event.jpeg'
    },
  ];

  bool nearyou = false;
  bool banner = false;
  bool search = false;
  bool categorie = false;
  bool promotion = true;
  bool event = true;
  double totalPanier = 0.0;

  String taxe = "0";
  bool panierExist = false;

  bool _loading = false;
  int _currentIndex = 0;
  Timer? _timer;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //List<dynamic> notifyData = [];
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

  Future<void> getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Obtenir la position actuelle (latitude et longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Appeler l'API Google Geocoding pour obtenir l'adresse à partir des coordonnées
      const apiKey = googleApiKey; // Remplacez par votre clé API Google
      final apiUrl =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final formattedAddress = data['results'][0]['formatted_address'];
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _formattedAddress = formattedAddress;
        });
        prefs.setString("myLatitude", _latitude.toString());
        prefs.setString("myLongitude", _longitude.toString());
        prefs.setString("myAdresse", _formattedAddress.toString());

        print(
            'Coordonnées actuelles : ${position.latitude}, ${position.longitude}');
        print('Adresse actuelle : $formattedAddress');
      } else {
        print(
            'Erreur lors de la récupération de l\'adresse depuis l\'API Google.');
      }
    } catch (e) {
      print('Erreur lors de la récupération de la localisation : $e');
    }
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nomComplet = prefs.getString("userName") ?? "";
      email = prefs.getString("userEmail") ?? "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () async {
      print("-------------------------------FIIIIIIIIIIIIIIIIIIIIII");
      await firebaseInitApp(context);
    });
    getCurrentLocation();
    getUserData();
    _getNotif();
    _getItemCount();
    _getFavorite();
    _getMain();
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

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  _getFavorite() async {
    var response = await getFavorite();
    if (response["error"] == "0") {
      favoriteData = response;
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

  _getNotif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("uuid"));
    var notifyData = await getNotify(prefs.getString("uuid") ?? "");
    print("notifyData------------");
    print(notifyData);
  }

  _getMain() async {
    setState(() {
      _loading = true;
    });
    mainData = await getMain();
    if (mainData["success"] == true) {
      setState(() {
        print("1111111111");
        taxe = mainData["default_tax"];
        if (mainData["settings"]["rows"].contains("nearyou")) {
          print("if 1111111111");
          nearyou = true;
          restaurantData = mainData["restaurants"];
        }
        if (mainData["settings"]["rows"].contains("cat")) {
          print("if 222222222222");
          categories = mainData["categories"];
          categorie = true;
        }

        if (mainData["settings"]["rows"].contains("search")) {
          print("if 44444444");
          search = true;
        }
      });
      await addHaversineDistance(restaurantData, _latitude, _longitude);
      print("restaurantData-----------------");
      print(restaurantData[0]["distance"]);
      mainDataSecond = await getSecondMain();
      if (mainDataSecond["error"].toString() == "0") {
        setState(() {
          if (mainData["settings"]["rows"].contains("banner1")) {
            banner = true;
            bannerData = mainDataSecond['banner1'];
          }
          promotions = mainDataSecond['foods2']
              .where((food) => double.parse(food['discountprice']) != 0.0)
              .toList();
          foods = mainDataSecond['foods2'];
        });
        print(promotions);
      } else {
        print(mainDataSecond);
      }
      _loading = false;
    } else {
      print(mainData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: whiteColor,
        child: ListView(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: blackColor,
                    child: Text(
                      'D',
                      style: text10White,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nomComplet,
                        style: text18GreyScale100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(email, style: text10GreyScale100),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Wallet',
                style: text18GreyScale100,
              ),
              leading: Image.asset("assets/drawer/wallet.png"),
              onTap: () {
                Navigator.pushNamed(context, "/wallet");
              },
            ),
            ListTile(
              title: Text(
                'Mon Adresse',
                style: text18GreyScale100,
              ),
              leading: Image.asset("assets/drawer/location.png"),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Offres/ Promotion',
                style: text18GreyScale100,
              ),
              leading: Image.asset("assets/drawer/discount-shape.png"),
              onTap: () {},
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              title: Text(
                'Langage',
                style: text16GreyScale100,
              ),
              //leading: Icon(Icons.language),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Mes commandes',
                style: text16GreyScale100,
              ),
              //leading: Icon(Icons.history),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CommandesScreen()));
              },
            ),
            ListTile(
              title: Text(
                'Notifications',
                style: text16GreyScale100,
              ),
              //leading: Icon(Icons.notifications),
              onTap: () {},
            ),
            /* ListTile(
              title: Text('Share infomation'),
              leading: Icon(Icons.share),
              onTap: () {},
            ), */
            ListTile(
              title: Text(
                'Termes and politique',
                style: text16GreyScale100,
              ),
              //leading: Icon(Icons.book),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: MyAppBarHome(
          locationName: _formattedAddress,
          itemCount: _itemCount.toString(),
          //timer: _timer!,
          updateItemCounts: () {
            _getItemCount();
            _getBasket();
          }),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (search)
                    SearchField(
                      foodDatas: foods,
                      lat: _latitude,
                      lng: _longitude,
                      tax: taxe,
                      favorite: favoriteData,
                      updateItemCount: () {
                        _getItemCount();
                        _getBasket();
                      },
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  if (banner && bannerData.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offre spécial",
                          textAlign: TextAlign.start,
                          style: text20GrayScale100,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ImageCarousel(
                          bannerData: bannerData,
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (categorie && categories.isNotEmpty)
                    Categories(
                      categorieList: categories,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (promotion && promotions.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Remise garantie!",
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
                          height: 15,
                        ),
                        HorizontalCardList(
                          promotionData: promotions,
                          latitude: _latitude,
                          longitude: _longitude,
                          taxe: taxe,
                          favoriteData: favoriteData,
                          updateItemCount: () {
                            setState(() {
                              _itemCount = _itemCount + 1;
                            });
                            _getBasket();
                          },
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  if (event && events.isNotEmpty)
                    HorizontalEventList(eventData: events),
                  SizedBox(
                    height: 30,
                  ),
                  if (promotion)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Qu'est-ce qui est délicieux par ici ?",
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
                          height: 15,
                        ),
                        HorizontalCardList(
                          promotionData: foods,
                          latitude: _latitude,
                          longitude: _longitude,
                          taxe: taxe,
                          favoriteData: favoriteData,
                          updateItemCount: () {
                            setState(() {
                              _itemCount = _itemCount + 1;
                            });
                            _getBasket();
                          },
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // Afficher l'image
                        /* Image.asset(
                          'image',
                          width: 50,
                          height: 50,
                        ), */
                        Image.asset(
                          "assets/test/restaurant_logo.png",
                          width: 50,
                          height: 50,
                        ),
                        /* Icon(
                          Icons.restaurant_sharp,
                          color: primaryColor,
                          size: 50,
                        ), */
                        // Afficher le texte
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Trouver un restaurant près de moi",
                              style: text16GrayScale100,
                            ),
                          ),
                        ),
                        // Afficher le bouton
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestaurantMap(
                                          restaurants: mainData["restaurants"],
                                          defaultLat: double.parse(
                                              mainData["settings"]
                                                  ['defaultLat']),
                                          defaultLng: double.parse(
                                              mainData["settings"]
                                                  ['defaultLng']),
                                          defaultZoom: double.parse(
                                              mainData["settings"]
                                                      ['defaultZoom'] ??
                                                  "10.0"),
                                        )));
                          },
                          child: Text('Trouver'),
                        ),
                      ],
                    ),
                  ),
                  if (nearyou)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Restaurant proche de chez vous",
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
                          height: 15,
                        ),
                        HorizontalRestaurantCardList(
                          restoData: restaurantData,
                          lat: _latitude,
                          lng: _longitude,
                          taxe: taxe,
                          updateItemCount: () {
                            _getBasket();
                            _getItemCount();
                          },
                        ),
                      ],
                    ),
                ],
              ),
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
      bottomNavigationBar: MyBottomBar(
        updateItemCounts: () {
          _getItemCount();
          _getBasket();
        },
      ),
    );
  }
}

class HorizontalCardList extends StatelessWidget {
  List<dynamic> promotionData;
  double latitude;
  double longitude;
  String taxe;
  dynamic favoriteData;
  // Ajoutez cette ligne pour déclarer le membre updateItemCount
  final VoidCallback? updateItemCount;

  HorizontalCardList(
      {required this.promotionData,
      required this.latitude,
      required this.longitude,
      required this.taxe,
      required this.favoriteData,
      this.updateItemCount});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(promotionData);
    // Exemple de données de plats (à remplacer par vos propres données)

    return Container(
      height: size.height * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: promotionData.length,
        itemBuilder: (context, index) {
          return Container(
            width: size.width * 0.5, // Ajustez la largeur selon vos besoins
            margin: EdgeInsets.symmetric(
                horizontal: 5), // Ajoutez une marge entre les cartes
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: FoodCard(
                name: promotionData[index]['name']!,
                image: promotionData[index]['image']!,
                price: promotionData[index]['price']!,
                discountPrice: promotionData[index]['discountprice']!,
                restaurantName: promotionData[index]['restaurant_name']!,
                restaurantLat: promotionData[index]['lat']!,
                restaurantLng: promotionData[index]['lng']!,
                longitude: longitude,
                latitude: latitude,
                largeur: 250,
                id: promotionData[index]['id']!,
                data: promotionData[index],
                taxe: taxe,
                favoriteData: favoriteData,
                updateItemCount: updateItemCount,
              ),
            ),
          );
        },
      ),
    );
  }
}

class VerticalCardList extends StatelessWidget {
  List<dynamic> promotionData;
  double latitude;
  double longitude;
  String taxe;
  dynamic favoriteData;

  VerticalCardList(
      {required this.promotionData,
      required this.latitude,
      required this.longitude,
      required this.taxe,
      required this.favoriteData});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(promotionData);
    // Exemple de données de plats (à remplacer par vos propres données)

    return Container(
      height: size.height / 3,
      child: ListView.builder(
        //scrollDirection: Axis.vertical,
        itemCount: promotionData.length,
        itemBuilder: (context, index) {
          return Container(
            width: 250, // Ajustez la largeur selon vos besoins
            margin: EdgeInsets.symmetric(
                horizontal: 8), // Ajoutez une marge entre les cartes
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: FoodCard(
                name: promotionData[index]['name']!,
                image: promotionData[index]['image']!,
                price: promotionData[index]['price']!,
                discountPrice: promotionData[index]['discountprice']!,
                restaurantName: promotionData[index]['restaurant_name']!,
                restaurantLat: promotionData[index]['lat']!,
                restaurantLng: promotionData[index]['lng']!,
                longitude: longitude,
                latitude: latitude,
                largeur: 250,
                id: promotionData[index]['id']!,
                data: promotionData,
                taxe: taxe,
                favoriteData: favoriteData,
              ),
            ),
          );
        },
      ),
    );
  }
}

class HorizontalRestaurantCardList extends StatelessWidget {
  List<dynamic> restoData;
  final double lat;
  final double lng;
  final String taxe;
  // Ajoutez cette ligne pour déclarer le membre updateItemCount
  final VoidCallback? updateItemCount;

  HorizontalRestaurantCardList(
      {required this.restoData,
      required this.lat,
      required this.lng,
      required this.taxe,
      this.updateItemCount});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Exemple de données de plats (à remplacer par vos propres données)

    return Container(
      height: size.height / 3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: restoData.length,
        itemBuilder: (context, index) {
          return Container(
            width: 250, // Ajustez la largeur selon vos besoins
            margin: EdgeInsets.symmetric(
                horizontal: 8), // Ajoutez une marge entre les cartes
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: RestaurantCard(
                name: restoData[index]['name']!,
                image: restoData[index]['image']!,
                distance: restoData[index]['distance']!,
                id_restaurant: restoData[index]['id'],
                lat: lat,
                lng: lng,
                taxe: taxe,
                updateItemCount: updateItemCount,
              ),
            ),
          );
        },
      ),
    );
  }
}

/* class FoodCard extends StatefulWidget {
  final String name;
  final String image;
  final String price;
  final String discountPrice;
  final String restaurantName;
  final String restaurantLat;
  final String restaurantLng;
  final double latitude;
  final double longitude;
  final double largeur;
  final int id;
  final dynamic data;
  final String taxe;
  final dynamic favoriteData;
  // Ajoutez cette ligne pour déclarer le membre updateItemCount
  final VoidCallback? updateItemCount;

  FoodCard(
      {required this.name,
      required this.image,
      required this.price,
      required this.discountPrice,
      required this.restaurantName,
      required this.restaurantLat,
      required this.restaurantLng,
      required this.latitude,
      required this.longitude,
      required this.largeur,
      required this.id,
      required this.data,
      required this.taxe,
      required this.favoriteData,
      this.updateItemCount});
  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isFavorite = false;

  bool isFoodIdExist(idToCheck, favoriteData) {
    print(favoriteData);
    // Obtenez la liste des aliments dans favoriteData
    if (favoriteData.containsKey("food")) {
      List<dynamic> foodList = favoriteData["food"];

      // Parcourez la liste des aliments
      for (var food in foodList) {
        // Vérifiez si l'ID correspond
        if (food["id"] == idToCheck) {
          setState(() {
            isFavorite = true;
          });
          return true; // L'ID correspond à un aliment existant
        }
      }
    }

    return false; // Aucun aliment n'a été trouvé avec cet ID
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Calcul du pourcentage d'escompte
    double discountPercentage =
        ((double.parse(widget.price) - double.parse(widget.discountPrice)) /
                double.parse(widget.price)) *
            100;
    double distance = Haversine.calculateDistance(
        double.parse(widget.restaurantLat),
        double.parse(widget.restaurantLng),
        widget.latitude,
        widget.longitude);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FoodScreen(
                    id_food: widget.id, taxe: widget.taxe, data: widget.data)),
          ).then((toastMessage) {
            widget.updateItemCount?.call();

            print(
                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            print(toastMessage);
            setState(() {});
            if (toastMessage == "Plat ajouter au panier") {
              Fluttertoast.showToast(
                msg: toastMessage,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        },
        child: Card(
          margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Image.network(
                      '$serverImages${widget.image}',
                      width: widget.largeur,
                      height: (size.height * 0.2) * 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: (size.height * 0.2) * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: text11GreyScale900,
                          ),
                          //SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${distance.toStringAsFixed(0)} km |',
                                    style: text10GrayScale70,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  Text(
                                    '1.8 (1.2k)',
                                    style: text10GrayScale70,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  //SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () async {
                                      // Action à effectuer lorsqu'on clique sur l'icône de cœur
                                      setState(() {
                                        isFavorite =
                                            !isFavorite; // Inverse l'état du favori
                                      });
                                      if (isFavorite) {
                                        var response =
                                            await addFavorite(widget.id);
                                        if (response["error"] == "0") {
                                          Fluttertoast.showToast(
                                              msg: "Plat ajouté au favorie");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Une erreur s'est produite");
                                        }
                                      } else {
                                        var response =
                                            await deleteFavorite(widget.id);
                                        if (response["error"] == "0") {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Plat supprimé des favories");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Une erreur s'est produite");
                                        }
                                      }
                                    },
                                    child: Icon(
                                      isFoodIdExist(
                                              widget.id, widget.favoriteData)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          double.parse(widget.discountPrice).toInt() != 0
                              ? Flexible(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\F${double.parse(widget.price).toInt()}', // Prix barré
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                            fontSize: 11),
                                      ),
                                      SizedBox(width: 4),
                                      Container(
                                        //padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '\F${double.parse(widget.discountPrice).toInt()}', // Prix réduit
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        //padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '\F${double.parse(widget.price).toInt()}', // Prix réduit
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              double.parse(widget.discountPrice).toInt() != 0
                  ? Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${discountPercentage.toStringAsFixed(0)}% de réduction',
                          style: text11White,
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
} */

class FoodCard extends StatefulWidget {
  final String name;
  final String image;
  final String price;
  final String discountPrice;
  final String restaurantName;
  final String restaurantLat;
  final String restaurantLng;
  final double latitude;
  final double longitude;
  final double largeur;
  final int id;
  final dynamic data;
  final String taxe;
  final dynamic favoriteData;
  // Ajoutez cette ligne pour déclarer le membre updateItemCount
  final VoidCallback? updateItemCount;

  FoodCard(
      {required this.name,
      required this.image,
      required this.price,
      required this.discountPrice,
      required this.restaurantName,
      required this.restaurantLat,
      required this.restaurantLng,
      required this.latitude,
      required this.longitude,
      required this.largeur,
      required this.id,
      required this.data,
      required this.taxe,
      required this.favoriteData,
      this.updateItemCount});
  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isFavorite = false;

  bool isFoodIdExist(idToCheck, favoriteData) {
    print(favoriteData);
    // Obtenez la liste des aliments dans favoriteData
    if (favoriteData.containsKey("food")) {
      List<dynamic> foodList = favoriteData["food"];

      // Parcourez la liste des aliments
      for (var food in foodList) {
        // Vérifiez si l'ID correspond
        if (food["id"] == idToCheck) {
          setState(() {
            isFavorite = true;
          });
          return true; // L'ID correspond à un aliment existant
        }
      }
    }

    return false; // Aucun aliment n'a été trouvé avec cet ID
  }

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size; // Calcul du pourcentage d'escompte
    double discountPercentage =
        ((double.parse(widget.price) - double.parse(widget.discountPrice)) /
                double.parse(widget.price)) *
            100;
    double distance = Haversine.calculateDistance(
        double.parse(widget.restaurantLat),
        double.parse(widget.restaurantLng),
        widget.latitude,
        widget.longitude);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FoodScreen(
                    id_food: widget.id, taxe: widget.taxe, data: widget.data)),
          ).then((toastMessage) {
            widget.updateItemCount?.call();

            print(
                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            print(toastMessage);
            setState(() {});
            if (toastMessage == "Plat ajouter au panier") {
              Fluttertoast.showToast(
                msg: toastMessage,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        },
        child: Card(
          margin: EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Image.network(
                      '$serverImages${widget.image}',
                      width: widget.largeur,
                      height: (size.height * 0.2) * 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: text18GreyScale900,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${distance.toStringAsFixed(0)} km |',
                                  style: text14GrayScale70,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                Text(
                                  '1.8 (1.2k)',
                                  style: text14GrayScale70,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () async {
                                    // Action à effectuer lorsqu'on clique sur l'icône de cœur
                                    setState(() {
                                      isFavorite =
                                          !isFavorite; // Inverse l'état du favori
                                    });
                                    if (isFavorite) {
                                      var response =
                                          await addFavorite(widget.id);
                                      if (response["error"] == "0") {
                                        Fluttertoast.showToast(
                                            msg: "Plat ajouté au favorie");
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Une erreur s'est produite");
                                      }
                                    } else {
                                      var response =
                                          await deleteFavorite(widget.id);
                                      if (response["error"] == "0") {
                                        Fluttertoast.showToast(
                                            msg: "Plat supprimé des favories");
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Une erreur s'est produite");
                                      }
                                    }
                                  },
                                  child: Icon(
                                    isFoodIdExist(
                                            widget.id, widget.favoriteData)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: primaryColor,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        /*  SizedBox(
                          height: 10,
                        ), */
                        double.parse(widget.discountPrice).toInt() != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\F${double.parse(widget.price).toInt()}', // Prix barré
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '\F${double.parse(widget.discountPrice).toInt()}', // Prix réduit
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '\F${double.parse(widget.price).toInt()}', // Prix réduit
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ],
              ),
              double.parse(widget.discountPrice).toInt() != 0
                  ? Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${discountPercentage.toStringAsFixed(0)}% de réduction',
                          style: text16White,
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

class RestaurantCard extends StatelessWidget {
  final String name;
  final String image;
  final double distance;
  final int id_restaurant;
  final double lat;
  final double lng;
  final String taxe;
  final VoidCallback? updateItemCount;

  RestaurantCard(
      {required this.name,
      required this.image,
      required this.distance,
      required this.id_restaurant,
      required this.lat,
      required this.lng,
      required this.taxe,
      this.updateItemCount});

  @override
  Widget build(BuildContext context) {
    // Calcul du pourcentage d'escompte

    return GestureDetector(
      onTap: () {
        print("<<<<<<<<<object>>>>>>>>>");
        print(id_restaurant);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RestaurantScreen(
                  id_restaurant: id_restaurant,
                  latitude: lat,
                  longitude: lng,
                  taxe: taxe)),
        ).then((value) {
          updateItemCount?.call();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        child: Card(
          margin: EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Image.network(
                      '$serverImages$image',
                      width: 250,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: text18GreyScale900,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${distance.toStringAsFixed(0)} km |',
                                  style: text14GrayScale70,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalEventList extends StatelessWidget {
  List<dynamic> eventData;
  HorizontalEventList({required this.eventData});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Exemple de données de plats (à remplacer par vos propres données)

    return Container(
      height: size.height / 4,
      //width: size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: eventData.length,
        itemBuilder: (context, index) {
          return Container(
            width: size.width, // Ajustez la largeur selon vos besoins
            height: size.height / 4,
            margin: EdgeInsets.symmetric(
                horizontal: 8), // Ajoutez une marge entre les cartes
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8.0), bottom: Radius.circular(8.0)),
              child: EventCard(
                description: eventData[index]['description']!,
                image: eventData[index]['image']!,
                restaurant: eventData[index]['restaurant']!,
              ),
            ),
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String description;
  final String image;
  final String restaurant;

  EventCard({
    required this.description,
    required this.image,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Calcul du pourcentage d'escompte

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0), bottom: Radius.circular(8.0)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.0), bottom: Radius.circular(8.0)),
                child: Image.asset(
                  'assets/test/$image',
                  width: size.width,
                  height: size.height / 4,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  /* decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ), */
                  child: Text(
                    '${description}',
                    style: TextStyle(
                        fontSize: 25, color: whiteColor, fontFamily: "Abel"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  /* decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ), */
                  child: Text(
                    '${restaurant}',
                    style: TextStyle(
                        fontSize: 25, color: whiteColor, fontFamily: "Abel"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: whiteColor),
                  child: Center(
                    child: Text(
                      'Découvrir',
                      style: text16Primary,
                    ),
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

class MyBottomBar extends StatefulWidget {
  final VoidCallback? updateItemCounts;
  MyBottomBar({this.updateItemCounts});
  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _selectedIndex = 0;
  final PointsUpdateNotifier pointsUpdateNotifier = PointsUpdateNotifier();

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
                            Container(
                              width: 24,
                              height: 24,
                              child: Stack(children: [
                                //Yoane
                                Image.asset(
                                  "assets/home/Home1.png",
                                  height: 24,
                                  width: 24,
                                  color: primaryColor,
                                )
                              ]),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecompenseScreen(
                                  notifier: pointsUpdateNotifier,
                                ))).then((value) {
                      widget.updateItemCounts?.call();
                    });
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
                                    "assets/home/gift.svg",
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final List<dynamic> foodDatas; // Ajoutez cette ligne
  double lat; // Ajoutez cette ligne
  double lng; // Ajoutez cette ligne
  String tax; // Ajoutez cette ligne
  dynamic favorite;
  final VoidCallback? updateItemCount;

  SearchField(
      {required this.foodDatas,
      required this.lat,
      required this.lng,
      required this.tax,
      this.favorite,
      this.updateItemCount}); // Ajoutez ce constructeur

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset("assets/home/search.png"),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'De quoi avez vous besoin?',
                border: InputBorder.none,
              ),
              style: text14GreyScale20,
              readOnly: true,
              onTap: () {
                print("search");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchScreen(
                            foodData: foodDatas,
                            lat: lat,
                            lng: lng,
                            tax: tax,
                            favorite: favorite))).then((value) {
                  updateItemCount?.call();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String locationName;
  final String itemCount;
  //final Timer timer;
  final VoidCallback? updateItemCounts;

  MyAppBarHome(
      {required this.locationName,
      required this.itemCount,
      //required this.timer,
      this.updateItemCounts});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: blackColor,
              size: 35,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      centerTitle: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {},
              child: Text(
                shortenLocationName(locationName, 15),
                style: text20GreyScale700,
              )),
          Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF66707A),
            size: 20,
          )
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Action à effectuer lorsqu'on clique sur l'image de notification
          },
          child: Image.asset(
            'assets/home/notification.png', // Remplacez par le chemin de votre image de notification
            width: 30,
            height: 30,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            // Action à effectuer lorsqu'on clique sur l'image du panier
            //timer.cancel();
            Navigator.pushNamed(context, '/panier').then((value) {
              updateItemCounts?.call();
            });
          },
          child: Badge(
            position: BadgePosition.topEnd(top: 0, end: -2),
            badgeColor: primaryColor,
            badgeContent: Text(
              itemCount,
              style: text10White,
            ),
            child: Image.asset(
              'assets/home/panier.png', // Remplacez par le chemin de votre image de panier
              width: 30,
              height: 30,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<dynamic> bannerData;

  ImageCarousel({required this.bannerData});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final CarouselController _carouselController = CarouselController();
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _carouselController.jumpToPage(_pageController.page!.round());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 19 / 7,
            enlargeCenterPage: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.bannerData.map((data) {
            String imageUrl = data['image'] ?? '';
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.network(
                    "$serverImages$imageUrl",
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
          carouselController: _carouselController,
        ),
        SizedBox(height: 10),
        /* Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.bannerData.length,
            effect: ExpandingDotsEffect(
              spacing: 8.0,
              radius: 8.0,
              dotWidth: 16.0,
              dotHeight: 16.0,
              dotColor: Colors.black26,
              activeDotColor: Colors.black,
            ),
          ),
        ), */
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class Categories extends StatelessWidget {
  final List<dynamic> categorieList;

  Categories({required this.categorieList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Alignez à gauche
            children: [
              for (int i = 0; i < 4; i++)
                if (i < categorieList.length)
                  ImageCard(
                    name: categorieList[i]['name'],
                    image: categorieList[i]['image'],
                    fromAsset: false,
                  ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Alignez à gauche
            children: [
              for (int i = 4; i < 7; i++)
                if (i < categorieList.length)
                  ImageCard(
                    name: categorieList[i]['name'],
                    image: categorieList[i]['image'],
                    fromAsset: false,
                  ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategorieListScreen(
                                categorieList: categorieList,
                              )));
                },
                child: ImageCard(
                    name: "Autre",
                    image: "assets/home/autre.png",
                    fromAsset: true),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String name;
  final String image;
  final bool fromAsset;

  ImageCard({required this.name, required this.image, required this.fromAsset});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        !fromAsset
            ? Image.network(
                "$serverImages$image",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : Image.asset(
                image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

String shortenLocationName(String locationName, int maxLength) {
  if (locationName.length <= maxLength) {
    return locationName;
  } else {
    return locationName.substring(0, maxLength - 3) + '...';
  }
}

class ButtonCheckout extends StatelessWidget {
  final double montant;
  final int itemcount;
  final VoidCallback? updateItemCounts;
  ButtonCheckout(
      {required this.montant, required this.itemcount, this.updateItemCounts});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/panier').then((value) {
          updateItemCounts?.call();
        });
      },
      child: Column(
        children: [
          Container(
            width: 327,
            height: 48,
            padding: const EdgeInsets.only(left: 4, right: 12),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Color(0xFF03443C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 30,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    //height: 42,
                    child: Row(
                      /* mainAxisSize: MainAxisSize.min,
                      m
                      crossAxisAlignment: CrossAxisAlignment.center, */
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(4),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'x $itemcount',
                                      textAlign: TextAlign.center,
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
                              const SizedBox(width: 12),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '\F $montant',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFFEFEFE),
                                        fontSize: 16,
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
                        const SizedBox(width: 8),
                        Container(
                          width: 78.35,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Finaliser',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFFEFEFE),
                                        fontSize: 16,
                                        fontFamily: 'Abel',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

class AllCategories extends StatelessWidget {
  final List<dynamic> categorieList;

  AllCategories({required this.categorieList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Alignez à gauche
            children: [
              for (int i = 0; i < 4; i++)
                if (i < categorieList.length)
                  ImageCard(
                    name: categorieList[i]['name'],
                    image: categorieList[i]['image'],
                    fromAsset: false,
                  ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Alignez à gauche
            children: [
              for (int i = 4; i < 7; i++)
                if (i < categorieList.length)
                  ImageCard(
                    name: categorieList[i]['name'],
                    image: categorieList[i]['image'],
                    fromAsset: false,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
