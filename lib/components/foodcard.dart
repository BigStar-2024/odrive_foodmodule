import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../backend/api.dart';
import '../backend/api_calls.dart';
import '../pages/food/food.dart';
import '../themes/theme.dart';
import '../widget/haversine.dart';

/*
* FoodCard
* */
class FoodCard extends StatefulWidget {
  final String name;
  final String image;
  final String price;
  final String discountPrice;
  final String restaurantName;
  final String restaurantLat;
  final String restaurantLng;
  final double latitude;
  final double longitude;
  final double largeur;
  final int id;
  final dynamic data;
  final String taxe;
  final dynamic favoriteData;
  // Ajoutez cette ligne pour déclarer le membre updateItemCount
  final VoidCallback? updateItemCount;

  FoodCard(
      {required this.name,
        required this.image,
        required this.price,
        required this.discountPrice,
        required this.restaurantName,
        required this.restaurantLat,
        required this.restaurantLng,
        required this.latitude,
        required this.longitude,
        required this.largeur,
        required this.id,
        required this.data,
        required this.taxe,
        required this.favoriteData,
        this.updateItemCount});
  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isFavorite = false;

  bool isFoodIdExist(idToCheck, favoriteData) {
    print(favoriteData);
    // Obtenez la liste des aliments dans favoriteData
    if (favoriteData.containsKey("food")) {
      List<dynamic> foodList = favoriteData["food"];

      // Parcourez la liste des aliments
      for (var food in foodList) {
        // Vérifiez si l'ID correspond
        if (food["id"] == idToCheck) {
          setState(() {
            isFavorite = true;
          });
          return true; // L'ID correspond à un aliment existant
        }
      }
    }

    return false; // Aucun aliment n'a été trouvé avec cet ID
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Calcul du pourcentage d'escompte
    double discountPercentage =
        ((double.parse(widget.price) - double.parse(widget.discountPrice)) /
            double.parse(widget.price)) *
            100;
    double distance = Haversine.calculateDistance(
        double.parse(widget.restaurantLat),
        double.parse(widget.restaurantLng),
        widget.latitude,
        widget.longitude);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FoodScreen(
                    id_food: widget.id, taxe: widget.taxe, data: widget.data)),
          ).then((toastMessage) {
            widget.updateItemCount?.call();

            print(
                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            print(toastMessage);
            setState(() {});
            if (toastMessage == "Plat ajouter au panier") {
              Fluttertoast.showToast(
                msg: toastMessage,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        },
        child: Card(
          margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Image.network(
                      '$serverImages${widget.image}',
                      width: widget.largeur,
                      height: (size.height * 0.25) * 0.58,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: (size.height * 0.25) * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.name,
                            style: text18GreyScale900,
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${distance.toStringAsFixed(0)} km |',
                                    style: text10GrayScale70,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  Text(
                                    '1.8 (1.2k)',
                                    style: text10GrayScale70,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  //SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () async {
                                      // Action à effectuer lorsqu'on clique sur l'icône de cœur
                                      setState(() {
                                        isFavorite =
                                        !isFavorite; // Inverse l'état du favori
                                      });
                                      if (isFavorite) {
                                        var response =
                                        await addFavorite(widget.id);
                                        if (response["error"] == "0") {
                                          Fluttertoast.showToast(
                                              msg: "Plat ajouté au favorie");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Une erreur s'est produite");
                                        }
                                      } else {
                                        var response =
                                        await deleteFavorite(widget.id);
                                        if (response["error"] == "0") {
                                          Fluttertoast.showToast(
                                              msg:
                                              "Plat supprimé des favories");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Une erreur s'est produite");
                                        }
                                      }
                                    },
                                    child: Icon(
                                      isFoodIdExist(
                                          widget.id, widget.favoriteData)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: heartColor,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          double.parse(widget.discountPrice).toInt() != 0
                              ? Flexible(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\F${double.parse(widget.price).toInt()}', // Prix barré
                                  style: TextStyle(
                                      decoration:
                                      TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 11),
                                ),
                                SizedBox(width: 4),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  // decoration: BoxDecoration(
                                  //   color: secondaryColor,
                                  //   borderRadius:
                                  //       BorderRadius.circular(8),
                                  // ),
                                  child: Text(
                                    '\F${double.parse(widget.discountPrice).toInt()}', // Prix réduit
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  //padding: EdgeInsets.all(4),
                                  // decoration: BoxDecoration(
                                  //   color: secondaryColor,
                                  //   borderRadius:
                                  //       BorderRadius.circular(8),
                                  // ),
                                  child: Text(
                                    '\F${double.parse(widget.price).toInt()}', // Prix réduit
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              double.parse(widget.discountPrice).toInt() != 0
                  ? Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${discountPercentage.toStringAsFixed(0)}% de réduction',
                    style: text10White,
                  ),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

/*
 * HorizontalCardList
 */
class HorizontalCardList extends StatelessWidget {
  List<dynamic> promotionData;
  double latitude;
  double longitude;
  String taxe;
  dynamic favoriteData;
  // Ajoutez cette ligne pour déclarer le membre updateItemCount
  final VoidCallback? updateItemCount;

  HorizontalCardList(
      {required this.promotionData,
        required this.latitude,
        required this.longitude,
        required this.taxe,
        required this.favoriteData,
        this.updateItemCount});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(promotionData);
    // Exemple de données de plats (à remplacer par vos propres données)

    return Container(
      height: size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: promotionData.length,
        itemBuilder: (context, index) {
          return Container(
            width: size.width * 0.5, // Ajustez la largeur selon vos besoins
            margin: EdgeInsets.symmetric(
                horizontal: 5), // Ajoutez une marge entre les cartes
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: FoodCard(
                name: promotionData[index]['name']!,
                image: promotionData[index]['image']!,
                price: promotionData[index]['price']!,
                discountPrice: promotionData[index]['discountprice']!,
                restaurantName: promotionData[index]['restaurant_name']!,
                restaurantLat: promotionData[index]['lat']!,
                restaurantLng: promotionData[index]['lng']!,
                longitude: longitude,
                latitude: latitude,
                largeur: 250,
                id: promotionData[index]['id']!,
                data: promotionData[index],
                taxe: taxe,
                favoriteData: favoriteData,
                updateItemCount: updateItemCount,
              ),
            ),
          );
        },
      ),
    );
  }
}

/*
*  VerticalCardList
* */
class VerticalCardList extends StatelessWidget {
  List<dynamic> promotionData;
  double latitude;
  double longitude;
  String taxe;
  dynamic favoriteData;

  VerticalCardList(
      {required this.promotionData,
        required this.latitude,
        required this.longitude,
        required this.taxe,
        required this.favoriteData});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(promotionData);
    // Exemple de données de plats (à remplacer par vos propres données)

    return Container(
      height: size.height / 3,
      child: ListView.builder(
        //scrollDirection: Axis.vertical,
        itemCount: promotionData.length,
        itemBuilder: (context, index) {
          return Container(
            width: 250, // Ajustez la largeur selon vos besoins
            margin: EdgeInsets.symmetric(
                horizontal: 8), // Ajoutez une marge entre les cartes
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: FoodCard(
                name: promotionData[index]['name']!,
                image: promotionData[index]['image']!,
                price: promotionData[index]['price']!,
                discountPrice: promotionData[index]['discountprice']!,
                restaurantName: promotionData[index]['restaurant_name']!,
                restaurantLat: promotionData[index]['lat']!,
                restaurantLng: promotionData[index]['lng']!,
                longitude: longitude,
                latitude: latitude,
                largeur: 250,
                id: promotionData[index]['id']!,
                data: promotionData,
                taxe: taxe,
                favoriteData: favoriteData,
              ),
            ),
          );
        },
      ),
    );
  }
}