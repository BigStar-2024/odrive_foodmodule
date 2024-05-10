import 'package:flutter/cupertino.dart';

import '../themes/theme.dart';

/*
* EventCard
* */

class EventCard extends StatelessWidget {
  final String description;
  final String image;
  final String restaurant;

  EventCard({
    required this.description,
    required this.image,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Calcul du pourcentage d'escompte

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0), bottom: Radius.circular(8.0)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.0), bottom: Radius.circular(8.0)),
                child: Image.asset(
                  'assets/test/$image',
                  width: size.width,
                  height: size.height / 4,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '${description}',
                    style: TextStyle(
                        fontSize: 25, color: whiteColor, fontFamily: "Abel"),
                  ),
                ),
                Container(
                  child: Text(
                    '${restaurant}',
                    style: TextStyle(
                        fontSize: 25, color: whiteColor, fontFamily: "Abel"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: whiteColor),
                  child: Center(
                    child: Text(
                      'Découvrir',
                      style: text16Primary,
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

/*
* HorizontalEventList
* */
class HorizontalEventList extends StatelessWidget {
  List<dynamic> eventData;
  HorizontalEventList({required this.eventData});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Exemple de données de plats (à remplacer par vos propres données)

    return Container(
      height: size.height / 4,
      //width: size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: eventData.length,
        itemBuilder: (context, index) {
          return Container(
            width: size.width, // Ajustez la largeur selon vos besoins
            height: size.height / 4,
            margin: EdgeInsets.symmetric(
                horizontal: 8), // Ajoutez une marge entre les cartes
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8.0), bottom: Radius.circular(8.0)),
              child: EventCard(
                description: eventData[index]['description']!,
                image: eventData[index]['image']!,
                restaurant: eventData[index]['restaurant']!,
              ),
            ),
          );
        },
      ),
    );
  }
}