import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/suivie/suivie.dart';
import 'package:odrive/themes/theme.dart';

class CommandesScreen extends StatefulWidget {
  const CommandesScreen({super.key});

  @override
  State<CommandesScreen> createState() => _CommandesScreenState();
}

class _CommandesScreenState extends State<CommandesScreen> {
  dynamic ordersData = {};
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    _getOrders();
    super.initState();
  }

  void _getOrders() async {
    setState(() {
      _loading = true;
    });
    var response = await getOrders();
    print("getOrders response");
    print(response);
    if (response["error"] == "0") {
      if (response["data"].isNotEmpty) {
        setState(() {
          ordersData = response;
        });
      } else {
        setState(() {
          ordersData = {"empty": true};
        });
      }
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
      appBar: MyAppBar(titleText: "Commandes"),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: ordersData["data"]?.map<Widget>((foodItem) {
                    return Card(
                      margin: EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Image carrée à gauche
                            Stack(
                              children: [
                                Container(
                                  width: 85.0,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          '$serverImages${foodItem["restaurantimage"]}'), // Remplacez par le chemin de votre image
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 16.0),
                            // Textes au milieu en 3 colonnes
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        foodItem["statusName"] ==
                                                "Order Received"
                                            ? "assets/suivi/order_receive.svg"
                                            : foodItem["statusName"] ==
                                                    "Delivered"
                                                ? "assets/suivi/success.svg"
                                                : foodItem["statusName"] ==
                                                        "Preparing"
                                                    ? "assets/suivi/preparing.svg"
                                                    : foodItem["statusName"] ==
                                                            "Ready"
                                                        ? "assets/suivi/order_receive.svg"
                                                        : foodItem["statusName"] ==
                                                                "On the Way"
                                                            ? "assets/suivi/man.svg"
                                                            : foodItem["statusName"] ==
                                                                    "Canceled"
                                                                ? "assets/suivi/cancel.svg"
                                                                : "assets/suivi/order_receive.svg",
                                        color:
                                            foodItem["statusName"] == "Canceled"
                                                ? errorColor
                                                : successColor,
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${foodItem["statusName"]} |",
                                        style: TextStyle(
                                          color: successColor,
                                          fontSize: 12,
                                          fontFamily: 'Abel',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        foodItem["date"],
                                        style: TextStyle(
                                          color: Color(0xFF66707A),
                                          fontSize: 12,
                                          fontFamily: 'Abel',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    foodItem["restaurant"],
                                    style: TextStyle(
                                      color: Color(0xFF171725),
                                      fontSize: 16,
                                      fontFamily: 'Abel',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Column(
                                    children: (foodItem["ordersdetails"]
                                            as List<dynamic>)
                                        .where((foodItemDetail) =>
                                            (foodItemDetail as Map<String,
                                                dynamic>)["count"] >
                                            0)
                                        .map((food) {
                                      return Row(
                                        children: [
                                          Text((food
                                              as Map<String, dynamic>)["food"]),
                                          Text(
                                              "   X${(food as Map<String, dynamic>)["count"]}")
                                        ],
                                      );
                                    }).toList(),
                                  )
                                  /* Text(
                                '${foodItem.totalPrice} F',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 25,
                              ), */
                                ],
                              ),
                            ),
                            // Bouton en bas à droite
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SuivieScreen(
                                              order_id: foodItem["orderid"])));
                                },
                                child: Icon(Icons.arrow_forward_ios))
                            //Image.asset(width: 50, "assets/test/pencil.png"),
                          ],
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
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
    );
  }
}
