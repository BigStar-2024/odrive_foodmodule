import 'package:flutter/material.dart';
import 'package:odrive/constante/utils.dart';
import 'package:odrive/themes/theme.dart' as theme;

class AppSettings {
  String currency;
  String darkMode;
  String rightSymbol;
  int symbolDigits;
  double radius;
  int shadow;
  List<String> rows;
  Color mainColor;
  Color iconColorWhiteMode;
  Color iconColorDarkMode;
  int restaurantCardWidth;
  int restaurantCardHeight;
  Color restaurantBackgroundColor;
  Color restaurantCardTextColor;
  Color dishesTitleColor;
  int dishesCardHeight;
  String oneInLine;
  int categoryCardWidth;
  int categoryCardHeight;
  double restaurantCardTextSize;
  Color dishesBackgroundColor;
  Color searchBackgroundColor;
  Color restaurantTitleColor;
  Color reviewTitleColor;
  Color reviewBackgroundColor;
  Color categoriesTitleColor;
  Color categoriesBackgroundColor;
  String categoryCardCircle;
  int topRestaurantCardHeight;
  String bottomBarType;
  Color bottomBarColor;
  Color titleBarColor;
  String mapapikey;
  String walletEnable;
  String intouchEnable;
  String typeFoods;
  String distanceUnit;
  String appLanguage;
  int banner1CardHeight;
  int banner2CardHeight;
  //
  String copyright;
  String copyrightText;
  String about;
  String delivery;
  String privacy;
  String terms;
  String refund;
  String faq;
  String refundTextName;
  String aboutTextName;
  String deliveryTextName;
  String privacyTextName;
  String termsTextName;
  //
  double defaultLat;
  double defaultLng;
  double defaultZoom;
  //
  String googleLogin;
  String facebookLogin;
  //
  String otp;
  String curbsidePickup;
  String coupon;
  String deliveringTime;
  String deliveringDate;
  String delivering;

  String skin;
  String shareAppGooglePlay;
  String shareAppAppStore;

  String city;
  // List<AdditionFields> additionFields;

  AppSettings({
    this.currency = "",
    this.darkMode = "false",
    this.rightSymbol = "false",
    this.walletEnable = "false",
    this.intouchEnable = "false",
    this.symbolDigits = 2,
    this.radius = 25,
    this.shadow = 40,
    this.rows = const ["search", "nearyou", "cat", "pop", "review"],
    this.mainColor = Colors.green,
    this.iconColorWhiteMode = Colors.black,
    this.iconColorDarkMode = Colors.white,
    // restaurants
    this.restaurantCardWidth = 60,
    this.restaurantCardHeight = 40,
    this.restaurantBackgroundColor = Colors.green,
    this.restaurantCardTextSize = 20,
    this.restaurantCardTextColor = Colors.black,
    this.restaurantTitleColor = Colors.black,
    // top restaurants
    this.topRestaurantCardHeight = 50,
    // dishes - most popular
    this.dishesTitleColor = Colors.black,
    this.dishesBackgroundColor = Colors.black,
    this.dishesCardHeight = 80,
    this.oneInLine = "false",
    this.typeFoods = "",
    // categories
    this.categoryCardCircle = "true",
    this.categoriesTitleColor = Colors.white,
    this.categoriesBackgroundColor = Colors.white,
    this.categoryCardWidth = 60,
    this.categoryCardHeight = 40,
    // search
    this.searchBackgroundColor = Colors.grey,
    // review
    this.reviewTitleColor = Colors.white,
    this.reviewBackgroundColor = Colors.white,
    // bottomBar
    this.bottomBarType = "",
    this.bottomBarColor = Colors.white,
    // title bar
    this.titleBarColor = theme.whiteColor,
    // map api key
    this.mapapikey = "",
    // km or miles
    this.distanceUnit = "",
    // app language
    this.appLanguage = "1",
    // banners
    this.banner1CardHeight = 50,
    this.banner2CardHeight = 50,
    // documents
    this.copyright = "",
    this.copyrightText = "",
    this.about = "",
    this.delivery = "",
    this.privacy = "",
    this.terms = "",
    this.refund = "",
    this.faq = "",
    this.refundTextName = "",
    this.aboutTextName = "",
    this.deliveryTextName = "",
    this.privacyTextName = "",
    this.termsTextName = "",
    //
    this.defaultLat = 0,
    this.defaultLng = 0,
    this.defaultZoom = 0,
    //
    this.googleLogin = "",
    this.facebookLogin = "",
    //
    this.otp = "",
    this.curbsidePickup = "",
    this.coupon = "",
    this.deliveringTime = "",
    this.deliveringDate = "",
    this.delivering = "",
    // this.additionFields,
    this.skin = "",
    this.shareAppGooglePlay = "",
    this.shareAppAppStore = "",
    //
    this.city = "",
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    var _rows;
    if (json['rows'] != null) {
      _rows = json['rows'].cast<String>().toList();
    } else
      _rows = const [
        "search",
        "banner1",
        "topf",
        "nearyou",
        "cat",
        "pop",
        "review",
        "topr"
      ];

    // debug
    //_rows = const ["search", "categoryDetails", "banner1", "topf", "banner2", "nearyou", "cat", "pop", "topr", "review", "copyright"];

    if (json['darkMode'] != null) {
      if (json['darkMode'] == "true")
        theme.darkMode = true;
      else
        theme.darkMode = false;
      /* theme.init();
      pref.set(Pref.uiDarkMode, json['darkMode']); */
    }

    return AppSettings(
      currency: json['currency'].toString(),
      darkMode: json['darkMode'].toString(),
      rightSymbol: json['rightSymbol'].toString(),
      symbolDigits: toInt(json['symbolDigits'].toString()),
      walletEnable: (json['walletEnable'] == null)
          ? "true"
          : json['walletEnable'].toString(),
      intouchEnable: (json['intouchEnable'] == null)
          ? "true"
          : json['intouchEnable'].toString(),
      radius:
          (json['radius'] == null) ? 3 : toDouble(json['radius'].toString()),
      shadow: (json['shadow'] == null) ? 10 : toInt(json['shadow'].toString()),
      rows: _rows,
      // map api key
      mapapikey:
          (json['mapapikey'] == null) ? "" : json['mapapikey'].toString(),
      // km or miles
      distanceUnit:
          (json['distanceUnit'] == null) ? "" : json['distanceUnit'].toString(),
      // app language
      appLanguage: (json['appLanguage'] == null)
          ? "1"
          : json['appLanguage'].toString(), // default english
      //
      banner1CardHeight: (json['banner1CardHeight'] == null)
          ? 40
          : toInt(json['banner1CardHeight'].toString()),
      banner2CardHeight: (json['banner2CardHeight'] == null)
          ? 40
          : toInt(json['banner2CardHeight'].toString()),
      //
      copyright: json['copyright'].toString(),
      copyrightText: json['copyright_text'].toString(),
      about: json['about'].toString(),
      delivery: json['delivery'].toString(),
      privacy: json['privacy'].toString(),
      terms: json['terms'].toString(),
      refund: json['refund'].toString(),
      faq: json['faq'].toString(),
      refundTextName: json['refund_text_name'].toString(),
      aboutTextName: json['about_text_name'].toString(),
      deliveryTextName: json['delivery_text_name'].toString(),
      privacyTextName: json['privacy_text_name'].toString(),
      termsTextName: json['terms_text_name'].toString(),
      //
      googleLogin: (json['googleLogin_ca'] == null)
          ? "true"
          : json['googleLogin_ca'].toString(),
      facebookLogin: (json['facebookLogin_ca'] == null)
          ? "true"
          : json['facebookLogin_ca'].toString(),
      // Paris  48.836010 2.331359
      // London 51.511680332118786, -0.12748138132489592
      defaultLat: (json['defaultLat'] == null)
          ? 48.836010
          : toDouble(json['defaultLat'].toString()),
      defaultLng: (json['defaultLng'] == null)
          ? 2.331359
          : toDouble(json['defaultLng'].toString()),
      defaultZoom: (json['defaultZoom'] == null)
          ? 12
          : toDouble(json['defaultZoom'].toString()),
      //
      otp: (json['otp'] == null) ? "false" : json['otp'],
      curbsidePickup:
          (json['curbsidePickup'] == null) ? "true" : json['curbsidePickup'],
      coupon: (json['coupon'] == null) ? "true" : json['coupon'],
      deliveringTime:
          (json['deliveringTime'] == null) ? "true" : json['deliveringTime'],
      deliveringDate:
          (json['deliveringDate'] == null) ? "true" : json['deliveringDate'],
      delivering: (json['delivering'] == null) ? "true" : json['delivering'],
      //
      skin: (json['skin'] == null) ? "basic" : json['skin'],
      // share
      shareAppGooglePlay: (json['shareAppGooglePlay'] == null)
          ? ""
          : json['shareAppGooglePlay'],
      shareAppAppStore:
          (json['shareAppAppStore'] == null) ? "" : json['shareAppAppStore'],
      // city
      city: (json['city'] == null) ? "" : json['city'].toString(),
    );
  }
}
