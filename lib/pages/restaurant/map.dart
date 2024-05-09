import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:http/http.dart' as http;

class RestaurantMap extends StatelessWidget {
  final List<dynamic> restaurants;
  final double defaultLat;
  final double defaultLng;
  final double defaultZoom;

  RestaurantMap(
      {required this.restaurants,
      required this.defaultLat,
      required this.defaultLng,
      required this.defaultZoom});

  Future<BitmapDescriptor> marqueurFromUrl(url) async {
    var iconurl = Uri.parse('$serverImages$url');
    var dataBytes;
    var request = await http.get(iconurl);
    var bytes = request.bodyBytes;
    dataBytes = bytes;

    var result = BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List(),
        size: Size(10, 10));

    return result;
  }

  Future<Set<Marker>> _createMarkers() async {
    List<Marker> markers = [];
    for (var restaurant in restaurants) {
      // Création d'un marqueur pour chaque restaurant
      var marker = Marker(
        markerId: MarkerId(restaurant['name']),
        position: LatLng(
            double.parse(restaurant['lat']), double.parse(restaurant['lng'])),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)),
            'assets/test/restaurant_logo.png'), // Appel asynchrone de la fonction pour obtenir l'icône du marqueur
        infoWindow: InfoWindow(
          title: restaurant['name'],
          snippet: restaurant['address'],
        ),
      );
      markers.add(marker);
    }
    return markers
        .toSet(); // Conversion de la liste de marqueurs en un ensemble de marqueurs
  }

  GoogleMapController? _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titleText: "Localisation des restaurants"),
      body: FutureBuilder(
        future: _createMarkers(), // Appel de la fonction asynchrone
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affichage d'un indicateur de chargement en attendant que les marqueurs soient créés
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Affichage d'un message d'erreur s'il y a eu un problème lors de la création des marqueurs
            return Center(child: Text('Une erreur s\'est produite'));
          } else {
            // Affichage de la carte GoogleMap une fois que les marqueurs sont prêts
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(defaultLat, defaultLng),
                zoom: defaultZoom,
              ),
              markers: snapshot.data as Set<Marker>,
              // Utilisation des marqueurs créés
            );
          }
        },
      ),
    );
  }
}
