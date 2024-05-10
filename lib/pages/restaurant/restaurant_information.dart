import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:odrive/pages/auth/login.dart';

import '../../components/appbar.dart';
import '../../themes/theme.dart';

class RestaurantInformationScreen extends StatefulWidget {
  dynamic restaurant;
  RestaurantInformationScreen({required this.restaurant});

  @override
  State<RestaurantInformationScreen> createState() =>
      _RestaurantInformationScreenState();
}

class _RestaurantInformationScreenState
    extends State<RestaurantInformationScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  Widget _buildDayOpeningHours(String day, Map<String, dynamic> restaurant) {
    // Obtenir les heures d'ouverture pour le jour spécifié
    String openTime = restaurant['openTime$day'];
    String closeTime = restaurant['closeTime$day'];

    // Vérifier si le restaurant est fermé ce jour-là
    bool closed = openTime.isEmpty || closeTime.isEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 180,
          child: Text(
            day,
            style: TextStyle(
              color: Color(0xFF171725),
              fontSize: 16,
              fontFamily: 'Abel',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 25,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ':',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 18,
                  fontFamily: 'Urbanist',
                  letterSpacing: 0.20,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 99,
                child: Text(
                  closed ? 'Fermé' : '$openTime - $closeTime',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: closed ? Colors.red : Color(0xFF03443C),
                    fontSize: 16,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  googleMap() {
    /* setState(()  {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      adress = prefs.getString("myAdresse") ?? "";
      lat = prefs.getString("myLatitude") ?? "";
      lng = prefs.getString("myLongitude") ?? "";
    }); */

    return GoogleMap(
      zoomControlsEnabled: false,
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(
        //target: LatLng(double.parse(lat), double.parse(lng)),
        target: LatLng(double.parse(widget.restaurant["lat"]),
            double.parse(widget.restaurant["lng"])),
        zoom: 18.0,
      ),
      onMapCreated: mapCreated,
      //markers: Set.from(allMarkers),
      markers: _markers,
    );
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

  String shortenLocationName(String locationName, int maxLength) {
    if (locationName.length <= maxLength) {
      return locationName;
    } else {
      return locationName.substring(0, maxLength - 3) + '...';
    }
  }

  addMarker() async {
    /* SharedPreferences prefs = await SharedPreferences.getInstance();
    adress = prefs.getString("myAdresse") ?? "";
    lat = prefs.getString("myLatitude") ?? "";
    lng = prefs.getString("myLongitude") ?? "";
    print(adress);
    print(lat);
    print(lng); */
    /* final Uint8List markerIcon =
        await getMarkerIcon('assets/test/House_icon.png', 50); */
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/test/House_icon.png');
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId("lieu_restaurant"),
            position: LatLng(double.parse(widget.restaurant["lat"]),
                double.parse(widget.restaurant["lng"])),
            //icon: BitmapDescriptor.fromBytes(markerIcon),
            icon: icon),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titleText: "Information du restaurant"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                height: 250.0, // Hauteur fixe de la carte
                child: googleMap(),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: greyScale80Color,
                          size: 24  ,
                        ),
                        SizedBox(width: 2),
                        Text(shortenLocationName(
                            widget.restaurant["address"], 25))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 20, // hauteur de la ligne
                thickness: 1, // épaisseur de la ligne
                color: Color(0xFFBFC6CC), // couleur de la ligne
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Nous concernant',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16,
                      fontFamily: 'Abel',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.restaurant["desc"]}',
                          style: TextStyle(
                            color: Color(0xFF424242),
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
              SizedBox(
                height: 15,
              ),
              Divider(
                height: 20, // hauteur de la ligne
                thickness: 1, // épaisseur de la ligne
                color: Color(0xFFBFC6CC), // couleur de la ligne
              ),
              Container(
                child: Column(
                  children: [
                    _buildDayOpeningHours('Monday', widget.restaurant),
                    _buildDayOpeningHours('Tuesday', widget.restaurant),
                    _buildDayOpeningHours('Wednesday', widget.restaurant),
                    _buildDayOpeningHours('Thursday', widget.restaurant),
                    _buildDayOpeningHours('Friday', widget.restaurant),
                    _buildDayOpeningHours('Saturday', widget.restaurant),
                    _buildDayOpeningHours('Sunday', widget.restaurant),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                height: 20, // hauteur de la ligne
                thickness: 1, // épaisseur de la ligne
                color: Color(0xFFBFC6CC), // couleur de la ligne
              ),
              Container(
                /* width: 327,
                height: 24, */
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        'Numéro du restaurant',
                        style: TextStyle(
                          color: Color(0xFF171725),
                          fontSize: 16,
                          fontFamily: 'Abel',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 143),
                    SizedBox(
                      child: Text(
                        '${widget.restaurant["phone"]}',
                        style: TextStyle(
                          color: Color(0xFF03443C),
                          fontSize: 16,
                          fontFamily: 'Abel',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
