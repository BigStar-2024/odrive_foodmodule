import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/components/roundedinput.dart';
import 'package:odrive/constante/utils.dart';
import 'package:odrive/pages/map/map.dart';
import 'package:odrive/pages/paiement/paiement.dart';
import 'package:odrive/themes/theme.dart';
import 'package:odrive/widget/haversine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import '../../components/appbar.dart';

class CommandeScreen extends StatefulWidget {
  List<dynamic> orderDetails;
  double lat;
  double lng;
  dynamic dataComplet;
  dynamic reduction;
  CommandeScreen(
      {super.key,
      required this.orderDetails,
      required this.lat,
      required this.lng,
      required this.dataComplet,
      required this.reduction});

  @override
  State<CommandeScreen> createState() => _CommandeScreenState();
}

class _CommandeScreenState extends State<CommandeScreen> {
  late GoogleMapController mapController;

  String adress = "";
  String lat = "0.0";
  String lng = "0.0";
  //List<Marker> allMarkers = [];

  String subTotal = "";
  String reductionTotal = "";
  String fee = "";
  String serviceFee = "";
  double totalCom = 0;
  double distance = 0.0;
  String excedant = "0.0";
  final Set<Marker> _markers = {};

  String numero_paiement = "";
  TextEditingController friendNameController = TextEditingController();
  bool _error = false;

  @override
  void initState() {
    // TODO: implement initState
    // getCoord();
    print("---------------oooooooooerrrrrrrrrr________");
    print(widget.orderDetails);
    print(widget.dataComplet);
    print(widget.dataComplet["restaurant"]);

    setState(() {
      fee = widget.dataComplet["fee"];
      serviceFee = widget.dataComplet["default_tax"];
    });
    setState(() {
      distance = Haversine.calculateDistance(
          double.parse(widget.dataComplet["restaurant"]["lat"]),
          double.parse(widget.dataComplet["restaurant"]["lng"]),
          widget.lat,
          widget.lng);
    });

    if (distance > widget.dataComplet["restaurant"]["area"]) {
      CalculateExcedant(distance);
    }
    calculateTotalCommande(calculateTotalPrice().toString(), fee, serviceFee,
        calculateTotalReduction().toString());
    //addMarker();

    super.initState();
  }

  void CalculateExcedant(distance) {
    double distanceEnPlus = distance - widget.dataComplet["restaurant"]["area"];
    setState(() {
      excedant = (distanceEnPlus *
              double.parse(widget.dataComplet["restaurant"]["fee_excedant"]))
          .toString();
    });
  }

  addMarker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adress = prefs.getString("myAdresse") ?? "";
    lat = prefs.getString("myLatitude") ?? "";
    lng = prefs.getString("myLongitude") ?? "";
    print(adress);
    print(lat);
    print(lng);
    /* final Uint8List markerIcon =
        await getMarkerIcon('assets/test/House_icon.png', 50); */
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/test/House_icon.png');
    setState(() {
      _markers
          .removeWhere((marker) => marker.markerId.value == 'lieu_livraison');
      _markers.add(
        Marker(
            markerId: MarkerId("lieu_livraison"),
            position: LatLng(double.parse(lat), double.parse(lng)),
            //icon: BitmapDescriptor.fromBytes(markerIcon),
            icon: icon),
      );
    });
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  /* getCoord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lat = double.parse(prefs.getString("myLatitude") ?? "5.4356");
      lng = double.parse(prefs.getString("myLongitude") ?? "-3.34675");
    });

    print("***********************************");
    print(lat);
    print(lng);
  } */

  googleMap() {
    print("-------------------------------");
    print(lat);
    print(lng);

    /* setState(()  {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      adress = prefs.getString("myAdresse") ?? "";
      lat = prefs.getString("myLatitude") ?? "";
      lng = prefs.getString("myLongitude") ?? "";
    }); */
    double _latitude = double.parse(lat);
    double _longitude = double.parse(lng);
    return GoogleMap(
      zoomControlsEnabled: false,
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(
        //target: LatLng(double.parse(lat), double.parse(lng)),
        target: LatLng(widget.lat, widget.lng),
        zoom: 18.0,
      ),
      onMapCreated: mapCreated,
      //markers: Set.from(allMarkers),
      markers: _markers,
    );
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var foodItem in widget.orderDetails) {
      total += foodItem.totalPrice;
    }
    setState(() {
      subTotal = total.toString();
    });
    return total;
  }

  double calculateTotalReduction() {
    double totalReduction = 0;
    double totalSub = calculateTotalPrice();
    if (widget.reduction != null) {
      if (widget.reduction["inpercents"] == 1) {
        totalReduction =
            (double.parse(widget.reduction["discount"]).toInt() * totalSub) /
                100;
      } else {
        totalReduction = double.parse(widget.reduction["discount"]);
      }
      setState(() {
        reductionTotal = totalReduction.toString();
      });
      return totalReduction;
    } else {
      return 0.0;
    }
  }

  void calculateTotalCommande(subTotal, fee, feeService, subReduction) {
    print("excedant__________________________________-");
    print(excedant);
    double totalCommande = 0;
    totalCommande = double.parse(subTotal) -
        double.parse(subReduction) +
        double.parse(fee) +
        double.parse(feeService) +
        double.parse(excedant);
    setState(() {
      totalCom = totalCommande;
    });
    //return totalCommande;
  }

  mapCreated(GoogleMapController controller) async {
    mapController = controller;
    addMarker();
    /* //isMapReady = true;
    if (mapController != null) {
      //await marker();
      setState(() {});
    } */
  }

  void _showFriendModal(BuildContext context) {
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
            height: 400,
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
                            'Order with friends',
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
                                  'Friend Name',
                                  style: TextStyle(
                                    color: Color(0xFF171725),
                                    fontSize: 16,
                                    fontFamily: 'Abel',
                                    fontWeight: FontWeight.w400,
                                    height: 0.09,
                                  ),
                                ),
                                SizedBox(height: 16.0,),
                                RoundedTextField(
                                  hintText: "Friends Name",
                                  keyboardType: TextInputType.text,
                                  controller: friendNameController,
                                  error: _error,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
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
                                SizedBox(height: 16.0),
                                IntlPhoneField(
                                  languageCode: "fr",
                                  invalidNumberMessage: "Numéro incorrecte",
                                  decoration: InputDecoration(
                                    labelText: 'Numéro du paiement',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                  initialCountryCode: 'CI',
                                  onChanged: (phone) {
                                    print(phone.number);
                                    print(phone.completeNumber);
                                    setState(() {
                                      numero_paiement = phone.number;
                                    });
                                  },
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
                        if(friendNameController.value.text == "" || numero_paiement == "") return;
                        var response = await setFriendInformation(
                            widget.dataComplet["order"]["id"], friendNameController.value.text, numero_paiement);

                        if (response["error"] == '0' || response["error"] == null) {
                          Fluttertoast.showToast(msg: response["message"]);
                        }
                        else{
                          Fluttertoast.showToast(msg: "La mise à jour des informations de votre ami pour votre commande a échoué.");
                        }
                        Navigator.pop(context);
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


  @override
  Widget build(BuildContext context) {
    print("orderdetails");
    print(widget.orderDetails);
    return Scaffold(
      appBar: MyAppBar(
        titleText: 'Commande',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                height: 250.0,
                // Hauteur fixe de la carte
                child: googleMap(),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapScreen()))
                      .then((value) async {
                    if (value != null) {
                      setState(() {
                        adress = value["lieu"];
                        lat = value["lat"];
                        lng = value["lng"];
                      });

                      LatLng selectedLatLng =
                          LatLng(double.parse(lat), double.parse(lng));
                      mapController.animateCamera(
                          CameraUpdate.newLatLng(selectedLatLng));

                      setState(() {
                        distance = Haversine.calculateDistance(
                            double.parse(
                                widget.dataComplet["restaurant"]["lat"]),
                            double.parse(
                                widget.dataComplet["restaurant"]["lng"]),
                            double.parse(lat),
                            double.parse(lng));
                      });
                      print(distance);
                      print(
                          "distance*******************************************");
                      print(widget.dataComplet["restaurant"]["area"]);

                      if (distance > widget.dataComplet["restaurant"]["area"]) {
                        CalculateExcedant(distance);
                      } else {
                        setState(() {
                          excedant = "0";
                        });
                      }
                      print("excedant**********************************");
                      print(excedant);
                      calculateTotalCommande(
                          calculateTotalPrice().toString(),
                          fee,
                          serviceFee,
                          calculateTotalReduction().toString());
                      addMarker();
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 24,
                          color: greyScale700Color,
                        ),
                        Text(shortenLocationName(adress, 25))
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                children: widget.orderDetails.map((foodItem) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            // Image carrée à gauche
                            Stack(
                              children: [
                                Container(
                                  width: 100.0,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          '$serverImages${foodItem.image}'), // Remplacez par le chemin de votre image
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    child: Container(
                                      color: greyColor900,
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        "x${foodItem.count}",
                                        style: TextStyle(color: blackColor),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.all(8),
                                  child: (
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            foodItem.name,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            sliceString(foodItem.desc, 50),
                                            style: TextStyle(fontSize: 14.0, color: greyColor800),
                                          ),
                                          Text(
                                            '${foodItem.totalPrice} F',
                                            style: TextStyle(fontSize: 16.0, color: primaryColor),
                                          ),
                                        ],
                                      )
                                  ),
                                )
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  color: greyColor900,
                                  child: Icon(Icons.edit, size: 20, color: Colors.black),
                                )
                            ),
                            SizedBox(width: 8)
                            // Image.asset(width: 50, "assets/test/pencil.png"),
                          ],
                        ),
                      ),
                      SizedBox(height: fixPadding)
                    ]
                  );
                }).toList(),
              ),
              Divider(
                color: greyScale10Color,
                thickness: 10.0, // Épaisseur de la ligne
                height: 20.0, // Hauteur de la ligne
              ),
              SizedBox(height: fixPadding),
              Row(
                children: [
                  Text(
                    "Détails de paiement",
                    style: text18GreyScale100,
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Marchandise Sous total",
                    style: text16GrayScale90,
                  ),
                  Text(
                    "F ${calculateTotalPrice().toStringAsFixed(0)}",
                    style: text16GrayScale90,
                  ),
                ],
              ),
              widget.reduction != null
                  ? SizedBox(
                      height: 15,
                    )
                  : Container(),
              widget.reduction != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reduction coupon",
                          style: text16GrayScale90,
                        ),
                        Text(
                          "F -${calculateTotalReduction().toStringAsFixed(0)}",
                          style: text16GrayScale90,
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Frais de livraison",
                    style: text16GrayScale90,
                  ),
                  Text(
                    "F ${double.parse(widget.dataComplet["fee"]).toStringAsFixed(0)}",
                    style: text16GrayScale90,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Frais de service",
                    style: text16GrayScale90,
                  ),
                  Text(
                    "F ${double.parse(widget.dataComplet["default_tax"]).toStringAsFixed(0)}",
                    style: text16GrayScale90,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Distance en plus",
                    style: text16GrayScale90,
                  ),
                  Text(
                    "F ${double.parse(excedant).toStringAsFixed(0)}",
                    style: text16GrayScale90,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: greyScale60Color,
                thickness: 2.0, // Épaisseur de la ligne
                height: 20.0, // Hauteur de la ligne
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total à payer",
                    style: text16GrayScale100,
                  ),
                  Text(
                    "F ${totalCom.toStringAsFixed(0)}",
                    style: text16Success,
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    if (lat != "" && lng != "") {
                      _showFriendModal(context);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Veillez selectionner une addresse");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor, // Couleur de fond du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text('Order with friends', style: Theme.of(context).textTheme.titleSmall),
                  ),
                ),
              ),

              SizedBox(
                height: 25,
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    if (lat != "" && lng != "") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaiementScreen(
                                dataComplet: widget.dataComplet,
                                reduction: widget.reduction,
                                totalMontant: totalCom,
                                excedant: double.parse(double.parse(excedant)
                                    .toStringAsFixed(0)))),
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Veillez selectionner une addresse");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor, // Couleur de fond du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text('Commander', style: Theme.of(context).textTheme.titleSmall),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Uint8List> getMarkerIcon(String path, int size) async {
  final ByteData data = await rootBundle.load(path);
  final DrawableRoot svgRoot =
      await svg.fromSvgBytes(data.buffer.asUint8List(), data.toString());
  final ui.Picture picture = svgRoot.toPicture();
  final ui.Image image = await picture.toImage(size, size);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
