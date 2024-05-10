import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/constante/const.dart';
import 'package:odrive/pages/call/call.dart';
import 'package:odrive/pages/message/message.dart';
import 'package:odrive/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SuivieLivreur extends StatefulWidget {
  dynamic orderData;
  SuivieLivreur({super.key, required this.orderData});

  @override
  State<SuivieLivreur> createState() => _SuivieLivreurState();
}

class _SuivieLivreurState extends State<SuivieLivreur> {
  List<Marker> allMarkers = [];
  late GoogleMapController mapController;
  List<LatLng> polylineCoordinates = [];
  dynamic driverData;
  int estimatedTimeInSeconds = 0;
  String temps = "";
  Timer? _refreshTimer;
  int status = 1;
  dynamic orderDetailData;
  String lat = "0.0";
  String lng = "0.0";

  @override
  void initState() {
    super.initState();
    addMarker();
    fetchRoute();
    getDriver();
    //_getDriverLocation();
    getOrderState();
    time_estimation(widget.orderData["data"]["date"], estimatedTimeInSeconds);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("FirebaseMessaging.onMessage----- ${message.messageId}");
      print("Firebase messaging:onMessage: $message");
      print("Firebase message: ${message.data}");

      await getOrderState();
    });
    /* _refreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      getOrderState();
    }); */
    /* _refreshTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _getDriverLocation();
      deleteLivreur();
      updateDriverMarker();
    }); */
  }

  @override
  void dispose() {
    _refreshTimer!.cancel();
    super.dispose();
  }

  _getDriverLocation() async {
    var response = await getDriverLocation(widget.orderData["data"]["driver"]);
    if (response['error'] == '0') {
      setState(() {
        lat = response['lat'];
        lng = response['lng'];
      });
    } else {
      Fluttertoast.showToast(msg: "Une erreur s'est produite");
    }
    print(lat);
    print(lng);
    allMarkers
        .removeWhere((marker) => marker.markerId.value == 'position livreur');
    print("allMarkers length--------------------");
    print(allMarkers.length);
    allMarkers.add(
      Marker(
        markerId: MarkerId("position livreur"),
        position: LatLng(double.parse(lat), double.parse(lng)),
        icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset("assets/test/delivery.png", 130),
        ),
      ),
    );
    print("allMarkers length--------------------");
    print(allMarkers.length);
  }

  deleteLivreur() async {
    var response = await getDriverLocation(widget.orderData["data"]["driver"]);
    if (response['error'] == '0') {
      setState(() {
        lat = response['lat'];
        lng = response['lng'];
      });
      print(lat);
      print(lng);
      allMarkers
          .removeWhere((marker) => marker.markerId.value == 'position livreur');

      // Si le marqueur existe, mettez à jour sa position

      // Mettre à jour le marqueur après avoir obtenu les nouvelles coordonnées

    } else {
      Fluttertoast.showToast(msg: "Une erreur s'est produite");
    }
  }

  updateDriverMarker() async {
    print("allMarkers length--------------------");
    print(allMarkers.length);
    allMarkers.add(
      Marker(
        markerId: MarkerId("position livreur"),
        position: LatLng(double.parse(lat), double.parse(lng)),
        icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset("assets/test/delivery.png", 130),
        ),
      ),
    );
    print("allMarkers length--------------------");
    print(allMarkers.length);
  }

  getOrderState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString("uuid") ?? "";
    var response =
        await getOrderDetails(uuid, widget.orderData["data"]["orderid"]);
    if (response['error'] == '0') {
      List<dynamic> ordertimes = response['data']['ordertimes'];
      if (mounted) {
        setState(() {
          orderDetailData = response;
        });
      }

      print(orderDetailData);

      if (ordertimes.isNotEmpty) {
        // Obtenez le dernier élément de la liste 'ordertimes'
        Map<String, dynamic> lastOrderTime = ordertimes.last;

        // Récupérez le statut du dernier objet dans 'ordertimes'
        int lastStatus = lastOrderTime['status'];
        print('Statut du dernier ordre : $lastStatus');
        if (mounted) {
          setState(() {
            status = lastStatus;
          });
        }
      } else {
        print('La liste ordertimes est vide.');
      }
    }
  }

  String time_estimation(String _date, int estimatedTimeInSeconds) {
    // Exemple de durée estimée, remplacez par votre valeur réelle

    // Convertir la chaîne de caractères en objet DateTime
    DateTime dateTime = DateTime.parse(_date);

    // Ajouter la durée estimée en secondes
    DateTime newDateTime =
        dateTime.add(Duration(seconds: estimatedTimeInSeconds));

    DateTime newDateTime2 = newDateTime.add(Duration(minutes: 10));

    // Afficher uniquement l'heure sans la date
    String newTime =
        "${newDateTime.hour}:${newDateTime.minute}-${newDateTime2.hour}:${newDateTime2.minute}";
    print(newTime); // L'heure sera affichée au format "HH:MM"
    setState(() {
      temps = newTime;
    });
    return newTime;
  }

  getDriver() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString("uuid") ?? "";
    var response =
        await getDriverDetails(uuid, widget.orderData["data"]["driver"]);
    print(response);
    if (response["error"] == "0") {
      setState(() {
        driverData = response["data"];
      });
    }
  }

  addMarker() async {
    print(widget.orderData);
    double destLat =
        double.tryParse(widget.orderData["data"]["destLat"].toString()) ?? 0.0;
    double destLng =
        double.tryParse(widget.orderData["data"]["destLng"].toString()) ?? 0.0;
    double shopLat =
        double.tryParse(widget.orderData["data"]["shopLat"].toString()) ?? 0.0;
    double shopLng =
        double.tryParse(widget.orderData["data"]["shopLng"].toString()) ?? 0.0;

    var response = await getDriverLocation(widget.orderData["data"]["driver"]);
    if (response['error'] == '0') {
      setState(() {
        lat = response['lat'];
        lng = response['lng'];
      });
    }
    _refreshTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      var response =
          await getDriverLocation(widget.orderData["data"]["driver"]);
      if (response['error'] == '0') {
        setState(() {
          lat = response['lat'];
          lng = response['lng'];
        });
        allMarkers.add(
          Marker(
            markerId: MarkerId("position livreur"),
            position: LatLng(double.parse(lat), double.parse(lng)),
            icon: BitmapDescriptor.fromBytes(
              await getBytesFromAsset("assets/test/delivery.png", 100),
            ),
          ),
        );
      }
      print("allMarkers length--------------------");
      print(allMarkers.length);
    });

    allMarkers.add(
      Marker(
        markerId: MarkerId("Votre position"),
        position: LatLng(destLat, destLng),
        icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset("assets/test/House_icon.png", 80),
        ),
      ),
    );
    allMarkers.add(
      Marker(
        markerId: MarkerId("position restaurant"),
        position: LatLng(shopLat, shopLng),
      ),
    );
    allMarkers.add(
      Marker(
        markerId: MarkerId("position livreur"),
        position: LatLng(double.parse(lat), double.parse(lng)),
        icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset("assets/test/delivery.png", 100),
        ),
      ),
    );
  }

  fetchRoute() async {
    double destLat =
        double.tryParse(widget.orderData["data"]["destLat"].toString()) ?? 0.0;
    double destLng =
        double.tryParse(widget.orderData["data"]["destLng"].toString()) ?? 0.0;
    double shopLat =
        double.tryParse(widget.orderData["data"]["shopLat"].toString()) ?? 0.0;
    double shopLng =
        double.tryParse(widget.orderData["data"]["shopLng"].toString()) ?? 0.0;

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$destLat,$destLng&destination=$shopLat,$shopLng&key=$googleApiKey';

    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    List<LatLng> points = [];

    if (data['status'] == 'OK') {
      // Analyser les données pour extraire les points de la route
      data['routes'][0]['legs'][0]['steps'].forEach((step) {
        points.add(
          LatLng(
            step['start_location']['lat'],
            step['start_location']['lng'],
          ),
        );
        points.add(
          LatLng(
            step['end_location']['lat'],
            step['end_location']['lng'],
          ),
        );
      });
      setState(() {
        // Extraire le temps de conduite estimé en secondes
        estimatedTimeInSeconds =
            data['routes'][0]['legs'][0]['duration']['value'];
      });
    }

    // Mettre à jour l'état avec les coordonnées de la polyline
    setState(() {
      polylineCoordinates = points;
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

  googleMap() {
    final dynamic data = ModalRoute.of(context)!.settings.arguments;
    print("google MAP");

    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(widget.orderData["data"]["shopLat"]),
            double.parse(widget.orderData["data"]["shopLng"])),
        zoom: 13.0,
      ),
      onMapCreated: mapCreated,
      markers: Set.from(allMarkers),
      polylines: {
        Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: primaryColor,
          width: 3,
        ),
      },
    );
  }

  mapCreated(GoogleMapController controller) async {
    mapController = controller;
    if (mapController != null) {
      setState(() {});
    }
  }

  topHeader() {
    return Padding(
      padding: EdgeInsets.only(
          top: (Platform.isIOS) ? fixPadding * 5.0 : fixPadding * 4.0,
          left: fixPadding * 2.0,
          right: fixPadding * 2.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: blackColor,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget deliveryGoBottomSheet(
      Size size, dynamic driverData, estimatedTimeInSeconds, temps) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: AnimationConfiguration.synchronized(
        child: SlideAnimation(
          curve: Curves.easeIn,
          delay: const Duration(milliseconds: 350),
          child: BottomSheet(
            enableDrag: false,
            constraints: BoxConstraints(maxHeight: size.height * 0.6),
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            onClosing: () {},
            builder: (context) {
              return buildBottomSheetContent(
                  driverData, estimatedTimeInSeconds, temps);
            },
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheetContent(driverData, estimatedTimeInSeconds, temps) {
    String imageUrl = driverData != null
        ? "$serverImages${driverData["profil"]}"
        : "https://via.placeholder.com/52x52";
    return Container(
      //width: 375,
      //height: 308,
      padding: const EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: 40,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 16,
            offset: Offset(0, 8),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: driverData != null
                              ? Text(
                                  driverData["name"] ??
                                      "", // Utilisez le ?? pour gérer le cas où "name" est null
                                  style: TextStyle(
                                    color: Color(0xFF171725),
                                    fontSize: 18,
                                    fontFamily: 'Abel',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Text("..."), // Ou tout autre texte de secours
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Se charge de vous livrer',
                            style: TextStyle(
                              color: Color(0xFF9D9D9D),
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      // _phoneCall(driverData["phone"]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CallScreen(imageUrl: imageUrl)));
                    },
                    child: SvgPicture.asset("assets/suivi_livreur/call.svg")),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MessageScreen()));
                    },
                    child:
                        SvgPicture.asset("assets/suivi_livreur/message.svg")),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 68,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Heure de livraison estimée ',
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontSize: 18,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${temps}',
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontSize: 24,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
                Center(
                  child: Container(
                    //width: 327,
                    //height: 24,
                    alignment: Alignment.center,
                    child: Column(
                      /*  mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start, */
                      children: [
                        Container(
                          child: Column(
                            /* mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start, */
                            children: [
                              Container(
                                width: 327,
                                child: Row(
                                  /* mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center, */
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
                                            child: Stack(children: [
                                              SvgPicture.asset(
                                                'assets/suivi/order_receive.svg',
                                                // width: 200, // spécifiez la largeur si nécessaire
                                                // height: 200, // spécifiez la hauteur si nécessaire
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 6,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        SvgPicture.asset(
                                          'assets/suivi/preparing.svg',
                                          color: status >= 2
                                              ? primaryColor
                                              : Color(0xFF9CA4AB),
                                          // width: 200, // spécifiez la largeur si nécessaire
                                          // height: 200, // spécifiez la hauteur si nécessaire
                                        )
                                      ]),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 6,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: (driverData != null &&
                                                        driverData["id"] != 0 &&
                                                        (status == 9 ||
                                                            status == 6))
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: driverData != null &&
                                                        driverData["id"] != 0
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: driverData != null &&
                                                        driverData["id"] != 0 &&
                                                        (status == 9 ||
                                                            status == 6)
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: driverData != null &&
                                                        driverData["id"] != 0 &&
                                                        (status == 9 ||
                                                            status == 6)
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: driverData != null &&
                                                        driverData["id"] != 0 &&
                                                        (status == 9 ||
                                                            status == 6)
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        SvgPicture.asset(
                                          'assets/suivi/man.svg',
                                          color: driverData != null &&
                                                  driverData["id"] != 0 &&
                                                  (status == 9 || status == 6)
                                              ? primaryColor
                                              : Color(0xFF9CA4AB),
                                          // width: 200, // spécifiez la largeur si nécessaire
                                          // height: 200, // spécifiez la hauteur si nécessaire
                                        )
                                      ]),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 6,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status == 6
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status == 6
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status == 6
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                  color: status == 6
                                                      ? primaryColor
                                                      : Color(0xFF9CA4AB),
                                                  shape: CircleBorder()),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status == 6
                                                    ? primaryColor
                                                    : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        SvgPicture.asset(
                                          'assets/suivi/done.svg',
                                          color: status == 6
                                              ? primaryColor
                                              : Color(0xFF9CA4AB),
                                          // width: 200, // spécifiez la largeur si nécessaire
                                          // height: 200, // spécifiez la hauteur si nécessaire
                                        )
                                      ]),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          googleMap(),
          topHeader(),
          deliveryGoBottomSheet(
              size, driverData, estimatedTimeInSeconds, temps),
        ],
      ),
    );
  }
}

/* Widget deliveryGoBottomSheet(
    Size size, dynamic driverData, estimatedTimeInSeconds, temps) {
  return Positioned(
    bottom: 0,
    right: 0,
    left: 0,
    child: AnimationConfiguration.synchronized(
      child: SlideAnimation(
        curve: Curves.easeIn,
        delay: const Duration(milliseconds: 350),
        child: BottomSheet(
          enableDrag: false,
          constraints: BoxConstraints(maxHeight: size.height * 0.6),
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          onClosing: () {},
          builder: (context) {
            return buildBottomSheetContent(
                driverData, estimatedTimeInSeconds, temps);
          },
        ),
      ),
    ),
  );
}

Widget buildBottomSheetContent(driverData, estimatedTimeInSeconds, temps) {
  return Container(
    //width: 375,
    //height: 308,
    padding: const EdgeInsets.only(
      top: 24,
      left: 24,
      right: 24,
      bottom: 40,
    ),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      shadows: [
        BoxShadow(
          color: Color(0x19000000),
          blurRadius: 16,
          offset: Offset(0, 8),
          spreadRadius: 0,
        )
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(driverData != null
                        ? "$serverImages${driverData["profil"]}"
                        : "https://via.placeholder.com/52x52"),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: driverData != null
                            ? Text(
                                driverData["name"] ??
                                    "", // Utilisez le ?? pour gérer le cas où "name" est null
                                style: TextStyle(
                                  color: Color(0xFF171725),
                                  fontSize: 18,
                                  fontFamily: 'Abel',
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : Text("..."), // Ou tout autre texte de secours
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Se charge de vous livrer',
                          style: TextStyle(
                            color: Color(0xFF9D9D9D),
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    _phoneCall(driverData["phone"]);
                  },
                  child: SvgPicture.asset("assets/suivi_livreur/call.svg")),
              SizedBox(
                width: 15,
              ),
              InkWell(
                  onTap: () {},
                  child: SvgPicture.asset("assets/suivi_livreur/message.svg")),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          height: 68,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Heure de livraison estimée ',
                style: TextStyle(
                  color: Color(0xFF171725),
                  fontSize: 18,
                  fontFamily: 'Abel',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${temps}',
                style: TextStyle(
                  color: Color(0xFF171725),
                  fontSize: 24,
                  fontFamily: 'Abel',
                  fontWeight: FontWeight.w400,
                ),
              ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 327,
                      child: Row(
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
                                    //yoane
                                    SvgPicture.asset(
                                      'assets/suivi/order_receive.svg',
                                      color: Color(0xFF9CA4AB),
                                      // width: 200, // spécifiez la largeur si nécessaire
                                      // height: 200, // spécifiez la hauteur si nécessaire
                                    )
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 6,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Stack(children: [
                              //Yoane
                              SvgPicture.asset(
                                'assets/suivi/preparing.svg',
                                color: Color(0xFF9CA4AB),
                                // width: 200, // spécifiez la largeur si nécessaire
                                // height: 200, // spécifiez la hauteur si nécessaire
                              )
                            ]),
                          ),
                          Expanded(
                            child: Container(
                              height: 6,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Stack(children: [
                              //YOANE
                              SvgPicture.asset(
                                'assets/suivi/man.svg',
                                color: Color(0xFF9CA4AB),
                              )
                              // width: 200, // spécifiez la largeur si nécessaire
                            ]),
                          ),
                          Expanded(
                            child: Container(
                              height: 6,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF9CA4AB),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Stack(children: [
                              //YOANE
                              SvgPicture.asset(
                                'assets/suivi/done.svg',
                                color: Color(0xFF9CA4AB),
                              )
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your order is being notified to the restaurant',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Abel',
                        fontWeight: FontWeight.w400,
                        height: 0.10,
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
} */

_phoneCall(String phoneNumber) async {
  // Nettoyer le numéro de téléphone en supprimant tous les caractères non numériques
  String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

  // Vérifier si le numéro de téléphone nettoyé est valide
  if (cleanedPhoneNumber.isNotEmpty) {
    await launch('tel:$cleanedPhoneNumber');
  } else {
    throw 'Numéro de téléphone invalide';
  }
}
