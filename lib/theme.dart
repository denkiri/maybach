import "package:flutter/material.dart";
class MaterialTheme {
  final TextTheme textTheme;
  const MaterialTheme(this.textTheme);
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffa900a9),
      surfaceTint: Color(0xffa900a9),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffff00ff),
      onPrimaryContainer: Color(0xff510051),
      secondary: Color(0xff0001bb),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff0000ff),
      onSecondaryContainer: Color(0xffb3b7ff),
      tertiary: Color(0xff026e00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00ff00),
      onTertiaryContainer: Color(0xff027100),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff7f9),
      onSurface: Color(0xff251723),
      onSurfaceVariant: Color(0xff564052),
      outline: Color(0xff897083),
      outlineVariant: Color(0xffdcbed4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3b2c38),
      inversePrimary: Color(0xffffabf3),
      primaryFixed: Color(0xffffd7f5),
      onPrimaryFixed: Color(0xff380038),
      primaryFixedDim: Color(0xffffabf3),
      onPrimaryFixedVariant: Color(0xff810081),
      secondaryFixed: Color(0xffe0e0ff),
      onSecondaryFixed: Color(0xff00006e),
      secondaryFixedDim: Color(0xffbec2ff),
      onSecondaryFixedVariant: Color(0xff0000ef),
      tertiaryFixed: Color(0xff77ff61),
      onTertiaryFixed: Color(0xff002200),
      tertiaryFixedDim: Color(0xff02e600),
      onTertiaryFixedVariant: Color(0xff015300),
      surfaceDim: Color(0xffebd3e4),
      surfaceBright: Color(0xfffff7f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffeff8),
      surfaceContainer: Color(0xffffe7f7),
      surfaceContainerHigh: Color(0xfffae1f2),
      surfaceContainerHighest: Color(0xfff4dcec),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffabf3),
      surfaceTint: Color(0xffffabf3),
      onPrimary: Color(0xff5b005b),
      primaryContainer: Color(0xffff00ff),
      onPrimaryContainer: Color(0xff510051),
      secondary: Color(0xffbec2ff),
      onSecondary: Color(0xff0001ac),
      secondaryContainer: Color(0xff0000ff),
      onSecondaryContainer: Color(0xffb3b7ff),
      tertiary: Color(0xffeaffde),
      onTertiary: Color(0xff013a00),
      tertiaryContainer: Color(0xff00ff00),
      onTertiaryContainer: Color(0xff027100),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1c0f1a),
      onSurface: Color(0xfff4dcec),
      onSurfaceVariant: Color(0xffdcbed4),
      outline: Color(0xffa4899d),
      outlineVariant: Color(0xff564052),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff4dcec),
      inversePrimary: Color(0xffa900a9),
      primaryFixed: Color(0xffffd7f5),
      onPrimaryFixed: Color(0xff380038),
      primaryFixedDim: Color(0xffffabf3),
      onPrimaryFixedVariant: Color(0xff810081),
      secondaryFixed: Color(0xffe0e0ff),
      onSecondaryFixed: Color(0xff00006e),
      secondaryFixedDim: Color(0xffbec2ff),
      onSecondaryFixedVariant: Color(0xff0000ef),
      tertiaryFixed: Color(0xff77ff61),
      onTertiaryFixed: Color(0xff002200),
      tertiaryFixedDim: Color(0xff02e600),
      onTertiaryFixedVariant: Color(0xff015300),
      surfaceDim: Color(0xff1c0f1a),
      surfaceBright: Color(0xff443441),
      surfaceContainerLowest: Color(0xff160a15),
      surfaceContainerLow: Color(0xff251723),
      surfaceContainer: Color(0xff291b27),
      surfaceContainerHigh: Color(0xff342531),
      surfaceContainerHighest: Color(0xff40303c),
    );
  }
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: lightScheme().brightness,
      colorScheme: lightScheme(),
      textTheme: const TextTheme().apply(
        bodyColor: lightScheme().onSurface,
        displayColor: lightScheme().onSurface,
      ),
      scaffoldBackgroundColor: lightScheme().background,
      canvasColor: lightScheme().surface,
    );
  }

  // Dark theme method
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: darkScheme().brightness,
      colorScheme: darkScheme(),
      textTheme: const TextTheme().apply(
        bodyColor: darkScheme().onSurface,
        displayColor: darkScheme().onSurface,
      ),
      scaffoldBackgroundColor: darkScheme().background,
      canvasColor: darkScheme().surface,
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
