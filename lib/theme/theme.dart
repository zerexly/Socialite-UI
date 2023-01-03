import 'package:foap/helper/common_import.dart';

enum Font { lato, openSans, poppins, raleway, roboto }
enum DisplayMode { light, dark }

class AppThemeSetting {
  static DisplayMode mode = DisplayMode.light;

  static setDisplayMode(DisplayMode currentMode) {
    mode = currentMode;
  }
}

class AppTheme {
  static String get fontName {
    switch (fontType) {
      case Font.roboto:
        return 'Roboto';
      case Font.raleway:
        return 'Raleway';
      case Font.poppins:
        return 'Poppins';
      case Font.openSans:
        return 'OpenSans';
      case Font.lato:
        return 'Lato';
    }
  }

  static double iconSize = 20;
  static Font fontType = Font.poppins;

  static ThemeData darkTheme = ThemeData(
    backgroundColor: const Color(0xff28292d),
    fontFamily: AppTheme.fontName,
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: FontSizes.sizeXXXXl,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w400),
      displayMedium: TextStyle(
          fontSize: FontSizes.sizeXXXl,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w400),
      displaySmall: TextStyle(
          fontSize: FontSizes.sizeXXl,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(
          fontSize: FontSizes.sizeXl,
          color: const Color(0xffecf0f1),
          fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(
          fontSize: FontSizes.body,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          fontSize: FontSizes.bodySm,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          fontSize: FontSizes.bodyExtraSm,
          color: const Color(0xffecf0f1),
          fontWeight: FontWeight.w400),
      titleMedium: TextStyle(
          fontSize: FontSizes.titleM,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w400),
      titleSmall: TextStyle(
          fontSize: FontSizes.title,
          color: const Color(0xffecf0f1),
          fontWeight: FontWeight.w400),
    ),
    iconTheme: const IconThemeData(color: Color(0xffecf0f1)),
    bottomAppBarColor: const Color(0xffffffff),
    brightness: Brightness.dark,
    hoverColor: const Color(0xffffffff),
    primaryColor: const Color(0xff7ed6df).darken(0.25),
    primaryColorDark: const Color(0xff000000),
    primaryColorLight: const Color(0xff808080),
    shadowColor: const Color(0xff808080),
    dividerColor: const Color(0xfff1f2f6),
    errorColor: const Color(0xffff4757),
    cardColor: const Color(0xff323337),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xff25D1AC),
      disabledColor: Color(0xff808080),
    ),
  );

  static ThemeData lightTheme = ThemeData(
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: FontSizes.sizeXXXXl,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w400),
        displayMedium: TextStyle(
            fontSize: FontSizes.sizeXXXl,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w400),
        displaySmall: TextStyle(
            fontSize: FontSizes.sizeXXl,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(
            fontSize: FontSizes.sizeXl,
            color: const Color(0xff576574),
            fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(
            fontSize: FontSizes.body,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
            fontSize: FontSizes.bodySm,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w400),
        bodySmall: TextStyle(
            fontSize: FontSizes.bodyExtraSm,
            color: const Color(0xff576574),
            fontWeight: FontWeight.w400),
        titleMedium: TextStyle(
            fontSize: FontSizes.titleM,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w400),
        titleSmall: TextStyle(
            fontSize: FontSizes.title,
            color: const Color(0xff576574),
            fontWeight: FontWeight.w400),
      ),
      dividerColor: const Color(0xff747d8c),
      backgroundColor: const Color(0xfff1f2f6).lighten(0.025),
      fontFamily: AppTheme.fontName,
      brightness: Brightness.light,
      hoverColor: const Color(0xff000000),
      primaryColor: const Color(0xff7ed6df).darken(),
      primaryColorDark: const Color(0xff000000),
      primaryColorLight: const Color(0xffecf0f1),
      shadowColor: const Color(0xffa4b0be),
      iconTheme: const IconThemeData(color: Color(0xff000000)),
      bottomAppBarColor: const Color(0xff000000),
      errorColor: const Color(0xffff4757),
      cardColor: const Color(0xffffffff),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xff25D1AC),
        disabledColor: Color(0xff808080),
      ));
}
