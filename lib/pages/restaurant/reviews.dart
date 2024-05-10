import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/components/loading.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/themes/theme.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../components/appbar.dart';

class ReviewsScreen extends StatefulWidget {
  final idRestaurant;
  ReviewsScreen({required this.idRestaurant});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<dynamic> restaurantReviews = [];
  bool _loading = false;
  int count5Reviews = 0;
  int count4Reviews = 0;
  int count3Reviews = 0;
  int count2Reviews = 0;
  int count1Reviews = 0;
  double percentage1 = 0.0;
  double percentage2 = 0.0;
  double percentage3 = 0.0;
  double percentage4 = 0.0;
  double percentage5 = 0.0;

  bool sortByStarAscending = true;
  bool sortByRecent = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getReviews();
  }

  _getReviews() async {
    setState(() {
      _loading = true;
    });
    var response = await getReviews(widget.idRestaurant);
    if (response['error'] == '0') {
      setState(() {
        restaurantReviews = response["reviews"];

        if (restaurantReviews.isNotEmpty) {
          for (var review in restaurantReviews) {
            int? rate = int.tryParse(review['rate']);
            if (rate == 5) {
              count5Reviews++;
            }
            if (rate == 4) {
              count4Reviews++;
            }
            if (rate == 3) {
              count3Reviews++;
            }
            if (rate == 2) {
              count2Reviews++;
            }
            if (rate == 1) {
              count1Reviews++;
            }
          }
          percentage1 = count1Reviews / restaurantReviews.length;
          percentage2 = count2Reviews / restaurantReviews.length;
          percentage3 = count3Reviews / restaurantReviews.length;
          percentage4 = count4Reviews / restaurantReviews.length;
          percentage5 = count5Reviews / restaurantReviews.length;
        }
      });
    }
    setState(() {
      _loading = false;
    });
  }

  double calculerScoreMoyen(List<dynamic> avis) {
    if (avis.isEmpty) {
      return 0.0; // Si la liste d'avis est vide, le score moyen est 0
    }

    int sommeScores = 0;
    int nombreAvis = 0;

    for (var review in avis) {
      int? rate = int.tryParse(review['rate']);
      if (rate != null && rate >= 1 && rate <= 5) {
        sommeScores += rate;
        nombreAvis++;
      }
    }

    if (nombreAvis == 0) {
      return 0.0; // Éviter la division par zéro
    }

    return sommeScores / nombreAvis;
  }

  void sortReviewsByStar() {
    setState(() {
      sortByStarAscending = !sortByStarAscending;
      restaurantReviews.sort((a, b) {
        int ratingA = int.parse(a['rate']);
        int ratingB = int.parse(b['rate']);
        return sortByStarAscending
            ? ratingA.compareTo(ratingB)
            : ratingB.compareTo(ratingA);
      });
    });
  }

  void sortReviewsByDate() {
    setState(() {
      sortByRecent = !sortByRecent;
      restaurantReviews.sort((a, b) {
        DateTime dateA = DateTime.parse(a['created_at']);
        DateTime dateB = DateTime.parse(b['created_at']);
        return sortByRecent ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
      });
    });
  }

  Widget buildStarIcon(bool isFilled) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isFilled ? "assets/review/Star.png" : "assets/review/StarVide.png",
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(titleText: 'Commentaire'),
      body: Stack(
        children: [
          restaurantReviews.isNotEmpty
              ? SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          //height: 254,
                          // color: Color(0xFFF2F2F2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: ShapeDecoration(
                            color: Color(0xFFF2F2F2),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        '${calculerScoreMoyen(restaurantReviews)}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF212121),
                                          fontSize: 32,
                                          fontFamily: 'Abel',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      //width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (int i = 0; i < 5; i++)
                                            buildStarIcon(i <
                                                calculerScoreMoyen(
                                                        restaurantReviews)
                                                    .floor()), // Afficher des étoiles pleines pour les valeurs inférieures à la partie entière de la moyenne
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 22,
                                      child: Text(
                                        '(${restaurantReviews.length} Avis)',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF424242),
                                          fontSize: 12,
                                          fontFamily: 'Abel',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 120,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      //width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                            child: Text(
                                              '5',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(0xFF434E58),
                                                fontSize: 16,
                                                fontFamily: 'Abel',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Container(
                                              height: 15,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 5,
                                                    child:
                                                        LinearPercentIndicator(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                      lineHeight: 7.0,
                                                      percent: percentage5,
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      backgroundColor:
                                                          Color(0xFFD1D8DD),
                                                      progressColor:
                                                          primaryColor,
                                                      barRadius:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                            child: Text(
                                              '4',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(0xFF434E58),
                                                fontSize: 16,
                                                fontFamily: 'Abel',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Container(
                                              height: 15,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 5,
                                                    child:
                                                        LinearPercentIndicator(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                      lineHeight: 7.0,
                                                      percent: percentage4,
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      backgroundColor:
                                                          Color(0xFFD1D8DD),
                                                      progressColor:
                                                          primaryColor,
                                                      barRadius:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                            child: Text(
                                              '3',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(0xFF434E58),
                                                fontSize: 16,
                                                fontFamily: 'Abel',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Container(
                                              height: 15,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 5,
                                                    child:
                                                        LinearPercentIndicator(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                      lineHeight: 7.0,
                                                      percent: percentage3,
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      backgroundColor:
                                                          Color(0xFFD1D8DD),
                                                      progressColor:
                                                          primaryColor,
                                                      barRadius:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                            child: Text(
                                              '2',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(0xFF434E58),
                                                fontSize: 16,
                                                fontFamily: 'Abel',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Container(
                                              height: 15,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 5,
                                                    child:
                                                        LinearPercentIndicator(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                      lineHeight: 7.0,
                                                      percent: percentage2,
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      backgroundColor:
                                                          Color(0xFFD1D8DD),
                                                      progressColor:
                                                          primaryColor,
                                                      barRadius:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                            child: Text(
                                              '1',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(0xFF434E58),
                                                fontSize: 16,
                                                fontFamily: 'Abel',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Container(
                                              height: 15,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 5,
                                                    child:
                                                        LinearPercentIndicator(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                      lineHeight: 7.0,
                                                      percent: percentage1,
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      backgroundColor:
                                                          Color(0xFFD1D8DD),
                                                      progressColor:
                                                          primaryColor,
                                                      barRadius:
                                                          Radius.circular(20),
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
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 19),
                        Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        sortReviewsByStar();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 4),
                                        decoration: ShapeDecoration(
                                          color: Color(0xFFF2F2F2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                              'Star',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF434E58),
                                                fontSize: 16,
                                                fontFamily: 'Abel',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              width: 24,
                                              height: 24,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    child: Image.asset(
                                                      'assets/review/Star.png',
                                                      width: 24,
                                                      height: 24,
                                                      //color: Colors.yellow,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              child: Icon(
                                                sortByStarAscending
                                                    ? Icons
                                                    .keyboard_arrow_down_outlined
                                                    : Icons
                                                    .keyboard_arrow_up_outlined,
                                              )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        sortReviewsByDate();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 4),
                                        decoration: ShapeDecoration(
                                          color: sortByRecent
                                              ? Color(0xFF332C45)
                                              : Color(0xFFF2F2F2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 2.51,
                                                          top: 4.5,
                                                          child: Container(
                                                            width: 14.98,
                                                            height: 15,
                                                            child: Stack(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    'assets/search/trier.svg',
                                                                    color: sortByRecent
                                                                        ? whiteColor
                                                                        : Color(
                                                                            0xFF434E58),
                                                                  )
                                                                ]),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              'Arrange',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: sortByRecent
                                                    ? Colors.white
                                                    : Color(0xFF434E58),
                                                fontSize: 16,
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
                              const SizedBox(height: 25),
                              Container(
                                  child: Column(
                                children: restaurantReviews.map((review) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 45,
                                              height: 45,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    child: CircleAvatar(
                                                      radius: 22.5,
                                                      backgroundColor: Colors.green,
                                                      child: CircleAvatar(
                                                        radius: 21,
                                                        backgroundImage: NetworkImage(
                                                            "${serverImages}/${review["image"]}"),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Container(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 266,
                                                    child: Row(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: 136,
                                                          child: Column(
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                double.infinity,
                                                                child: Text(
                                                                  review["name"],
                                                                  style: TextStyle(
                                                                    color: Color(
                                                                        0xFF171725),
                                                                    fontSize: 18,
                                                                    fontFamily:
                                                                    'Abel',
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    for (var i = 0;
                                                                    i <
                                                                        int.parse(
                                                                            review["rate"]);
                                                                    i++)
                                                                      Container(
                                                                        width: 24,
                                                                        height: 24,
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Container(
                                                                              width:
                                                                              24,
                                                                              height:
                                                                              24,
                                                                              decoration:
                                                                              BoxDecoration(
                                                                                image:
                                                                                DecorationImage(
                                                                                  image: AssetImage("assets/review/Star.png"),
                                                                                  fit: BoxFit.fill,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    for (var i = int
                                                                        .parse(review[
                                                                    "rate"]);
                                                                    i < 5;
                                                                    i++)
                                                                      Container(
                                                                        width: 24,
                                                                        height: 24,
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Container(
                                                                              width:
                                                                              24,
                                                                              height:
                                                                              24,
                                                                              decoration:
                                                                              BoxDecoration(
                                                                                image:
                                                                                DecorationImage(
                                                                                  image: AssetImage("assets/review/StarVide.png"),
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
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(width: 48),
                                                        Expanded(
                                                          child: SizedBox(
                                                            child: Text(
                                                              getFormattedDate(review["created_at"]),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF9CA4AB),
                                                                fontSize: 14,
                                                                fontFamily: 'Abel',
                                                                fontWeight:
                                                                FontWeight.w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  SizedBox(
                                                    width: 266,
                                                    child: Text(
                                                      review["desc"],
                                                      style: TextStyle(
                                                        color: Color(0xFF171725),
                                                        fontSize: 14,
                                                        fontFamily: 'Abel',
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: greyColor900, // Couleur de la ligne
                                          thickness: 1, // Épaisseur de la ligne
                                        ),
                                      ],
                                    )
                                    // child:
                                  );
                                }).toList(),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Aucun Avis',
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
                            'Désolé, ce restaurant n\'a aucun avis.',
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
                ),
          _loading
              ? LoadingWidget()
              : Container(),
        ],
      ),
    );
  }
}

String getFormattedDate(String date){
  DateTime dateObject = DateTime.parse(date);
  return DateFormat('MM/dd/yyyy').format(dateObject);
}
