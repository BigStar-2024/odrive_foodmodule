import 'package:flutter/material.dart';

import '../backend/api.dart';
import '../pages/restaurant/restaurant.dart';
import '../themes/theme.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String image;
  final String address;
  final double distance;
  final int id_restaurant;
  final double lat;
  final double lng;
  final String taxe;
  final VoidCallback? updateItemCount;

  RestaurantCard(
      {required this.name,
        required this.image,
        required this.distance,
        required this.id_restaurant,
        required this.address,
        required this.lat,
        required this.lng,
        required this.taxe,
        this.updateItemCount});

  @override
  Widget build(BuildContext context) {
    // Calcul du pourcentage d'escompte
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        print("<<<<<<<<<object>>>>>>>>>");
        print(id_restaurant);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RestaurantScreen(
                  id_restaurant: id_restaurant,
                  latitude: lat,
                  longitude: lng,
                  taxe: taxe)),
        ).then((value) {
          updateItemCount?.call();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        child: Card(
          margin: EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Image.network(
                      '$serverImages$image',
                      width: 250,
                      height: size.height * 0.25 * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(child:
                  Container(
                    padding: const EdgeInsets.all(8.0),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: text18GreyScale900,
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: greyScale80Color,
                                  size: 16  ,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  address,
                                  style: text14GrayScale70,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalRestaurantCardList extends StatelessWidget {
  List<dynamic> restoData;
  final double lat;
  final double lng;
  final String taxe;
  // Ajoutez cette ligne pour déclarer le membre updateItemCount
  final VoidCallback? updateItemCount;

  HorizontalRestaurantCardList(
      {required this.restoData,
        required this.lat,
        required this.lng,
        required this.taxe,
        this.updateItemCount});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Exemple de données de plats (à remplacer par vos propres données)

    return Container(
      height: size.height / 4,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: restoData.length,
        itemBuilder: (context, index) {
          return Container(
            width: 250, // Ajustez la largeur selon vos besoins
            margin: EdgeInsets.symmetric(
                horizontal: 8), // Ajoutez une marge entre les cartes
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: RestaurantCard(
                name: restoData[index]['name']!,
                image: restoData[index]['image']!,
                distance: restoData[index]['distance']!,
                id_restaurant: restoData[index]['id'],
                address: restoData[index]['address'],
                lat: lat,
                lng: lng,
                taxe: taxe,
                updateItemCount: updateItemCount,
              ),
            ),
          );
        },
      ),
    );
  }
}