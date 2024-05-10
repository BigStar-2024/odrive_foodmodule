
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odrive/constante/utils.dart';
import 'package:odrive/pages/wallet/addwallet.dart';

import '../../components/appbar.dart';
import '../../components/roundedinput.dart';
import '../../localization/Language/languages.dart';
import '../../themes/theme.dart';

class WalletScreen extends StatefulWidget
{
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}
class _WalletScreenState extends State<WalletScreen>
{

  bool isExistWallet = false;
  List<dynamic> wallets = [
    {
      'cardnumber': '4444444444444444',
      'bank': 'Bank Central Asia',
      'title': 'BCA'
    },
    {
      'cardnumber': '1234123412341234',
      'bank': 'Bank Central Asia',
      'title': 'BCA'
    },
    {
      'cardnumber': '5555555555555555',
      'bank': 'Bank Central Asia',
      'title': 'BCA'
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
        appBar: WalletAppBar(titleText: "Wallet"),
        body:
          isExistWallet ? Container(
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
                        pageBuilder: (context, animation, secondaryAnimation) => AddWalletScreen(),
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
                        'Setup Yummy wallet',
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
              itemCount: wallets.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    setState(() {
                      selectedCardIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                            SvgPicture.asset("assets/paiement/visa.svg", color: Colors.blue, height: 16),
                            SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${wallets[index]['title']}(${wallets[index]['bank']})', style: text18GreyScale100),
                                SizedBox(height: 8.0),
                                Text(maskHiddenString(wallets[index]['cardnumber']), style: text14GrayScale70),
                              ],
                            ),
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

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  WalletAppBar({required this.titleText});
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
          tooltip: "Add wallet",
          onPressed: (){
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => AddWalletScreen(),
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