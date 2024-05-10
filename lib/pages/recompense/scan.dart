import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/appbar.dart';

class ScanScreen extends StatefulWidget {
  String uuid;
  int pointTransfert;
  ScanScreen({super.key, required this.uuid, required this.pointTransfert});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // Gérer les données du scan ici, par exemple :
      controller.dispose();

      print('QR Code scanné : ${scanData.code}');
      if (widget.pointTransfert > 0) {
        var response =
            await sharePoint(scanData.code, widget.pointTransfert, widget.uuid);
        print(response);
        if (response["error"] == "0") {
          Navigator.pop(context, "Point transféré");
        } else if (response["error"] == "1") {
          Navigator.pop(context, "Point insuffisant");
        } else {
          Navigator.pop(context, "Une erreur s'est produite");
        }
      } else {
        Navigator.pop(context, "");
      }

      // Vous pouvez appeler une fonction ou effectuer une action en fonction du code scanné
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titleText: "Scan Qr"),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          // Autres éléments de l'interface utilisateur, si nécessaire
        ],
      ),
    );
  }
}
