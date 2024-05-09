import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:odrive/constante/const.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kGoogleApiKey = googleApiKey;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  final LatLng _center = const LatLng(45.521563, -122.677433);
  TextEditingController _searchController = TextEditingController();
  String lieu_livraison = "";
  String latitude = "0.0";
  String longitude = "0.0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleText: "Lieu de livraison",
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: _markers,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: PlacesAutocompleteField(
                controller: _searchController,
                apiKey: googleApiKey,
                onChanged: (value) {
                  //_widgetPlaceName = value!;
                },
                onSelected: (value) async {
                  // Handle selected place
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  print("valeur-------------");
                  setState(() {
                    lieu_livraison = value.description!;
                  });
                  print(lieu_livraison);
                  PlacesDetailsResponse detail =
                      await GoogleMapsPlaces(apiKey: kGoogleApiKey)
                          .getDetailsByPlaceId(value.placeId!);

                  double lat = detail.result.geometry!.location.lat;
                  double lng = detail.result.geometry!.location.lng;

                  LatLng selectedLatLng = LatLng(lat, lng);

                  setState(() {
                    lieu_livraison = value.description!;
                    latitude = lat.toString();
                    longitude = lng.toString();
                  });
                  prefs.setString("myAdresse", lieu_livraison);
                  prefs.setString("myLatitude", lat.toString());
                  prefs.setString("myLongitude", lng.toString());

                  _controller!
                      .animateCamera(CameraUpdate.newLatLng(selectedLatLng));
                  _addMarker(selectedLatLng, 'Initial Position');
                },
                hint: "Lieu de livraison",
                inputDecoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                mode: Mode.overlay,
                language: "fr",
                components: [Component(Component.country, "ci")],
                strictbounds: false,
                types: [],
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context, {
                  "lat": latitude,
                  "lng": longitude,
                  "lieu": lieu_livraison
                });
              },
              child: Icon(Icons.check),
              backgroundColor: successColor,
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _addMarker(_center, 'Initial Position');
  }

  void _addMarker(LatLng position, String id) {
    setState(() {
      _markers
          .removeWhere((marker) => marker.markerId.value == 'Initial Position');
      _markers.add(
        Marker(
          markerId: MarkerId(id),
          position: position,
        ),
      );
    });
  }
}
