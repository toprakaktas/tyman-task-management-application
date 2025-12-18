import 'package:flutter/material.dart';
import 'package:tyman/core/constants/colors.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        surface: appLightBackground,
        primary: signCardDark,
        secondary: settingsBackground,
        tertiary: lightDesignFourth,
        onPrimary: signCardLight,
        onSurface: appLightTaskTitle,
        onSecondary: lightDesignThird),
    textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: appLightTaskTitle,
          fontSize: 20,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.normal,
          color: iconColor,
          fontSize: 17,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.normal,
          color: appLightTaskTitle,
          fontSize: 15,
        )),
    iconTheme: IconThemeData(color: iconColor),
    iconButtonTheme: (IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(appLightTaskTitle),
      ),
    )),
    cardColor: signCardLight,
    shadowColor: signCardShadowLight,
    unselectedWidgetColor: signCardDark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.dark(
        primary: signCardLight,
        secondary: signCardShadowLight,
        onPrimary: Colors.black87,
        onSecondary: Colors.black,
      ),
    ));
