import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/home/home.dart';

import '../../components/appbar.dart';
import '../../components/imagecard.dart';

class CategorieListScreen extends StatefulWidget {
  List<dynamic> categorieList;
  CategorieListScreen({required this.categorieList});

  @override
  State<CategorieListScreen> createState() => _CategorieListScreenState();
}

class _CategorieListScreenState extends State<CategorieListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titleText: 'Catégories'),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: AllCategories(categorieList: widget.categorieList),
      ),
    );
  }
}
