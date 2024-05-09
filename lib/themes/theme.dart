import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF03443C);
const Color secondaryColor = Color(0xFF332C45);
const Color errorColor = Color(0xFFE53935);
const Color successColor = Color(0xFF3D843C);
const Color warningColor = Color(0xFFFACC15);
const Color blackColor = Color(0xFF000000);
const Color whiteColor = Color(0xFFFFFFFF);
const Color greyColor = Color(0xFFF2F2F2);
const Color greyScale900Color = Color(0xFF212121);
const Color greyScale700Color = Color(0xFF616161);
const Color greyScale10Color = Color(0xFFF3F3F3);
const Color greyScale100Color = Color(0xFF171725);
const Color greyScale90Color = Color(0xFF434E58);
const Color greyScale80Color = Color(0xFF66707A);
const Color greyScale70Color = Color(0xFF78828A);
const Color greyScale60Color = Color(0xFF9CA4AB);
const Color greyScale50Color = Color(0xFFBFC6CC);
const Color greyScale40Color = Color(0xFFD1D8DD);
const Color greyScale30Color = Color(0xFFE3E9ED);
const Color greyScale20Color = Color(0xFFECF1F6);
const Color neutralColor = Color(0xFF0B0A0F);
const Color neutral10Color = Color(0xFFFDFDFD);
const Color neutral90Color = Color(0xFF434E58);

const Color beigeColor = Color(0xFFFFF9EB);
const Color lightGreyColor = Color(0xFFE6E6E6);
const Color greyF0Color = Color(0xFFF0F0F0);
const Color greyShade3 = Color(0xFFB7B7B7);
const Color yellowColor = Color(0xFFFFAC33);
const Color redColor = Color(0xFDFF0000);

bool darkMode = false;

const double fixPadding = 10.0;

const SizedBox heightSpace = SizedBox(height: fixPadding);

const TextStyle text24BoldPrimary = TextStyle(
    letterSpacing: 3,
    fontFamily: "Poppins",
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor);

const TextStyle text24GreyScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text16White = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: whiteColor);

const TextStyle text11White = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: whiteColor);

const TextStyle text16WhiteBold = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: whiteColor);
const TextStyle text14WhitePrimary = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: primaryColor);

const TextStyle text14GrayScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text20GrayScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text16GrayScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text16GrayScale90 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: greyScale90Color);

const TextStyle text16Error = TextStyle(
    letterSpacing: 0,
    fontFamily: "Inter",
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: errorColor);

const TextStyle text18Neutral = TextStyle(
    letterSpacing: 0,
    fontFamily: "Inter",
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: neutralColor);

const TextStyle text16Neutral = TextStyle(
    letterSpacing: 0,
    fontFamily: "Inter",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: neutralColor);

const TextStyle text16Primary = TextStyle(
    letterSpacing: 0,
    fontFamily: "Inter",
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: primaryColor);

const TextStyle text20GreyScale700 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: greyScale700Color);

const TextStyle text10White = TextStyle(
    letterSpacing: 0.2,
    fontFamily: "Abel",
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: whiteColor);

const TextStyle text18GreyScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text18Primary = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: primaryColor);

const TextStyle text16GreyScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);
const TextStyle text10GreyScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text14GreyScale20 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: greyScale20Color);

const TextStyle text18GreyScale900 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Barlow",
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: greyScale900Color);

const TextStyle text11GreyScale900 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Barlow",
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: greyScale900Color);

const TextStyle text14GrayScale70 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: greyScale70Color);

const TextStyle text10GrayScale70 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: greyScale70Color);

const TextStyle text16Success = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: successColor);

const TextStyle text32GrayScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 32,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text14GrayScale900 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: greyScale900Color);

const TextStyle text20Secondary = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: secondaryColor);

const TextStyle text16neutral90 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: neutral90Color);
