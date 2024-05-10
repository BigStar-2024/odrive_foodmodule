import "package:flutter/material.dart";

class MyAppTheme {
  final TextTheme textTheme;

  const MyAppTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff006b5f),
      surfaceTint: Color(0xff006b5f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9ff2e2),
      onPrimaryContainer: Color(0xff00201c),
      secondary: Color(0xff4a635e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcde8e1),
      onSecondaryContainer: Color(0xff06201c),
      tertiary: Color(0xff456179),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffcbe6ff),
      onTertiaryContainer: Color(0xff001e30),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfff4fbf8),
      onBackground: Color(0xff171d1b),
      surface: Color(0xfff4fbf8),
      onSurface: Color(0xff171d1b),
      surfaceVariant: Color(0xffdae5e1),
      onSurfaceVariant: Color(0xff3f4946),
      outline: Color(0xff6f7976),
      outlineVariant: Color(0xffbec9c5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3230),
      inverseOnSurface: Color(0xffecf2ef),
      inversePrimary: Color(0xff83d5c6),
      primaryFixed: Color(0xff9ff2e2),
      onPrimaryFixed: Color(0xff00201c),
      primaryFixedDim: Color(0xff83d5c6),
      onPrimaryFixedVariant: Color(0xff005047),
      secondaryFixed: Color(0xffcde8e1),
      onSecondaryFixed: Color(0xff06201c),
      secondaryFixedDim: Color(0xffb1ccc6),
      onSecondaryFixedVariant: Color(0xff334b47),
      tertiaryFixed: Color(0xffcbe6ff),
      onTertiaryFixed: Color(0xff001e30),
      tertiaryFixedDim: Color(0xffaccae5),
      onTertiaryFixedVariant: Color(0xff2c4a60),
      surfaceDim: Color(0xffd5dbd9),
      surfaceBright: Color(0xfff4fbf8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f2),
      surfaceContainer: Color(0xffe9efec),
      surfaceContainerHigh: Color(0xffe3eae7),
      surfaceContainerHighest: Color(0xffdde4e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff83d5c6),
      surfaceTint: Color(0xff83d5c6),
      onPrimary: Color(0xff003731),
      primaryContainer: Color(0xff005047),
      onPrimaryContainer: Color(0xff9ff2e2),
      secondary: Color(0xffb1ccc6),
      onSecondary: Color(0xff1c3530),
      secondaryContainer: Color(0xff334b47),
      onSecondaryContainer: Color(0xffcde8e1),
      tertiary: Color(0xffaccae5),
      onTertiary: Color(0xff143349),
      tertiaryContainer: Color(0xff2c4a60),
      onTertiaryContainer: Color(0xffcbe6ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff0e1513),
      onBackground: Color(0xffdde4e1),
      surface: Color(0xff0e1513),
      onSurface: Color(0xffdde4e1),
      surfaceVariant: Color(0xff3f4946),
      onSurfaceVariant: Color(0xff303030),
      outline: Color(0xff303030),
      outlineVariant: Color(0xff3f4946),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e1),
      inverseOnSurface: Color(0xff2b3230),
      inversePrimary: Color(0xff006b5f),
      primaryFixed: Color(0xff9ff2e2),
      onPrimaryFixed: Color(0xff00201c),
      primaryFixedDim: Color(0xff83d5c6),
      onPrimaryFixedVariant: Color(0xff005047),
      secondaryFixed: Color(0xffcde8e1),
      onSecondaryFixed: Color(0xff06201c),
      secondaryFixedDim: Color(0xffb1ccc6),
      onSecondaryFixedVariant: Color(0xff334b47),
      tertiaryFixed: Color(0xffcbe6ff),
      onTertiaryFixed: Color(0xff001e30),
      tertiaryFixedDim: Color(0xffaccae5),
      onTertiaryFixedVariant: Color(0xff2c4a60),
      surfaceDim: Color(0xff0e1513),
      surfaceBright: Color(0xff343b39),
      surfaceContainerLowest: Color(0xff090f0e),
      surfaceContainerLow: Color(0xff171d1b),
      surfaceContainer: Color(0xff1a211f),
      surfaceContainerHigh: Color(0xff252b2a),
      surfaceContainerHighest: Color(0xff303634),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      shadow: shadow,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
