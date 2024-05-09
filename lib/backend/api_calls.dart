import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'package:odrive/backend/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginagent = "0759261075";
var passwordagent = "rRPS3SSWTC";
var username =
    '21c5685f39c665e481147bf9273ef6c80a36d1003cecec9c85fc466596b1734e';
var password =
    '50a4687f72e0724ee6ab328530ef71589311bfe517cb00a791c6d9b335844861';
var agence = "ODRCI10751";

login(String phone, String password) async {
  print("lllllllooooogggggggiiiiiinnnnnn");
  print(phone);
  print(password);
  try {
    var body = json.encoder.convert({
      'phone': '$phone',
      'email': 'null',
      'password': '$password',
    });

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Content-Length': "${body.length}",
      // 'Host' : "madir.com.ng"
    };
    print("bbbbbbbooooooo");
    print(body);

    var url = "${serverPath}login";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("login: $url, $body");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);

      if (jsonResult['error'] == 0) {
        var userData = jsonResult['user'];
        var uuid = jsonResult['access_token'];
        saveUserDataToSharedPreferences(userData, password, uuid);
        return jsonResult;
      } else {
        return jsonResult;
      }
    }
  } catch (ex) {
    print(ex);
    //callbackError(ex.toString());
  }
}

register(
  String email,
  String password,
  String name,
  String phone,
  String type,
  String photoUrl,
) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({
      'email': '$email',
      'password': '$password',
      'name': '$name',
      'phone': '$phone',
      'typeReg': '$type',
      'photoUrl': "$photoUrl"
    });
    var url = "${serverPath}regUser";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("register: $url, $body");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);

      if (jsonResult['error'].toString() == "0") {
        var userData = jsonResult['user'];
        var uuid = jsonResult['access_token'];
        saveUserDataToSharedPreferences(userData, password, uuid);
        return jsonResult;
      } else {
        return jsonResult;
      }
    }

    /* if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      if (ret.error == "0") {
        if (ret.data != null) {
          var path = "";
          if (ret.data!.avatar.isNotEmpty)
            path = "$serverImages${ret.data!.avatar}";
          callback(ret.data!.name, password, path, email, ret.accessToken,
              ret.data!.typeReg);
        } else
          callbackError("error:ret.data=null");
      } else
        callbackError("${ret.error}");
    } else {
      callbackError("statusCode=${response.statusCode}");
    } */
  } catch (ex) {
    print(ex);
    //callbackError(ex.toString());
  }
}

getMain() async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var url = "${serverPath}getMain";
    var response = await http
        .get(
          Uri.parse(url),
          headers: requestHeaders,
        )
        .timeout(const Duration(seconds: 30));

    print("login: $url");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    } else {
      return json.decode(response.body);
    }
  } catch (ex) {
    print(ex);
    //callbackError(ex.toString());
  }
}

getSecondMain() async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var url = "${serverPath}getSecondStep";
    var response = await http
        .get(
          Uri.parse(url),
          headers: requestHeaders,
        )
        .timeout(const Duration(seconds: 30));

    print("login: $url");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    } else {
      return json.decode(response.body);
    }
  } catch (ex) {
    print(ex);
    //callbackError(ex.toString());
  }
}

getNotify(String uid) async {
  try {
    var url = "${serverPath}notify";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': 'Bearer $uid',
    }).timeout(const Duration(seconds: 30));

    print("api/notify");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return response.statusCode;
    }
  } catch (ex) {
    print(ex);
  }
}

getRestaurant(String id) async {
  // if (_currentId == id)
  //   return callback(_currentRet);

  try {
    var url = "${serverPath}getRestaurant?restaurant=$id";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
    }).timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return {"error": jsonResult['error']};
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    print(ex);
  }
}

getFoodById(String id) async {
  // if (_currentId == id)
  //   return callback(_currentRet);

  try {
    var url = "${serverPath}getFoodById?id=$id";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
    }).timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return {"error": jsonResult['error']};
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    print(ex);
  }
}

getOrderDetails(String uid, int order_id) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };

    String body = '{}';

    print('body: $body');
    var url = "${serverPath}getOrderDetail?order_id=$order_id";
    var response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(const Duration(seconds: 30));

    print("getOrderDetail");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur s'est produite"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return {"error": jsonResult['error']};
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    print(ex);
  }
}

getDriverDetails(String uid, int driver) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };

    String body = '{}';

    print('body: $body');
    var url = "${serverPath}getUserInformation?driver=$driver";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("getUserInformation");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur s'est produite"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return {"error": "une erreur s'est produite"};
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    print(ex);
  }
}

getDriverLocation(int driver) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    String body = '{}';

    print('body: $body');
    var url = "${serverPath}getDriverLocation?driver=$driver";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("getDriverLocation");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur s'est produite"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return {"error": "une erreur s'est produite"};
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    print(ex);
  }
}

getOrderById(int order_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString('uuid') ?? "";

  try {
    var url = "${serverPath}getOrderById?order_id=$order_id";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': 'Bearer $uuid',
    }).timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "Une erreur est survenue 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
        /* callback(jsonResult["orderid"].toString(), jsonResult["fee"].toString(),
            jsonResult["percent"].toString(), perkm); */
      } else {
        return jsonResult;
        //callbackError("error=${jsonResult["error"]}");
      }
    } else {
      return {"error": "une erreur c'est produite"};
      //callbackError("statusCode=${response.statusCode}");
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur c'est produite! Verifiez votre connexion"};
  }
}

addToBasket(
    List<dynamic> basket,
    String uid,
    String tax,
    String hint,
    String restaurant,
    String method, // method = Cash on Delivery
    String fee,
    String send,
    String address,
    String phone,
    double total,
    String lat,
    String lng,
    String curbsidePickup,
    String couponName) async {
  try {
    print("in addtobasket---------------");
    print(basket);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };

    var first = true;
    var data = "[";
    for (var item in basket) {
      if (!item["delivered"]) {
        if (!first) data += ',';
        data += toJSON(item);
        if (first) first = false;
      }
    }
    data += ']';
    print(data);

    var _total = total.toStringAsFixed(2).toString();
    String body =
        '{"total": "$_total", "address": ${json.encode(address)}, "phone": "$phone", "pstatus": "Waiting for client", '
        '"lat" : "$lat", "lng" : "$lng", "curbsidePickup" : "$curbsidePickup", '
        '"send": "$send", "tax": "$tax", "hint": ${json.encode(hint)}, "couponName" : ${json.encode(couponName)}, "restaurant": ${json.encode(restaurant)}, '
        '"method": "$method", "fee": "$fee", "data": $data}';

    print('body: $body');
    var url = "${serverPath}addToBasket";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("addToBasket");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401) return {"error": "Une erreur est survenue"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        var perkm = "";
        if (jsonResult["perkm"] != null) perkm = jsonResult["perkm"].toString();
        return jsonResult;
        /* callback(jsonResult["orderid"].toString(), jsonResult["fee"].toString(),
            jsonResult["percent"].toString(), perkm); */
      } else {
        print("my result");
        print(jsonResult);
        return jsonResult;
        //callbackError("error=${jsonResult["error"]}");
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
      //callbackError("statusCode=${response.statusCode}");
    }
  } catch (ex) {
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

resetBasket(String uid) async {
  try {
    print("in resetBasket");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}resetBasket";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": "une erreur c'est produite 401"};
    }
  } catch (ex) {
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getItemCount(String uid) async {
  // if (_currentId == id)
  //   return callback(_currentRet);
  print(
      "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%222222222222222222222222");

  try {
    var url = "${serverPath}getBasketItemCount";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    }).timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      print(jsonResult);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return {"error": jsonResult['error']};
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    print(ex);
  }
}

getBasket(String uid) async {
  try {
    print("in getBasket");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };

    String body = '{}';

    print('body: $body');
    var url = "${serverPath}getBasket";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("addToBasket");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401) return {"error": "Une erreur est survenue"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
        /* callback(jsonResult["orderid"].toString(), jsonResult["fee"].toString(),
            jsonResult["percent"].toString(), perkm); */
      } else {
        return jsonResult;
        //callbackError("error=${jsonResult["error"]}");
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
      //callbackError("statusCode=${response.statusCode}");
    }
  } catch (ex) {
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

postQrCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uid = prefs.getString("uuid") ?? "";
  String id = (prefs.getInt("userId") ?? 0).toString();
  String timestanp = DateTime.now().millisecondsSinceEpoch.toString();

  try {
    print("in postQrCode");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };

    String qr_id = id + timestanp + "Qr";

    String body = '{}';

    print('body: $body');
    var url = "${serverPath}postQrCode?qr_id=$qr_id";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("postQrCode");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401) return {"error": "Une erreur est survenue"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
        /* callback(jsonResult["orderid"].toString(), jsonResult["fee"].toString(),
            jsonResult["percent"].toString(), perkm); */
      } else {
        return jsonResult;
        //callbackError("error=${jsonResult["error"]}");
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
      //callbackError("statusCode=${response.statusCode}");
    }
  } catch (ex) {
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getQrCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uid = prefs.getString("uuid") ?? "";

  try {
    print("in getQrCode");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };

    String body = '{}';

    print('body: $body');
    var url = "${serverPath}getQrCode";
    var response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(const Duration(seconds: 30));

    print("getQrCode");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401) return {"error": "Une erreur est survenue"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
        /* callback(jsonResult["orderid"].toString(), jsonResult["fee"].toString(),
            jsonResult["percent"].toString(), perkm); */
      } else {
        return jsonResult;
        //callbackError("error=${jsonResult["error"]}");
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
      //callbackError("statusCode=${response.statusCode}");
    }
  } catch (ex) {
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

String toJSON(dynamic basketdata) {
  var t = json.encode(basketdata["name"]);
  var t2 = json.encode(basketdata["image"]);
  var discPrice = basketdata["price"];
  if (basketdata["discountprice"] != 0) discPrice = basketdata["discountprice"];

  var _text =
      '{"food": $t, "count": "${basketdata["count"]}", "foodprice": "$discPrice", "extras": "0", '
      '"extrascount" : "0", "extrasprice": "0", "foodid": "${basketdata["id"]}", "extrasid" : "0", "image" : $t2, "desc" : "${basketdata["desc"]}"}';
  // if (extras != null)
  //YOANEEEEEE
  /* for (var item in basketdata["extras"]) {
    if (item.select) {
      var t = json.encode(item.name);
      _text =
          '$_text, {"food": "", "count": "0", "foodprice": "0", "extras": $t, '
          '"extrascount" : "$count", "extrasprice": "${item.price}", "foodid": "$id", "extrasid" : "${item.id}", '
          '"image" : ${json.encode(item.image)}}';
    }
  } */
  for (var item in basketdata["extras"]) {
    var t = json.encode(item["name"]);
    print(t);
    print(item["count"]);
    print(item["id"]);

    _text =
        '$_text, {"food": "", "count": "0", "foodprice": "0", "extras": $t, '
        '"extrascount" : "${item["count"]}","desc":"", "extrasprice": "${item["price"]}", "foodid": "${basketdata["id"]}", "extrasid" : "${item["id"]}", '
        '"image" : ${json.encode(item["image"])}}';
  }

  return _text;
}

Future<Map<String, dynamic>> paiementom(idfromclient, recipientemail,
    recipientfirstname, recipientlastname, destinataire, otp, montant) async {
  try {
    print("in intouchservice");
    // URL de l'API
    final String apiUrl =
        'https://api.gutouch.com/dist/api/touchpayapi/v1/$agence/transaction?loginAgent=$loginagent&passwordAgent=$passwordagent';

    print("in intouchservice ${apiUrl}");

    Map<String, dynamic> requestBody = {
      "idFromClient": idfromclient,
      "additionnalInfos": {
        "recipientEmail": recipientemail,
        "recipientFirstName": recipientfirstname,
        "recipientLastName": recipientlastname,
        "destinataire": destinataire,
        "otp": otp
      },
      "amount": montant,
      "callback": "https://odriveportail.com/api/callback",
      "recipientNumber": "0778992531",
      "serviceCode": "PAIEMENTMARCHANDOMPAYCIDIRECT"
    };
    print("after requestBody");
    print(requestBody);

    // Convertir le corps de la requête en format JSON
    String requestBodyJson = json.encode(requestBody);

    // Créer l'objet de requête HTTP
    http.Request request = http.Request('PUT', Uri.parse(apiUrl));
    request.headers['Content-Type'] = 'application/json';
    request.body = requestBodyJson;

    // Créer l'objet d'authentification Digest
    DigestAuthClient digestAuthClient = DigestAuthClient(username, password);

    // Envoyer la requête avec l'authentification Digest
    http.StreamedResponse streamedResponse =
        await digestAuthClient.send(request);

    // Lire le corps de la réponse
    String responseString = await streamedResponse.stream.bytesToString();

    // Créer une réponse avec le corps et le code de statut
    http.Response response =
        http.Response(responseString, streamedResponse.statusCode);

    // Afficher la réponse
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête réussie: ${jsonResponse}');

      // Retourner une instance de TransactionResponse
      return jsonResponse;
    } else {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête error: ${jsonResponse['status']}');
      return jsonResponse;
    }

    // Traiter la réponse

  } catch (e) {
    print(e);
    return {"error": e};
  }
}

Future<Map<String, dynamic>> paiementmtn(idfromclient, recipientemail,
    recipientfirstname, recipientlastname, destinataire, montant) async {
  try {
    print("in intouchservice");
    // URL de l'API
    final String apiUrl =
        'https://api.gutouch.com/dist/api/touchpayapi/v1/$agence/transaction?loginAgent=$loginagent&passwordAgent=$passwordagent';

    print("in intouchservice ${apiUrl}");

    Map<String, dynamic> requestBody = {
      "idFromClient": idfromclient,
      "additionnalInfos": {
        "recipientEmail": recipientemail,
        "recipientFirstName": recipientfirstname,
        "recipientLastName": recipientlastname,
        "destinataire": destinataire
      },
      "amount": montant,
      "callback": "https://odriveportail.com/api/callback",
      "recipientNumber": destinataire,
      "serviceCode": "PAIEMENTMARCHAND_MTN_CI"
    };
    print("after requestBody");
    print(requestBody);

    // Convertir le corps de la requête en format JSON
    String requestBodyJson = json.encode(requestBody);

    // Créer l'objet de requête HTTP
    http.Request request = http.Request('PUT', Uri.parse(apiUrl));
    request.headers['Content-Type'] = 'application/json';
    request.body = requestBodyJson;

    // Créer l'objet d'authentification Digest
    DigestAuthClient digestAuthClient = DigestAuthClient(username, password);

    // Envoyer la requête avec l'authentification Digest
    http.StreamedResponse streamedResponse =
        await digestAuthClient.send(request);

    // Lire le corps de la réponse
    String responseString = await streamedResponse.stream.bytesToString();

    // Créer une réponse avec le corps et le code de statut
    http.Response response =
        http.Response(responseString, streamedResponse.statusCode);

    // Afficher la réponse
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête réussie: ${jsonResponse}');

      // Retourner une instance de TransactionResponse
      return jsonResponse;
    } else {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête error: ${jsonResponse['status']}');
      return jsonResponse;
    }

    // Traiter la réponse

  } catch (e) {
    print(e);
    return {"error": e};
  }
}

Future<Map<String, dynamic>> paiementmoov(idfromclient, recipientemail,
    recipientfirstname, recipientlastname, destinataire, montant) async {
  try {
    print("in intouchservice");
    // URL de l'API
    const String apiUrl =
        'https://api.gutouch.com/dist/api/touchpayapi/v1/ODRCI10751/transaction?loginAgent=0759261075&passwordAgent=rRPS3SSWTC';

    print("in intouchservice ${apiUrl}");

    Map<String, dynamic> requestBody = {
      "idFromClient": idfromclient,
      "additionnalInfos": {
        "recipientEmail": recipientemail,
        "recipientFirstName": recipientfirstname,
        "recipientLastName": recipientlastname,
        "destinataire": destinataire
      },
      "amount": montant,
      "callback": "https://odriveportail.com/api/callback",
      "recipientNumber": destinataire,
      "serviceCode": "PAIEMENTMARCHAND_MOOV_CI"
    };
    print("after requestBody");
    print(requestBody);

    // Convertir le corps de la requête en format JSON
    String requestBodyJson = json.encode(requestBody);

    // Créer l'objet de requête HTTP
    http.Request request = http.Request('PUT', Uri.parse(apiUrl));
    request.headers['Content-Type'] = 'application/json';
    request.body = requestBodyJson;

    // Créer l'objet d'authentification Digest
    DigestAuthClient digestAuthClient = DigestAuthClient(username, password);

    // Envoyer la requête avec l'authentification Digest
    http.StreamedResponse streamedResponse =
        await digestAuthClient.send(request);

    // Lire le corps de la réponse
    String responseString = await streamedResponse.stream.bytesToString();

    // Créer une réponse avec le corps et le code de statut
    http.Response response =
        http.Response(responseString, streamedResponse.statusCode);

    // Afficher la réponse
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête réussie: ${jsonResponse}');

      // Retourner une instance de TransactionResponse
      return jsonResponse;
    } else {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête error: ${jsonResponse['status']}');
      return jsonResponse;
    }

    // Traiter la réponse

  } catch (e) {
    print(e);
    return {"error": e};
  }
}

Future<Map<String, dynamic>> paiementwave(idfromclient, recipientemail,
    recipientfirstname, recipientlastname, destinataire, montant) async {
  try {
    print("in intouchservice");
    // URL de l'API
    const String apiUrl =
        'https://api.gutouch.com/dist/api/touchpayapi/v1/ODRCI10751/transaction?loginAgent=0759261075&passwordAgent=rRPS3SSWTC';

    print("in intouchservice ${apiUrl}");

    Map<String, dynamic> requestBody = {
      "idFromClient": idfromclient,
      "additionnalInfos": {
        "recipientEmail": recipientemail,
        "recipientFirstName": recipientfirstname,
        "recipientLastName": recipientlastname,
        "destinataire": destinataire,
        "partner_name": "O'DRIVE",
        "return_url": "https://successurl.com",
        "cancel_url": "https://failedurl.com"
      },
      "amount": montant,
      "callback": "https://odriveportail.com/api/callback",
      "recipientNumber": destinataire,
      "serviceCode": "CI_PAIEMENTWAVE_TP"
    };
    print("after requestBody");
    print(requestBody);

    // Convertir le corps de la requête en format JSON
    String requestBodyJson = json.encode(requestBody);

    // Créer l'objet de requête HTTP
    http.Request request = http.Request('PUT', Uri.parse(apiUrl));
    request.headers['Content-Type'] = 'application/json';
    request.body = requestBodyJson;

    // Créer l'objet d'authentification Digest
    DigestAuthClient digestAuthClient = DigestAuthClient(username, password);

    // Envoyer la requête avec l'authentification Digest
    http.StreamedResponse streamedResponse =
        await digestAuthClient.send(request);

    // Lire le corps de la réponse
    String responseString = await streamedResponse.stream.bytesToString();

    // Créer une réponse avec le corps et le code de statut
    http.Response response =
        http.Response(responseString, streamedResponse.statusCode);

    // Afficher la réponse
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête réussie: ${jsonResponse}');

      // Retourner une instance de TransactionResponse
      return jsonResponse;
    } else {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête error: ${jsonResponse['status']}');
      return jsonResponse;
    }

    // Traiter la réponse

  } catch (e) {
    print(e);
    return {"error": e};
  }
}

Future<Map<String, dynamic>> checkStatus(idfromclient) async {
  try {
    final String apiUrl =
        'https://api.gutouch.com/dist/api/touchpayapi/v1/ODRCI10751/transaction/$idfromclient?loginAgent=0759261075&passwordAgent=rRPS3SSWTC';

    // Créer l'objet de requête HTTP
    http.Request request = http.Request('GET', Uri.parse(apiUrl));
    request.headers['Content-Type'] = 'application/json';
    //request.body = requestBodyJson;

    // Créer l'objet d'authentification Digest
    DigestAuthClient digestAuthClient = DigestAuthClient(username, password);

    // Envoyer la requête avec l'authentification Digest
    http.StreamedResponse streamedResponse =
        await digestAuthClient.send(request);

    // Lire le corps de la réponse
    String responseString = await streamedResponse.stream.bytesToString();

    // Créer une réponse avec le corps et le code de statut
    http.Response response =
        http.Response(responseString, streamedResponse.statusCode);

    // Afficher la réponse
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête réussie: ${jsonResponse}');

      // Retourner une instance de TransactionResponse
      return jsonResponse;
    } else {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Requête error: ${jsonResponse['status']}');
      return jsonResponse;
    }
  } catch (e) {
    print(e);
    return {"error": e};
  }
}

savePaiement(dynamic paiementDetail, int order_id) async {
  print("saveeeeeeeeeeeeee");
  print("deeeeeeeeeeeeeetail");
  print(paiementDetail);
  paiementDetail["order_id"] = order_id;
  print(paiementDetail);

  try {
    var body = json.encoder.convert(paiementDetail);

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Content-Length': "${body.length}",
      // 'Host' : "madir.com.ng"
    };
    print("bbbbbbbooooooo");
    print(body);

    var url = "${serverPath}savepaiement";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("savepaiement: $url, $body");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return {"message": "paiement sauvegarder"};
    } else {
      print("Erreur lors de la sauvegarde du paiement");
      return {"error": "Erreur lors de la sauvegarde du paiement"};
    }
  } catch (ex) {
    print(ex);
    //callbackError(ex.toString());
  }
}

getOrders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in getOrders");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}getOrders";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getFavorite() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in getOrders");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}favoritesGet";
    var response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

deleteFavorite(int food) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in getOrders");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}favoritesDelete?food=$food";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

deleteFromBasket(food, orderid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in deleteFromBasket");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}deleteFromBasket?orderid=$orderid&id=$food";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

addFavorite(int food) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in getOrders");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}favoritesAdd?food=$food";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getPointPalier() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in getPointPalier");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}getPointPalier";
    var response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getPallierWallet() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in getPointPalier");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}getPallierWallet";
    var response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      print(jsonResult);
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

payOnWallet(total) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in payOnWallet");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{"total": "$total"}';

    print('body: $body');
    var url = "${serverPath}payOnWallet";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      print(jsonResult);
      return jsonResult;
    } else {
      var jsonResult = json.decode(response.body);
      print(jsonResult);
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

addPoint(int point) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in addPoint");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}addPoint?point=$point";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getPoints() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    print("in addPoint");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}getPoint";
    var response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": "une erreur c'est produite"};
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

sharePoint(qrSender, point, uuid) async {
  try {
    print("in sharePoint");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}sharePoint?qr_sender=$qrSender&point=$point";
    var response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

addNotificationToken(String fcbToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };

    String body = '{"fcbToken": "$fcbToken"}';

    print('body: $body');
    var url = "${serverPath}fcbToken";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("fcbToken");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (_) {}
}

foodsOfMonth() async {
  // Récupérer la date et l'heure actuelle
  DateTime now = DateTime.now();

  // Extraire l'année et le mois
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0');
  try {
    print("in sharePoint");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}mostOrderMonth?year=$year&month=$month";
    var response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

createCoupon(String point) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  print(point);
  try {
    print("in createCoupon");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };
    String body = '{}';

    print('body: $body');
    var url = "${serverPath}createCoupon?discount=$point";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

checkCoupon(String coupon_code, List category_ids, String restaurant_ids,
    List food_ids, String order_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";

  try {
    print("in createCoupon");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };

    Map<String, dynamic> body = {
      'coupon_code': coupon_code,
      'category_ids': category_ids,
      'restaurant_ids': restaurant_ids.split(','),
      'food_ids': food_ids,
      'order_id': order_id
    };

    print('body: $body');
    var url = "${serverPath}checkCoupon";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

updateOrderCoupon(String coupon_code, String order_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";

  try {
    print("in createCoupon");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };

    Map<String, dynamic> body = {
      'coupon_code': coupon_code,
      'order_id': order_id
    };

    print('body: $body');
    var url = "${serverPath}updateOrderCoupon";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getCouponByName(String coupon_code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";

  try {
    print("in createCoupon");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };

    Map<String, dynamic> body = {
      'coupon_code': coupon_code,
    };

    print('body: $body');
    var url = "${serverPath}getCouponByName";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getWalletById() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";

  try {
    print("in getWalletById");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };

    Map<String, dynamic> body = {};

    print('body: $body');
    var url = "${serverPath}getWalletById";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

walletgb() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";

  try {
    print("in getWalletById");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };

    Map<String, dynamic> body = {};

    print('body: $body');
    var url = "${serverPath}walletgb";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

walletTopUp(total) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";

  try {
    print("in getWalletById");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };

    Map<String, dynamic> body = {'total': total, 'id': 'rechargement'};

    print('body: $body');
    var url = "${serverPath}walletTopUp";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

updatePoint(point) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";

  try {
    print("in updatePoint");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };

    Map<String, dynamic> body = {'point': point};

    print('body: $body');
    var url = "${serverPath}updatePoint";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getSearch(String search) async {
  try {
    var url = "${serverPath}search?search=$search";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
    }).timeout(const Duration(seconds: 30));

    print("api/search");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    return {"error": "Une erreur inconnu s'est produite"};
  }
}

searchSuggestion() async {
  try {
    var url = "${serverPath}searchSuggestion";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
    }).timeout(const Duration(seconds: 30));

    print("api/searchSuggestion");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    print(ex);
    return {"error": "Une erreur inconnu s'est produite"};
  }
}

searchFilter(prixMin, prixMax, suggestion, distance, trie) async {
  try {
    var localisation = await _getCurrentLocation();
    var lat_user;
    var lng_user;
    if (localisation.containsKey("error")) {
      return {'error': localisation["error"]};
    } else if (localisation.containsKey("latitude") &&
        localisation.containsKey("longitude")) {
      lat_user = localisation["latitude"];
      lng_user = localisation["longitude"];
    } else {
      return {
        'error':
            "impossible de récupérer votre position, vérifier les autorisations et réessayer"
      };
    }
    print("in searchFilter");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    Map<String, dynamic> body = {
      'prix_min': prixMin,
      'prix_max': prixMax,
      'suggestion': suggestion,
      'distance': distance,
      'trie': trie,
      'lat_user': lat_user,
      'lng_user': lng_user
    };

    print('body: $body');
    var url = "${serverPath}searchFilter";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur c'est produite 401"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      var jsonResult = json.decode(response.body);
      return jsonResult;
    }
  } catch (ex) {
    print(ex);
    return {"error": "une erreur inconnue c'est produite"};
    //callbackError(ex.toString());
  }
}

getReviews(idRestaurant) async {
  try {
    var url = "${serverPath}restaurantReviewsget";
    Map<String, dynamic> body = {'restaurant': idRestaurant};
    var response = await http
        .post(Uri.parse(url),
            headers: {
              'Content-type': 'application/json',
              'Accept': "application/json",
            },
            body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print("api/restaurantReviewsget");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return jsonResult;
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    print(ex);
    return {"error": "Une erreur inconnu s'est produite"};
  }
}

cancelOrder(int order_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uuid = prefs.getString("uuid") ?? "";
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uuid",
    };

    Map<String, dynamic> body = {'order_id': order_id};

    print('body: $body');
    var url = "${serverPath}cancelOrder";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    print("getOrderDetail");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return {"error": "une erreur s'est produite"};
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult['error'] == '0') {
        return jsonResult;
      } else {
        return {"error": jsonResult['error']};
      }
    } else {
      return {"error": response.statusCode};
    }
  } catch (ex) {
    print(ex);
  }
}

void saveUserDataToSharedPreferences(
    Map<String, dynamic> userData, String password, String uuid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print(uuid);

  prefs.setInt('userId', userData['id']);
  prefs.setString('userName', userData['name']);
  prefs.setString('userEmail', userData['email']);
  prefs.setString('userPassword', password);
  prefs.setInt('userRole', userData['role']);
  prefs.setInt('userImageId', userData['imageid']);

  prefs.setString('userPhone', userData['phone']);
  prefs.setString('userAvatar', userData['avatar']);
  prefs.setString('uuid', uuid);

  print(prefs.getString("uuid"));
  prefs.setString('userAddress', userData['address']);

  // ... ajoutez d'autres champs que vous souhaitez enregistrer
}

// Fonction pour récupérer la position actuelle
Future<dynamic> _getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();
    return {"latitude": latitude, "longitude": longitude};
  } catch (e) {
    print(e);
    return {
      "error":
          "impossible de récupérer votre position, vérifier les autorisations"
    };
  }
}
