import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/commande/commandes.dart';
import 'package:odrive/pages/home/home.dart';
import 'package:odrive/themes/theme.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  dynamic favoriteData;
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    _getFavorite();
    super.initState();
  }

  _getFavorite() async {
    setState(() {
      _loading = true;
    });
    var response = await getFavorite();
    if (response["error"] == "0") {
      setState(() {
        favoriteData = response;
      });
      print(favoriteData);
      print("favoriteData-----------------------------");
    } else {
      Fluttertoast.showToast(msg: "Une erreur s'est produite");
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(titleText: "Favorie"),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                    children: favoriteData != null &&
                            favoriteData.containsKey("food")
                        ? favoriteData["food"].isNotEmpty
                            ? favoriteData["food"].map<Widget>((foodItem) {
                                return Card(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 92,
                                        height: 92,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "$serverImages${foodItem["image"]}"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          //height: double.infinity,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      //width: 150,
                                                      //height: 49,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4, left: 4),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            foodItem["name"],
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF171725),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Abel',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            foodItem[
                                                                "restaurantName"],
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF616161),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Abel',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          favoriteData["food"]
                                                              .removeWhere(
                                                                  (favoriteItem) =>
                                                                      favoriteItem[
                                                                          "id"] ==
                                                                      foodItem[
                                                                          "id"]);
                                                        });
                                                        print(foodItem["id"]);
                                                        print(
                                                            "idddddddddddddd");
                                                        var response =
                                                            await deleteFavorite(
                                                                foodItem["id"]);
                                                        if (response["error"] ==
                                                            "0") {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "plat supprimé des favories");
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Une erreur s'est produite");
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 24,
                                                        height: 24,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: 24,
                                                              height: 24,
                                                              child: Stack(
                                                                  children: [
                                                                    //YOANE
                                                                    SvgPicture
                                                                        .asset(
                                                                            "assets/favorie/heart.svg")
                                                                  ]),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Container(
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 12,
                                                      height: 12,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 1,
                                                          vertical: 1.25),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                              "assets/favorie/star.svg")
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '4.8',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF66707A),
                                                        fontSize: 14,
                                                        fontFamily: 'Abel',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '(1.2k)',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF78828A),
                                                        fontSize: 14,
                                                        fontFamily: 'Abel',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'I',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF66707A),
                                                        fontSize: 14,
                                                        fontFamily: 'Abel',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '1,5 km',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF66707A),
                                                        fontSize: 14,
                                                        fontFamily: 'Abel',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Transform(
                                        transform: Matrix4.identity()
                                          ..translate(0.0, 0.0)
                                          ..rotateZ(3.14),
                                        child: Container(
                                          width: 33,
                                          height: 92,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //Icon(Icons.arrow_forward_ios)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList()
                            : [
                                _loading
                                    ? Text("")
                                    : Container(
                                        width: 327,
                                        height: 216,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
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
                                            const SizedBox(height: 12),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                'Aucun Favorie',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF03443C),
                                                  fontSize: 24,
                                                  fontFamily: 'Abel',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                'Désolé votre liste de favorie est vide',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF78828A),
                                                  fontSize: 18,
                                                  fontFamily: 'Abel',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                              ]
                        : [Text("")]),
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
          ],
        ),
      ),
      bottomNavigationBar: MyBottomBarFavorite(),
    );
  }
}

class MyBottomBarFavorite extends StatefulWidget {
  @override
  _MyBottomBarFavoriteState createState() => _MyBottomBarFavoriteState();
}

class _MyBottomBarFavoriteState extends State<MyBottomBarFavorite> {
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
                  onTap: () {},
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
                                    "assets/favorie/heart.svg",
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
