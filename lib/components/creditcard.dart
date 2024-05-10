import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odrive/themes/theme.dart';

class CreditCard extends StatefulWidget {
  final String cardnumber;
  final String expire;
  final String cvv;

  CreditCard(
    {
      required this.cardnumber,
      required this.expire,
      required this.cvv
    }
  );

  @override
  _CreditCardState createState() {
    return _CreditCardState();
  }
}

class _CreditCardState extends State<CreditCard> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return widget.cardnumber != "" ?
      Card(
          elevation: 3,
          color: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset("assets/paiement/visa.svg"),
                  ],
                ),
                SizedBox(height: 60),
                Text(
                  "4444 4444 4444 4444", style: text32White,
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("CVV", style: text16White),
                        Text("***", style: text16White)
                      ],
                    ),
                    Column(
                      children: [
                        Text("EXPIRES", style: text16White),
                        Text("08/27", style: text16White)
                      ],
                    )
                  ],
                )
              ],
            ),
          )
      )
        : Card(
        elevation: 3,
        color: greyColor900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/paiement/addresscard.svg"),
                  SizedBox(width: 12.0),
                  SvgPicture.asset("assets/paiement/mastercard.svg"),
                  SizedBox(width: 12.0),
                  SvgPicture.asset("assets/paiement/credit.svg"),
                ],
              ),
              SizedBox(height: 40),
              Text(
                "Add credit or debit card", style: text18Neutral,
              ),
              SizedBox(height: 32.0),
            ],
          ),
        )
    );
  }
}