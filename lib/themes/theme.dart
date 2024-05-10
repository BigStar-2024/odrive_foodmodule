import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppColors {
  static final primaryColor = Color(0xFF03443C);
  static final secondaryColor = Color(0xFFF2A384);
  static final tertiaryColor = Color(0xFF017F7C);
  static final alternateColor = Color(0xFFDBE2E7);
  static final primaryTextColor = Color(0xFF111417);
  static final secondaryTextColor = Color(0xFF8B97A2);
  static final primaryBackgroundColor = Color(0xFFF1F4F8);
  static final secondaryBackgroundColor = Color(0xFFFFFFFF);
  static final accent1Color = Color(0xFF616161);
  static final accent2Color = Color(0xFF757575);
  static final accent3Color = Color(0xFFE0E0E0);
  static final accent4Color = Color(0xFFEEEEEE);
  static final successColor = Color(0xFF04A24C);
  static final errorColor = Color(0xFFE21C3D);
  static final warningColor = Color(0xFFFCDC0C);
  static final infoColor = Color(0xFF1C4494);
  static final backgroundColor = Color(0xFF1A1F24);
  static final darkBackgroundColor = Color(0xFF111417);
  static final textColor = Color(0xFFFFFFFF);
  static final grayDarkColor = Color(0xFF57633C);
  static final grayLightColor = Color(0xFF8B97A2);
  static final errorRedColor = Color(0xFFF06A6A);

  static final primaryColorDark = Color(0xFF03443C);
  static final secondaryColorDark = Color(0xFFF2A384);
  static final tertiaryColorDark = Color(0xFF017F7C);
  static final alternateColorDark = Color(0xFF262D34);
  static final primaryTextColorDark = Color(0xFFFFFFFF);
  static final secondaryTextColorDark = Color(0xFF8B97A2);
  static final primaryBackgroundColorDark = Color(0xFF1A1F24);
  static final secondaryBackgroundColorDark = Color(0xFF111417);
  static final accent1ColorDark = Color(0xFFEEEEEE);
  static final accent2ColorDark = Color(0xFFE0E0E0);
  static final accent3ColorDark = Color(0xFF757575);
  static final accent4ColorDark = Color(0xFF616161);

  static final greyColor = Color(0xFFF2F2F2);
  static final greyColor900 = Color(0xFFEEEEEE);
  static final greyColor800 = Color(0xFF757575);
  static final greyScale900Color = Color(0xFF212121);
  static final greyScale700Color = Color(0xFF616161);
  static final greyScale10Color = Color(0xFFF3F3F3);
  static final greyScale100Color = Color(0xFF171725);
  static final greyScale90Color = Color(0xFF434E58);
  static final greyScale80Color = Color(0xFF66707A);
  static final greyScale70Color = Color(0xFF78828A);
  static final greyScale60Color = Color(0xFF9CA4AB);
  static final greyScale50Color = Color(0xFFBFC6CC);
  static final greyScale40Color = Color(0xFFD1D8DD);
  static final greyScale30Color = Color(0xFFE3E9ED);
  static final greyScale20Color = Color(0xFFECF1F6);
  static final neutralColor = Color(0xFF0B0A0F);
  static final neutral10Color = Color(0xFFFDFDFD);
  static final neutral90Color = Color(0xFF434E58);

  static final beigeColor = Color(0xFFFFF9EB);
  static final lightGreyColor = Color(0xFFE6E6E6);
  static final greyF0Color = Color(0xFFF0F0F0);
  static final greyShade3 = Color(0xFFB7B7B7);
  static final yellowColor = Color(0xFFFFAC33);
}

class MyAppThemes {
  static final lightTheme = ThemeData.light().copyWith(
    primaryColor: MyAppColors.primaryColor,
    primaryColorDark: MyAppColors.darkBackgroundColor,
    // primaryColorLight: MyAppColors.accent4Color,
    scaffoldBackgroundColor: MyAppColors.secondaryBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: MyAppColors.primaryBackgroundColor
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: MyAppColors.secondaryTextColor, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: MyAppColors.primaryTextColor, width: 2.0),
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black
    ),

    iconTheme: IconThemeData(
        color: Colors.black
    ),

    bottomAppBarTheme: BottomAppBarTheme(
      color: MyAppColors.darkBackgroundColor
    ),

    backgroundColor: MyAppColors.primaryBackgroundColor,
    dialogBackgroundColor: MyAppColors.primaryBackgroundColor,
    cardColor: MyAppColors.primaryBackgroundColor,
    disabledColor: MyAppColors.accent1Color,
    dividerColor: MyAppColors.accent3Color,

    colorScheme: ColorScheme.light().copyWith(
      primary: MyAppColors.primaryBackgroundColor,
      onPrimary: MyAppColors.primaryTextColor,
      primaryContainer: MyAppColors.secondaryColor,
      secondary: MyAppColors.secondaryBackgroundColor,
      onSecondary: MyAppColors.secondaryTextColor,
      tertiary: MyAppColors.tertiaryColor,
      error: MyAppColors.errorColor,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.abel(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        color: MyAppColors.primaryTextColor
      ),
      displayMedium: GoogleFonts.inter(
          fontSize: 40,
          fontWeight: FontWeight.w300,
          color: MyAppColors.primaryTextColor
      ),
      displaySmall: GoogleFonts.abel(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: MyAppColors.primaryTextColor
      ),
      headlineLarge: GoogleFonts.abel(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: MyAppColors.primaryTextColor
      ),
      headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: MyAppColors.primaryColor
      ),
      headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: MyAppColors.primaryTextColor
      ),
      titleLarge: GoogleFonts.abel(
        fontSize: 22,
        fontWeight: FontWeight.w500,
          color: MyAppColors.primaryTextColor
      ),
      titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: MyAppColors.secondaryTextColor
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: MyAppColors.textColor
      ),
      labelLarge: GoogleFonts.abel(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: MyAppColors.primaryTextColor,
      ),
      labelMedium: GoogleFonts.abel(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: MyAppColors.primaryTextColor,
      ),
      labelSmall: GoogleFonts.abel(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: MyAppColors.primaryTextColor,
      ),
      bodyLarge: GoogleFonts.abel(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: MyAppColors.primaryTextColor
      ),
      bodyMedium: GoogleFonts.abel(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MyAppColors.primaryTextColor
      ),
      bodySmall: GoogleFonts.abel(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: MyAppColors.secondaryTextColor
      ),
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: MyAppColors.primaryColorDark,
    primaryColorDark: MyAppColors.darkBackgroundColor,
    primaryColorLight: MyAppColors.accent4ColorDark,
    scaffoldBackgroundColor: MyAppColors.primaryBackgroundColorDark,
    appBarTheme: AppBarTheme(
        backgroundColor: MyAppColors.primaryBackgroundColorDark
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: MyAppColors.secondaryTextColorDark, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: MyAppColors.primaryTextColorDark, width: 2.0),
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white
    ),

    iconTheme: IconThemeData(
      color: Colors.white
    ),

    bottomAppBarTheme: BottomAppBarTheme(
        color: MyAppColors.darkBackgroundColor
    ),

    backgroundColor: MyAppColors.primaryBackgroundColorDark,
    dialogBackgroundColor: MyAppColors.primaryBackgroundColorDark,
    cardColor: MyAppColors.primaryBackgroundColorDark,
    disabledColor: MyAppColors.accent1ColorDark,
    dividerColor: MyAppColors.accent2ColorDark,

    colorScheme: ColorScheme.light().copyWith(
      primary: MyAppColors.primaryTextColorDark,
      onPrimary: MyAppColors.primaryTextColorDark,
      primaryContainer: MyAppColors.secondaryColorDark,
      secondary: MyAppColors.secondaryBackgroundColorDark,
      onSecondary: MyAppColors.secondaryTextColorDark,
      tertiary: MyAppColors.tertiaryColorDark,
      error: MyAppColors.errorColor,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.abel(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          color: MyAppColors.primaryTextColorDark
      ),
      displayMedium: GoogleFonts.inter(
          fontSize: 40,
          fontWeight: FontWeight.w300,
          color: MyAppColors.primaryTextColorDark
      ),
      displaySmall: GoogleFonts.abel(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: MyAppColors.primaryTextColorDark
      ),
      headlineLarge: GoogleFonts.abel(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: MyAppColors.primaryTextColorDark
      ),
      headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: MyAppColors.primaryColorDark
      ),
      headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: MyAppColors.primaryTextColorDark
      ),
      titleLarge: GoogleFonts.abel(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: MyAppColors.primaryTextColorDark
      ),
      titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: MyAppColors.secondaryTextColorDark
      ),
      titleSmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: MyAppColors.textColor
      ),
      labelLarge: GoogleFonts.abel(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: MyAppColors.primaryTextColorDark,
      ),
      labelMedium: GoogleFonts.abel(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: MyAppColors.primaryTextColorDark,
      ),
      labelSmall: GoogleFonts.abel(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: MyAppColors.primaryTextColorDark,
      ),
      bodyLarge: GoogleFonts.abel(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: MyAppColors.primaryTextColorDark
      ),
      bodyMedium: GoogleFonts.abel(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MyAppColors.primaryTextColorDark
      ),
      bodySmall: GoogleFonts.abel(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MyAppColors.secondaryTextColorDark
      ),
    ),
  );
}

const Color primaryColor = Color(0xFF03443C);
const Color secondaryColor = Color(0xFF332C45);
const Color errorColor = Color(0xFFE53935);
const Color heartColor = Color(0xFFF58352);
const Color successColor = Color(0xFF3D843C);
const Color warningColor = Color(0xFFFACC15);
const Color blackColor = Color(0xFF000000);
const Color whiteColor = Color(0xFFFFFFFF);
const Color greyColor = Color(0xFFF2F2F2);
const Color greyColor900 = Color(0xFFEEEEEE);
const Color greyColor800 = Color(0xFF757575);
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

const double fixPadding = 12.0;

const SizedBox heightSpace = SizedBox(height: fixPadding);

const TextStyle text48BoldPrimary = TextStyle(
    letterSpacing: 3,
    fontFamily: "Inter",
    fontWeight: FontWeight.w900,
    fontSize: 48,
    color: primaryColor);

const TextStyle text40BoldBlack = TextStyle(
    letterSpacing: 3,
    fontFamily: "Inter",
    fontWeight: FontWeight.w900,
    fontSize: 40,
    color: Colors.black);

const TextStyle text40BoldWhite = TextStyle(
    letterSpacing: 3,
    fontFamily: "Inter",
    fontWeight: FontWeight.w900,
    fontSize: 40,
    color: Colors.white);

const TextStyle text32GrayScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 32,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text32White = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 32,
    fontWeight: FontWeight.normal,
    color: Colors.white);

const TextStyle text24BoldPrimary = TextStyle(
    letterSpacing: 3,
    fontFamily: "Inter",
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor);

const TextStyle text24GreyScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text20GrayScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text20Secondary = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: secondaryColor);

const TextStyle text20GreyScale700 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: greyScale700Color);

const TextStyle text18Neutral = TextStyle(
    letterSpacing: 0,
    fontFamily: "Inter",
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: neutralColor);

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

const TextStyle text18GreyScale900 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Barlow",
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: greyScale900Color);

const TextStyle text18GreyScale800 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Barlow",
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: greyScale80Color);

const TextStyle text16White = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: whiteColor);

const TextStyle text16WhiteSemiBold = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: whiteColor);

const TextStyle text16WhiteBold = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: whiteColor);

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
    fontWeight: FontWeight.w800,
    color: errorColor);

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

const TextStyle text16GreyScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text16Success = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: successColor);

const TextStyle text16neutral90 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: neutral90Color);

const TextStyle text16GreyScale900 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: greyScale900Color);

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

const TextStyle text14GreyScale20 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: greyScale20Color);

const TextStyle text14GrayScale70 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: greyScale70Color);

const TextStyle text14GrayScale900 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: greyScale900Color);

const TextStyle text11GreyScale900 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Barlow",
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: greyScale900Color);

const TextStyle text11White = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: whiteColor);

const TextStyle text10White = TextStyle(
    letterSpacing: 0.2,
    fontFamily: "Abel",
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: whiteColor);

const TextStyle text10GreyScale100 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: greyScale100Color);

const TextStyle text10GrayScale70 = TextStyle(
    letterSpacing: 0,
    fontFamily: "Abel",
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: greyScale70Color);




