
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odrive/constante/utils.dart';
import 'package:odrive/pages/address/addaddress.dart';
import 'package:odrive/pages/wallet/addwallet.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../themes/theme.dart';

class AddressScreen extends StatefulWidget
{
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}
class _AddressScreenState extends State<AddressScreen>
{

  bool isExistAddress = false;
  List<dynamic> address = [
    {
      'name': 'John galliano',
      'phone': '+1 3712 3789',
      'address': 'NYC, Broadway ave 79'
    },
    {
      'name': 'John galliano',
      'phone': '+1 3712 3789',
      'address': 'NYC, Broadway ave 79'
    },
    {
      'name': 'John galliano',
      'phone': '+1 3712 3789',
      'address': 'NYC, Broadway ave 79'
    },
  ];

  int selectedCardIndex = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AddressAppBar(titleText: "Address"),
        body:
          isExistAddress ? Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/paiement/wallet.png",
                          ),
                          SizedBox(height: 24.0),
                          Text(
                            "For your own safety",
                            style: text18GreyScale100,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            "For your information safety when setting up Yummy wallet of Yummyfood app, please read and agree to Terms and Policies. ",
                            style: text16GrayScale100,
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              Container(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => AddAddressScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: size.width - size.width / 5,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryColor
                    ),
                    child: Center(
                      child: Text(
                        'Add address',
                        style: text16White,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ) : Container(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: ListView.builder(
              itemCount: address.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    setState(() {
                      selectedCardIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: greyScale50Color, // Choose the color you want for the border
                          width: 1.0, // Adjust the width of the border
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(address[index]['name'], style: text18GreyScale100),
                                SizedBox(height: 8.0),
                                Text(address[index]['phone'], style: text14GrayScale70),
                                SizedBox(height: 8.0),
                                Text(address[index]['address'], style: text14GrayScale70),
                                SizedBox(height: 8.0),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => AddAddressScreen(),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: primaryColor
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Change',
                                        style: text14GreyScale20,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.0)
                              ],
                            ),
                            SizedBox(height: 12.0),
                          ],
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Radio<int>(
                            value: index,
                            groupValue: selectedCardIndex,
                            onChanged: (value) {
                              setState(() {
                                selectedCardIndex = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            )
          )
    );
  }
}

class AddressAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  AddressAppBar({required this.titleText});
  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 3,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: greyScale90Color),
        onPressed: () {
          // Action à effectuer lorsqu'on appuie sur la flèche de retour
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        titleText,
        style: text20GrayScale100,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: Colors.black),
          tooltip: "Add address",
          onPressed: (){
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => AddAddressScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}