import 'package:flutter/material.dart';

import '../backend/api.dart';
import '../pages/categories/categorie_list.dart';

/*
* Categories
* */
class Categories extends StatelessWidget {
  final List<dynamic> categorieList;

  Categories({required this.categorieList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Alignez à gauche
            children: [
              for (int i = 0; i < 4; i++)
                if (i < categorieList.length)
                  ImageCard(
                    name: categorieList[i]['name'],
                    image: categorieList[i]['image'],
                    fromAsset: false,
                  ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Alignez à gauche
            children: [
              for (int i = 4; i < 7; i++)
                if (i < categorieList.length)
                  ImageCard(
                    name: categorieList[i]['name'],
                    image: categorieList[i]['image'],
                    fromAsset: false,
                  ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategorieListScreen(
                            categorieList: categorieList,
                          )));
                },
                child: ImageCard(
                    name: "Autre",
                    image: "assets/home/autre.png",
                    fromAsset: true),
              )
            ],
          ),
        ],
      ),
    );
  }
}

/*
*  ImageCard
* */
class ImageCard extends StatelessWidget {
  final String name;
  final String image;
  final bool fromAsset;

  ImageCard({required this.name, required this.image, required this.fromAsset});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        !fromAsset
            ? Image.network(
          "$serverImages$image",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
            : Image.asset(
          image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

/*
*  AllCategories
* */

class AllCategories extends StatelessWidget {
  final List<dynamic> categorieList;

  AllCategories({required this.categorieList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 4,
        children: categorieList.map((category) {
          return ImageCard(
            name: category['name'],
            image: category['image'],
            fromAsset: false,
          );
        }).toList(),
      ),
    );
  }
}