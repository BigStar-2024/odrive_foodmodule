
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../pages/commande/commandes.dart';
import '../pages/favorite/favorite.dart';
import '../pages/recompense/recompense.dart';
import '../themes/theme.dart';

/*
* MyBottomBar
* */

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
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
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
                                  color: MyAppColors.primaryColor,
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Home',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: MyAppColors.primaryColor,
                          fontSize: 14
                        )
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