import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/home/home.dart';
import 'package:odrive/pages/message/message.dart';
import 'package:odrive/pages/recompense/recompense.dart';
import 'package:odrive/pages/restaurant/restaurant.dart';
import 'package:odrive/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../components/buttoncheckout.dart';

class SearchScreen extends StatefulWidget {
  final List<dynamic> foodData;
  double lat; // Ajoutez cette ligne
  double lng; // Ajoutez cette ligne
  String tax; // Ajoutez cette ligne
  dynamic favorite;

  SearchScreen(
      {required this.foodData,
        required this.lat,
        required this.lng,
        required this.tax,
        this.favorite});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResult = [];
  List<dynamic> filtre = [
    {"id": 1, "name": "Filtrer", "icon": "assets/search/filter.svg"},
    {"id": 2, "name": "Trier", "icon": "assets/search/trier.svg"},
    {"id": 3, "name": "Promotions", "icon": ""}
  ];
  bool dataFind = false;
  bool firstOpen = true;
  TextEditingController searchController = TextEditingController();
  SfRangeValues _values = SfRangeValues(500.0, 30000.0);

  bool panierExist = false;
  double totalPanier = 0.0;
  int _itemCount = 0;
  List<dynamic> suggestions = [];
  String suggestionSelect = '';
  String distanceSelect = '';
  String selectedOption = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      searchResult = widget.foodData;
    });
    _getItemCount();
    _getBasket();
    _getSuggestion();
  }

  _getSuggestion() async {
    var response = await searchSuggestion();
    print("Suggestion-------------------");
    print(response);
    if (response['error'] == '0') {
      setState(() {
        suggestions = response['suggestion'];
      });
    }
  }

  void resetState() {
    setState(() {
      // Réinitialisez chaque variable d'état à sa valeur initiale ici
      // Par exemple :
      // myVariable = initialValue;
      suggestionSelect = '';
      distanceSelect = '';
    });
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

  void _showFilterModal(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            void Function(void Function()) setState) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Stack(
              children: [
                Positioned(
                    top: 8,
                    left: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                    )),
                Column(
                  children: [
                    Container(
                      width: size.width,
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'Filter',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 20,
                              fontFamily: 'Abel',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Intervalle de prix ',
                                  style: TextStyle(
                                    color: Color(0xFF171725),
                                    fontSize: 16,
                                    fontFamily: 'Abel',
                                    fontWeight: FontWeight.w400,
                                    height: 0.09,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SfRangeSlider(
                                  min: 500,
                                  max: 30000,
                                  stepSize: 500,
                                  values: _values,
                                  interval: 10000,
                                  showTicks: false,
                                  showLabels: false,
                                  enableTooltip: false,
                                  minorTicksPerInterval: 500,
                                  onChanged: (SfRangeValues values) {
                                    setState(() {
                                      _values = values;
                                      print(values.start);
                                      print(values.end);
                                    });
                                  },
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(_values.start.toString(),
                                          style: TextStyle(color: Colors.red)),
                                      Text(_values.end.toString(),
                                          style: TextStyle(color: Colors.red))
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 140,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        'Suggestion',
                                        style: TextStyle(
                                          color: Color(0xFF171725),
                                          fontSize: 16,
                                          fontFamily: 'Abel',
                                          fontWeight: FontWeight.w400,
                                          height: 0.09,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Wrap(
                                        spacing: 12.0,
                                        runSpacing: 8.0,
                                        children: suggestions.map((
                                            dynamic suggestion) {
                                          return GestureDetector(
                                            onTap: () {
                                              // updateState.call(suggestion);
                                            },
                                            child: Container(
                                              width: 73,
                                              height: 32,
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                              decoration: ShapeDecoration(
                                                color: suggestionSelect !=
                                                    suggestion
                                                    ? Color(0xFFE3E9ED)
                                                    : Color(0xFF332C45),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(12),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  suggestion,
                                                  style: TextStyle(
                                                    color: suggestionSelect !=
                                                        suggestion
                                                        ? Color(0xFF434E58)
                                                        : whiteColor,
                                                    fontSize: 14,
                                                    fontFamily: 'Abel',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        'Distance',
                                        style: TextStyle(
                                          color: Color(0xFF171725),
                                          fontSize: 16,
                                          fontFamily: 'Abel',
                                          fontWeight: FontWeight.w400,
                                          height: 0.09,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        //width: 327,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      distanceSelect = '<5KM';
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 73,
                                                    height: 32,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                    decoration: ShapeDecoration(
                                                      color: distanceSelect ==
                                                          '<5KM'
                                                          ? Color(0xFF332C45)
                                                          : Color(0xFFE3E9ED),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize
                                                          .min,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          '<5KM',
                                                          textAlign: TextAlign
                                                              .right,
                                                          style: TextStyle(
                                                            color:
                                                            distanceSelect ==
                                                                '<5KM'
                                                                ? whiteColor
                                                                : Color(
                                                                0xFF434E58),
                                                            fontSize: 14,
                                                            fontFamily: 'Abel',
                                                            fontWeight: FontWeight
                                                                .w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      distanceSelect =
                                                      '5KM - 10KM';
                                                    });
                                                  },
                                                  child: Container(
                                                    //width: 98,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                    decoration: ShapeDecoration(
                                                      color:
                                                      distanceSelect !=
                                                          '5KM - 10KM'
                                                          ? greyScale30Color
                                                          : secondaryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      //mainAxisSize: MainAxisSize.min,
                                                      /* mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center, */
                                                      children: [
                                                        Text(
                                                          '5KM - 10KM ',
                                                          textAlign: TextAlign
                                                              .right,
                                                          style: TextStyle(
                                                            color: distanceSelect !=
                                                                '5KM - 10KM'
                                                                ? greyScale90Color
                                                                : whiteColor,
                                                            fontSize: 14,
                                                            fontFamily: 'Abel',
                                                            fontWeight: FontWeight
                                                                .w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      distanceSelect = '>10KM';
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 73,
                                                    height: 32,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                    decoration: ShapeDecoration(
                                                      color: distanceSelect !=
                                                          '>10KM'
                                                          ? greyScale30Color
                                                          : secondaryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize
                                                          .min,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          '>10KM',
                                                          textAlign: TextAlign
                                                              .right,
                                                          style: TextStyle(
                                                            color:
                                                            distanceSelect !=
                                                                '>10KM'
                                                                ? greyScale90Color
                                                                : whiteColor,
                                                            fontSize: 14,
                                                            fontFamily: 'Abel',
                                                            fontWeight: FontWeight
                                                                .w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        print("application");
                        var response = await searchFilter(
                            _values.start, _values.end,
                            suggestionSelect, distanceSelect, selectedOption);
                        print('response filterrrrrrr');
                        print(response);
                        if (response["error"] == '0') {
                          if (response["foods"].isNotEmpty) {
                            setState(() {
                              firstOpen = false;
                              dataFind = true;
                              searchResult = response["foods"];
                            });
                          } else {
                            setState(() {
                              firstOpen = false;
                              dataFind = false;
                              searchResult = [];
                            });
                          }
                        }
                      },
                      child: Container(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Color(0xFF03443C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                'Apply',
                                style: TextStyle(
                                  color: Color(0xFFFEFEFE),
                                  fontSize: 14,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.07,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

  void _showSortModal(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            void Function(void Function()) setState) {
          return Container(
            height: 300,
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Stack(
              children: [

              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Icon(Icons.arrow_back_ios),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'De quoi avez vous besoin?',
                              border: InputBorder.none,
                            ),
                            //style: text14GreyScale20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: InkWell(
                            onTap: () async {
                              print(searchController.text);
                              if (searchController.text != "") {
                                var response =
                                await getSearch(searchController.text);
                                print(
                                    "response__________------___--_-_-_-____------");
                                print(response);
                                if (response["error"].toString() == "0") {
                                  if (response["foods"].isNotEmpty) {
                                    setState(() {
                                      firstOpen = false;
                                      dataFind = true;
                                      searchResult = response["foods"];
                                    });
                                  } else {
                                    setState(() {
                                      firstOpen = false;
                                      dataFind = false;
                                      searchResult = [];
                                    });
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Icon(
                                Icons.search,
                                color: whiteColor,
                                size: 25,
                              ),
                            )
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                    ],
                  ),
                ),
                dataFind || firstOpen
                    ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: HorizontalExchangeList(
                    exchangeData: filtre,
                    selectName: getCurrentMonthName(""),
                    onCategorySelected: (category, name) {
                      if (category == 1) {
                        _showFilterModal(context);
                      }
                      if (category == 2) {
                        _showSortModal(context);
                      }
                      setState(() {
                        //selectedCategory = category;
                        //foodsFiltre = getFoodsByCategoryId(selectedCategory, foods);
                        //categorieName = name;
                        /* SelectedName = name;
                              if (category == 1) {
                                foodData = foods;
                              } else if (category == 2) {
                                foodData = foodOfMonth;
                              } else if (category == 3) {
                                foodData = getFoodsBydiscount(foods);
                              } */
                      });
                    },
                  ),
                )
                    : Container(
                  width: 327,
                  height: 104,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Aucun resultat',
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
                          'Désolé, votre recherche n\'a donnée aucun resultat.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF66707A),
                            fontSize: 18,
                            fontFamily: 'Abel',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                    child: SingleChildScrollView(
                        child: buildCardColumn(
                            searchResult,
                            widget.lat,
                            widget.lng,
                            size.width,
                            widget.tax,
                            widget.favorite, () {
                          _getItemCount();
                          _getBasket();
                        }))),
              ],
            ),
          ),
          SizedBox(
            height: 25,
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
    );
  }
}