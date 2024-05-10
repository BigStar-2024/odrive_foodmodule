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
import 'package:odrive/components/loading.dart';
import 'package:odrive/constante/const.dart';
import 'package:odrive/pages/address/address.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/categories/categorie_list.dart';
import 'package:odrive/pages/commande/commandes.dart';
import 'package:odrive/pages/favorite/favorite.dart';
import 'package:odrive/pages/food/food.dart';
import 'package:odrive/pages/message/message.dart';
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

import '../../components/bottombar.dart';
import '../../components/buttoncheckout.dart';
import '../../components/eventcard.dart';
import '../../components/foodcard.dart';
import '../../components/imagecard.dart';
import '../../components/imagecarousel.dart';
import '../../components/restaurantcard.dart';
import '../../constante/utils.dart';

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
  // Timer? _timer;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //List<dynamic> notifyData = [];
  addHaversineDistance(List<dynamic> restaurantData, double userLatitude,
      double userLongitude) async {
    for (var restaurant in restaurantData) {
      print(restaurant);
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
    // _timer!.cancel();
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
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, "/myaccount");
                    },
                    child: Column(
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
                  )

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
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => AddressScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
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
              onTap: () {
                Navigator.pushNamed(context, "/language");
              },
            ),
            ListTile(
              title: Text(
                'Mes commandes',
                style: text16GreyScale100,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => CommandesScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Notifications',
                style: text16GreyScale100,
              ),
              onTap: () {
                Navigator.pushNamed(context, "/notification");
              },
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
              onTap: () {
                Navigator.pushNamed(context, "/policy");
              },
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
      backgroundColor:Theme.of(context).backgroundColor,
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
                    height: 16,
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
                          style: ElevatedButton.styleFrom(backgroundColor: MyAppColors.primaryColor),
                          child: Text('Trouver', style: Theme.of(context).textTheme.titleSmall,),
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
              ? LoadingWidget()
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
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(32),
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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SearchScreen(
                            foodData: foodDatas,
                            lat: lat,
                            lng: lng,
                            tax: tax,
                            favorite: favorite),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                        child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                ).then((value) {
                  updateItemCount?.call();
                });
              }
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
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => MessageScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
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






