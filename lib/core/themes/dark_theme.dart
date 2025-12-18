import 'package:flutter/material.dart';
import 'package:tyman/core/constants/colors.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        surface: appDarkBackground,
        primary: appDarkTaskTitle,
        secondary: appDarkBackground,
        tertiary: appDarkPrimary,
        onPrimary: Colors.black,
        onSurface: appDarkTaskTitle,
        onSecondary: lightDesignFirst),
    textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.normal,
          color: lightDesignFourth,
          fontSize: 17,
        ),
        labelLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 15,
        )),
    iconTheme: IconThemeData(color: signCardLight),
    iconButtonTheme: (IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    )),
    cardColor: signCardDark,
    shadowColor: signCardLight,
    unselectedWidgetColor: signCardShadowDark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: appLightTaskTitle,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.dark(
        primary: boxShadowColor,
        secondary: iconColor,
        onPrimary: Colors.white70,
        onSecondary: Colors.white,
      ),
    ));
