import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odrive/backend/api.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/auth/login.dart';
import 'package:odrive/pages/panier/panier.dart';
import 'package:odrive/pages/suivieLivreur/suivieLivreur.dart';
import 'package:odrive/themes/theme.dart';
import 'package:odrive/widget/haversine.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter/material.dart' show AssetImage;

class SuivieScreen extends StatefulWidget {
  int order_id;
  SuivieScreen({super.key, required this.order_id});

  @override
  State<SuivieScreen> createState() => _SuivieScreenState();
}

class _SuivieScreenState extends State<SuivieScreen> {
  dynamic orderDetail = {
    "fee": "0.0",
    "default_tax": "150.0",
    "order": {"method": ""}
  };
  List<dynamic> orderDetails = [];
  dynamic orderDetailData;
  String subTotal = "";
  bool _loading = false;
  String excedant = "0.0";
  double distance = 0.0;
  double totalCom = 0;
  int status = 1;
  int driver_id = 0;
  dynamic reduction;

  Future<String> generateReceipt_old() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customerName = prefs.getString("userName") ?? "";
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => _buildReceiptContent(customerName),
      ),
    );

    var directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    // Obtenez le chemin du répertoire de téléchargement
    //final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/reçu.pdf';
    print("filePath-----------------");
    print(filePath);

    // Enregistrez le PDF dans le répertoire de téléchargement
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Renvoie le chemin du fichier PDF
    return filePath;
  }

  pw.Widget _buildReceiptContent(customerName) {
    return pw.ListView(
      children: [
        pw.Container(
          padding: pw.EdgeInsets.only(bottom: 20),
          alignment: pw.Alignment.center,
          child: pw.Text("O'drive",
              style: pw.TextStyle(color: PdfColors.green, fontSize: 30)),
        ),
        pw.Container(
            height: 1.0,
            width: 600.0,
            color: PdfColors.red,
            margin: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
        pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              /* pw.Container(
                          margin: pw.EdgeInsets.all(10),
                          child: pw.Image(logoImage)), */
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      child: pw.Text("${orderDetail["restaurant"]["name"]}",
                          style: pw.TextStyle(color: PdfColors.green)),
                    ),
                    pw.Container(
                      child: pw.Text(
                          "${orderDetail["restaurant"]["address"]}\n${orderDetail["restaurant"]["phone"]}"),
                    ),
                  ]),
              pw.SizedBox(height: 30, width: 30),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(height: 30),
                    pw.Container(child: pw.Text("")),
                    pw.Container(child: pw.Text("")),
                    pw.Container(child: pw.Text("")),
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(height: 30),
                    pw.Container(child: pw.Text("             ")),
                    pw.Container(child: pw.Text("       ")),
                    pw.Container(child: pw.Text("          ")),
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.SizedBox(height: 30),
                    pw.Container(child: pw.Text("Date")),
                    pw.Container(child: pw.Text("No.")),
                    pw.Container(child: pw.Text("         ")),
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.SizedBox(height: 30),
                    pw.Container(
                        child:
                            pw.Text("${orderDetail["order"]["updated_at"]}")),
                    pw.Container(child: pw.Text("BNMK_2020_18")),
                    pw.Container(child: pw.Text("")),
                  ]),
            ]),
        // //Create a line
        pw.Container(
            height: 1.0,
            width: 600.0,
            color: PdfColors.purple,
            margin: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),

        pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(child: pw.Text("Nom du client")),
                    pw.Container(child: pw.Text(customerName)),
                    pw.SizedBox(width: 20, height: 20),
                    pw.Container(child: pw.Text("           ")),
                    pw.Container(child: pw.Text("              ")),
                  ]),
              /* pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(child: pw.Text("Billing Address")),
                    pw.Container(
                        child: pw.FittedBox(
                            fit: pw.BoxFit.fitWidth,
                            child: pw.Text("name \naddress \nIndia"))),
                  ]), */
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(child: pw.Text("Address de livraison")),
                    pw.Container(
                        child: pw.Text("${orderDetail["order"]["address"]}")),
                  ]),
            ]),
        pw.Container(
            height: 1.0,
            width: 600.0,
            color: PdfColors.red,
            margin: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
        pw.Container(
            alignment: pw.Alignment.centerLeft,
            padding: pw.EdgeInsets.all(5),
            child: pw.Text("Nombre de plat: ${orderDetails.length} ")),
        pw.Container(
            height: 1.0,
            width: 600.0,
            color: PdfColors.red,
            margin: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
        pw.Container(
          color: PdfColors.yellow200,
          padding: pw.EdgeInsets.all(20),
          child: pw.Table(
              /* border: TableBorder(
                          horizontalInside: true,
                          top: true,
                          bottom: true,
                          verticalInside: false,
                          left: false,
                          right: false), */
              tableWidth: pw.TableWidth.max,
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.TableRow(children: [
                  pw.Container(child: pw.Text("Plat")),
                  pw.Container(child: pw.Text("Qty")),
                  pw.Container(child: pw.Text("Prix")),
                ]),
                for (var item in orderDetails)
                  pw.TableRow(children: [
                    pw.Container(child: pw.Text("${item.name}")),
                    pw.Container(child: pw.Text("${item.count}")),
                    pw.Container(child: pw.Text("${item.totalPrice} F")),
                  ]),
                /* pw.TableRow(children: [
                  pw.SizedBox(),
                  pw.Container(child: pw.Text("Total")),
                  pw.Container(child: pw.Text("1")),
                  pw.Container(child: pw.Text("4000.00")),
                  pw.Container(child: pw.Text("3280.00")),
                  pw.Container(child: pw.Text("720.00")),
                  pw.Container(child: pw.Text("4000.00")),
                ]), */
              ]),
        ),
        pw.Container(
            height: 1.0,
            width: 600.0,
            color: PdfColors.red,
            margin: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
        pw.Container(
          color: PdfColors.yellow200,
          padding: pw.EdgeInsets.all(20),
          child: pw.Table(
              /* border: TableBorder(
                          horizontalInside: true,
                          top: true,
                          bottom: true,
                          verticalInside: false,
                          left: false,
                          right: false), */
              tableWidth: pw.TableWidth.max,
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.TableRow(children: [
                  pw.Container(child: pw.Text("Frais")),
                  pw.Container(child: pw.Text("Montant")),
                ]),
                pw.TableRow(children: [
                  pw.Container(child: pw.Text("Frais de livraison")),
                  pw.Container(
                      child: pw.Text(
                          "${double.parse(orderDetail["fee"]).toStringAsFixed(0)} F")),
                ]),
                pw.TableRow(children: [
                  pw.Container(child: pw.Text("Frais de service")),
                  pw.Container(
                      child: pw.Text(
                          "${double.parse(orderDetail["default_tax"]).toStringAsFixed(0)} F")),
                ]),
                pw.TableRow(children: [
                  pw.Container(child: pw.Text("Frais de longue distance")),
                  pw.Container(
                      child: pw.Text(
                          "${double.parse(excedant).toStringAsFixed(0)} F")),
                ]),
                /* pw.TableRow(children: [
                  pw.SizedBox(),
                  pw.Container(child: pw.Text("Total")),
                  pw.Container(child: pw.Text("1")),
                  pw.Container(child: pw.Text("4000.00")),
                  pw.Container(child: pw.Text("3280.00")),
                  pw.Container(child: pw.Text("720.00")),
                  pw.Container(child: pw.Text("4000.00")),
                ]), */
              ]),
        ),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(child: pw.Text("Grand Total")),
                pw.SizedBox(width: 15),
                pw.Container(
                    child: pw.Text("${totalCom.toStringAsFixed(0)} F")),
              ]),
          pw.SizedBox(height: 15),
          /* pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(child: pw.Text("SNA SISTEC Pvt Ltd")),
                pw.Container(child: pw.PdfLogo()),
                pw.Container(child: pw.Text("Authorized Signatory")),
              ]) */
        ]),
        pw.Container(
            height: 1.0,
            width: 600.0,
            color: PdfColors.black,
            margin: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
        pw.Text("Terms and Condition Applied*")
      ],
    );
    /* return pw.Container(
      child: pw.Column(
        children: [
          pw.Text(
            '${orderDetail["restaurant"]["name"]}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          for (var item in orderDetails)
            pw.Text('${item.name}:        ${item.price}'),
          pw.SizedBox(height: 10),
          pw.Text(
              'Frais de livraison:        F ${double.parse(orderDetail["fee"]).toStringAsFixed(0)}'),
          pw.SizedBox(height: 10),
          pw.Text(
              'Frais de service:        F ${double.parse(orderDetail["default_tax"]).toStringAsFixed(0)}'),
          pw.SizedBox(height: 10),
          pw.Text(
              'Frais de longue distance:        F ${double.parse(excedant).toStringAsFixed(0)}'),
          pw.Text(
            'Total:        F ${totalCom.toStringAsFixed(0)}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    ); */
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var foodItem in orderDetails) {
      total += foodItem.totalPrice;
    }
    setState(() {
      subTotal = total.toString();
    });
    return total;
  }

  double calculateTotalReduction() {
    double totalReduction = 0;
    double totalSub = calculateTotalPrice();
    if (reduction != null) {
      if (reduction["inpercents"] == 1) {
        totalReduction =
            (double.parse(reduction["discount"]).toInt() * totalSub) / 100;
      } else {
        totalReduction = double.parse(reduction["discount"]);
      }

      return totalReduction;
    } else {
      return 0.0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getOrderState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("FirebaseMessaging.onMessage----- ${message.messageId}");
      print("Firebase messaging:onMessage: $message");
      print("Firebase message: ${message.data}");

      await getOrderState();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getOrderState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString("uuid") ?? "";
    var response = await getOrderDetails(uuid, widget.order_id);
    if (response['error'] == '0') {
      List<dynamic> ordertimes = response['data']['ordertimes'];
      setState(() {
        driver_id = response['data']['driver'];
        orderDetailData = response;
      });
      print(orderDetailData);

      if (ordertimes.isNotEmpty) {
        // Obtenez le dernier élément de la liste 'ordertimes'
        Map<String, dynamic> lastOrderTime = ordertimes.last;

        // Récupérez le statut du dernier objet dans 'ordertimes'
        int lastStatus = lastOrderTime['status'];
        print('Statut du dernier ordre : $lastStatus');
        setState(() {
          status = lastStatus;
        });
      } else {
        print('La liste ordertimes est vide.');
      }
    }
  }

  getData() async {
    setState(() {
      _loading = true;
    });
    await getOrderDetail();
    await getOrderState();
    setState(() {
      _loading = false;
    });
  }

  getOrderDetail() async {
    var response = await getOrderById(widget.order_id);
    if (response["error"] == "0") {
      setState(() {
        orderDetail = response;
        orderDetails = reformatOrderDetails(response["orderdetails"])
            .map((food) => FoodItem(
                name: food["food"],
                price: double.parse(food["foodprice"]).toInt(),
                id: food["id"],
                image: food["image"],
                count: food["count"],
                countExtras: food["extrascount"],
                desc: food["desc"],
                extras: food["extrasdata"]))
            .toList();
      });
      if (orderDetail["order"]["couponName"] != "" &&
          orderDetail["order"]["couponName"] != null) {
        var response_coupon =
            await getCouponByName(orderDetail["order"]["couponName"]);
        if (response_coupon["error"] == "0") {
          setState(() {
            reduction = response_coupon;
          });
        } else {
          Fluttertoast.showToast(msg: "Verifiez votre connexion");
        }
      }

      print(orderDetails);
      setState(() {
        distance = Haversine.calculateDistance(
            double.parse(orderDetail["restaurant"]["lat"]),
            double.parse(orderDetail["restaurant"]["lng"]),
            double.parse(orderDetail["order"]["lat"]),
            double.parse(orderDetail["order"]["lng"]));
      });
      if (distance > orderDetail["restaurant"]["area"]) {
        CalculateExcedant(distance);
      }
      calculateTotalCommande(
          calculateTotalPrice().toString(),
          orderDetail["fee"],
          orderDetail["default_tax"],
          calculateTotalReduction().toString());
    } else if (response["error"] == "1") {
      Fluttertoast.showToast(msg: response["message"]);
    } else {
      Fluttertoast.showToast(msg: response["error"]);
    }
  }

  void CalculateExcedant(distance) {
    double distanceEnPlus = distance - orderDetail["restaurant"]["area"];
    setState(() {
      excedant = (distanceEnPlus *
              double.parse(orderDetail["restaurant"]["fee_excedant"]))
          .toString();
    });
  }

  void calculateTotalCommande(subTotal, fee, feeService, subReduction) {
    print("excedant__________________________________-");
    print(excedant);
    double totalCommande = 0;
    totalCommande = double.parse(subTotal) -
        double.parse(subReduction) +
        double.parse(fee) +
        double.parse(feeService) +
        double.parse(excedant);
    setState(() {
      totalCom = totalCommande;
    });
    //return totalCommande;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print("ooooooooooooooooooooooooooooooooooooooooooooooo");
    print(widget.order_id);
    return Scaffold(
      appBar: MyAppBarSuivie(
        titleText: "Détail de la commande",
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                /* Text(
                  'Status',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Preparing',
                  style: TextStyle(
                    color: Color(0xFF434E58),
                    fontSize: 14,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.w400,
                  ),
                ), */
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, top: 15, bottom: 15),
                      child: Column(
                        children: [
                          Text(
                            'Status',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Abel',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            status == 1
                                ? 'Commande reçu'
                                : status == 2
                                    ? 'Préparation'
                                    : status == 9
                                        ? 'Livraison en cours'
                                        : status == 6
                                            ? 'Livrée'
                                            : '',
                            style: TextStyle(
                              color: Color(0xFF434E58),
                              fontSize: 14,
                              fontFamily: 'Abel',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    //width: 327,
                    //height: 24,
                    alignment: Alignment.center,
                    child: Column(
                      /*  mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start, */
                      children: [
                        Container(
                          child: Column(
                            /* mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start, */
                            children: [
                              Container(
                                width: 327,
                                child: Row(
                                  /* mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center, */
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            child: Stack(children: [
                                              SvgPicture.asset(
                                                'assets/suivi/order_receive.svg',
                                                color: status == 6 &&
                                                        driver_id == 0
                                                    ? redColor
                                                    : primaryColor,
                                                // width: 200, // spécifiez la largeur si nécessaire
                                                // height: 200, // spécifiez la hauteur si nécessaire
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 6,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status >= 2
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        SvgPicture.asset(
                                          'assets/suivi/preparing.svg',
                                          color: status >= 2
                                              ? status == 6 && driver_id == 0
                                                  ? redColor
                                                  : primaryColor
                                              : status == 6 && driver_id == 0
                                                  ? redColor
                                                  : Color(0xFF9CA4AB),
                                          // width: 200, // spécifiez la largeur si nécessaire
                                          // height: 200, // spécifiez la hauteur si nécessaire
                                        )
                                      ]),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 6,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: driver_id != 0 &&
                                                        (status == 9 ||
                                                            status == 6)
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: driver_id != 0
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: driver_id != 0 &&
                                                        (status == 9 ||
                                                            status == 6)
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: driver_id != 0 &&
                                                        (status == 9 ||
                                                            status == 6)
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: driver_id != 0 &&
                                                        (status == 9 ||
                                                            status == 6)
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        SvgPicture.asset(
                                          'assets/suivi/man.svg',
                                          color: driver_id != 0 &&
                                                  (status == 9 || status == 6)
                                              ? status == 6 && driver_id == 0
                                                  ? redColor
                                                  : primaryColor
                                              : status == 6 && driver_id == 0
                                                  ? redColor
                                                  : Color(0xFF9CA4AB),
                                          // width: 200, // spécifiez la largeur si nécessaire
                                          // height: 200, // spécifiez la hauteur si nécessaire
                                        )
                                      ]),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 6,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status == 6
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status == 6
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status == 6
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                  color: status == 6
                                                      ? status == 6 &&
                                                              driver_id == 0
                                                          ? redColor
                                                          : primaryColor
                                                      : status == 6 &&
                                                              driver_id == 0
                                                          ? redColor
                                                          : Color(0xFF9CA4AB),
                                                  shape: CircleBorder()),
                                            ),
                                            const SizedBox(width: 7),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: ShapeDecoration(
                                                color: status == 6
                                                    ? status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : primaryColor
                                                    : status == 6 &&
                                                            driver_id == 0
                                                        ? redColor
                                                        : Color(0xFF9CA4AB),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        SvgPicture.asset(
                                          'assets/suivi/done.svg',
                                          color: status == 6
                                              ? status == 6 && driver_id == 0
                                                  ? redColor
                                                  : primaryColor
                                              : status == 6 && driver_id == 0
                                                  ? redColor
                                                  : Color(0xFF9CA4AB),
                                          // width: 200, // spécifiez la largeur si nécessaire
                                          // height: 200, // spécifiez la hauteur si nécessaire
                                        )
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                status == 9 || status == 6
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SuivieLivreur(
                                      orderData: orderDetailData)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, top: 15),
                          child: Row(
                            children: [
                              Text(
                                "Suivre le livreur",
                                style: TextStyle(
                                  color: Color(0xFF434E58),
                                  fontSize: 16,
                                  fontFamily: 'Abel',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 8,
                  decoration: BoxDecoration(color: Color(0xFFF3F3F3)),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: orderDetails.map((foodItem) {
                    return Card(
                      margin: EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Image carrée à gauche
                            Stack(
                              children: [
                                Container(
                                  width: 85.0,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          '$serverImages${foodItem.image}'), // Remplacez par le chemin de votre image
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: Container(
                                      child: Text(
                                        "X${foodItem.count}",
                                        style: TextStyle(color: blackColor),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 16.0),
                            // Textes au milieu en 3 colonnes
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    foodItem.name,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '${foodItem.desc}',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  if (foodItem.extras.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Extras:',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Column(
                                          children: foodItem.extras
                                              .map<Widget>((extra) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                    child:
                                                        Text(extra["extras"])),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    "X${extra["extrascount"].toString()}"),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    "${extra["extrasprice"].toString()}F"),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ),
                            Text(
                              '${foodItem.totalPrice} F',
                              style: TextStyle(fontSize: 14.0),
                            ),
                            // Bouton en bas à droite
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Marchandise Sous total",
                            style: text16GrayScale90,
                          ),
                          Text(
                            "F ${calculateTotalPrice().toStringAsFixed(0)}",
                            style: text16GrayScale90,
                          ),
                        ],
                      ),
                      reduction != null
                          ? SizedBox(
                              height: 15,
                            )
                          : Container(),
                      reduction != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reduction coupon",
                                  style: text16GrayScale90,
                                ),
                                Text(
                                  "F -${calculateTotalReduction().toStringAsFixed(0)}",
                                  style: text16GrayScale90,
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Frais de livraison",
                            style: text16GrayScale90,
                          ),
                          Text(
                            "F ${double.parse(orderDetail["fee"]).toStringAsFixed(0)}",
                            style: text16GrayScale90,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Frais de service",
                            style: text16GrayScale90,
                          ),
                          Text(
                            "F ${double.parse(orderDetail["default_tax"]).toStringAsFixed(0)}",
                            style: text16GrayScale90,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Distance en plus",
                            style: text16GrayScale90,
                          ),
                          Text(
                            "F ${double.parse(excedant).toStringAsFixed(0)}",
                            style: text16GrayScale90,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total à payer",
                            style: text16GrayScale100,
                          ),
                          Text(
                            "F ${totalCom.toStringAsFixed(0)}",
                            style: text16Success,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        decoration: BoxDecoration(color: Color(0xFFF3F3F3)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Methode de paiement",
                            style: text16GrayScale100,
                          ),
                          Text(
                            "${orderDetail["order"]["method"]}",
                            style: text16Success,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      /* Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Numero de la commande",
                            style: text16GrayScale100,
                          ),
                          Text(
                            "${orderDetail["order"]["numero"]}",
                            style: text16Success,
                          ),
                        ],
                      ), */
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "",
                            style: text16GrayScale100,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final filePath = await generateReceipt_old();
                              // Ouvrez le fichier PDF avec l'application par défaut
                              OpenFile.open(filePath);
                            },
                            child: Text(
                              "Télécharger le reçu",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (status == 1) {
                            var response = cancelOrder(widget.order_id);
                            if (response['error'] == "0") {
                              Fluttertoast.showToast(msg: "Commande annulée");
                            }
                            print(response);
                          }
                          if (status == 6 && driver_id != 0) {}
                        },
                        child: Container(
                          //width: 327,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: status == 1 && driver_id == 0
                                ? redColor
                                : status == 6 && driver_id != 0
                                    ? primaryColor
                                    : Color(0xFFE3E9ED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    status == 1 && driver_id == 0
                                        ? 'Annuler la commande'
                                        : status == 6
                                            ? driver_id != 0
                                                ? 'Evaluer le restaurant'
                                                : 'Commande annulé'
                                            : 'Patienter',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: status == 1 || status == 6
                                          ? driver_id != 0
                                              ? whiteColor
                                              : blackColor
                                          : Color(0xFF434E58),
                                      fontSize: 16,
                                      fontFamily: 'Abel',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            _loading
                ? Center(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      height: size
                          .height, // Ajustez la hauteur du loader selon vos besoins
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: primaryColor,
                          size: 30.0,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class MyAppBarSuivie extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  MyAppBarSuivie({required this.titleText});
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
          Navigator.pushNamedAndRemoveUntil(
              context, "/accueil", (route) => false);
        },
      ),
      centerTitle: true,
      title: Text(
        titleText,
        style: text20GrayScale100,
      ),
    );
  }
}
