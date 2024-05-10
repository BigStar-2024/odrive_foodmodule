import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/components/roundedinput.dart';
import 'package:odrive/constante/utils.dart';
import 'package:odrive/pages/map/map.dart';
import 'package:odrive/pages/paiement/paiement.dart';
import 'package:odrive/themes/theme.dart';
import 'package:odrive/widget/haversine.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import '../../components/appbar.dart';
import '../../components/dashedborderpainter.dart';

class CommandeConfirmScreen extends StatefulWidget {
  int order_id;
  int user_id;
  CommandeConfirmScreen({super.key, required this.order_id, required this.user_id});

  @override
  State<CommandeConfirmScreen> createState() => _CommandeConfirmScreenState();
}

class _CommandeConfirmScreenState extends State<CommandeConfirmScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleText: 'Commande Confirmation',
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please scan the QR code", style: Theme.of(context).textTheme.displaySmall),
                SizedBox(height: 16),
                Text("(For Delivery Boy)", style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 48),
                Container(
                  width: 300,
                  height: 300,
                  padding: EdgeInsets.all(4),
                  child: CustomPaint(
                    painter: DashedBorderPainter(),
                    child: Center(
                      child: PrettyQr(
                        data: "${widget.order_id}_${widget.user_id}",
                        size: 250,
                        elementColor: Colors.black,
                        errorCorrectLevel: QrErrorCorrectLevel.L,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text("QR code will be updated every 60s", style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 18.0
                )),
                SizedBox(height: 12),
                Text("or", style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 18.0
                )),
                SizedBox(height: 24),
                Text("Delivery Code: Odrive#${widget.order_id}_${widget.user_id}", style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 16),
                Text("Give this code to the delivery boy",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 20.0
                    )
                ),

              ],
            ),
          )
        ],
      )
    );
  }
}