import 'dart:math';
import 'package:flutter/material.dart';

const Color cardYellowLight = Color(0xFFFFF7EC);
const Color cardYellow = Color(0xFFFAF0DA);
const Color cardYellowDark = Color(0xFFEBBB7F);

const Color cardRedLight = Color(0xFFFCF0F0);
const Color cardRed = Color(0xFFFBE4E6);
const Color cardRedDark = Color(0xFFF08A8E);

const Color cardBlueLight = Color(0xFFEDF4FE);
const Color cardBlue = Color(0xFFE1EDFC);
const Color cardBlueDark = Color(0xFFC0D3F8);

const Color cardGreenLight = Color(0xFFDCFCE7);
const Color cardGreen = Color(0xFFC7F6D0);
const Color cardGreenDark = Color(0xFF87D1A0);

const Color designBlack = Color(0x85000000);
const Color designGreyDark = Color(0xFF343535);
const Color designGrey = Color(0xFF4C4B4F);
const Color designGreyLight = Color(0xFF7B7B7B);
const Color designWhiteGrey = Color(0xFF999595);

const Color lightDesignFirst = Color(0xFF888888);
const Color lightDesignSecond = Color(0xFF9F9F9F);
const Color lightDesignThird = Color(0xFFAFAFAF);
const Color lightDesignFourth = Color(0xFFD6D6D6);
const Color lightDesignFifth = Color(0xCAEFEFEF);

const Color taskColor = Color(0xFF4695DD);
const Color completeTaskColor = Color(0xCE29813A);
const Color markedTaskColor = Color(0xFF66BB6A);
const Color deleteTaskColor = Color(0xFFF74F43);

const selectedItemColor = Color(0xFF4779BA);
const unselectedItemColor = Color(0xFF999999);
const boxShadowColor = Color(0x339E9E9E);

const settingsBackground = Color(0xFFEFEFEF);

const appLightBackground = Color(0xFFFEFFFF);
const appDarkBackground = Color(0xFF424242);
const appDarkPrimary = Color(0xFF6E6E6E);

const appLightTaskTitle = Color(0xFF333333);
const appDarkTaskTitle = Color(0xFF999999);

const signCardDark = Color(0xFF717171);
const signCardShadowDark = Color(0xFF484848);

const signCardLight = Color(0xFFBCBCBC);
const signCardShadowLight = Color(0xFF6E6E6E);

const iconColor = Color(0xFF272525);

List<Color> gradientBackground = [
  designBlack,
  designGreyDark,
  designGrey,
  designGreyLight,
  designWhiteGrey
];

List<Color> gradientBackgroundLight = [
  lightDesignFirst,
  lightDesignSecond,
  lightDesignThird,
  lightDesignFourth,
  lightDesignFifth,
];

class BackgroundDecoration {
  static final LinearGradient decoration = LinearGradient(
      begin: Alignment.center,
      tileMode: TileMode.mirror,
      colors: gradientBackground,
      transform: const GradientRotation(pi / 4));

  static final LinearGradient lightDecoration = LinearGradient(
      begin: Alignment.center,
      tileMode: TileMode.mirror,
      colors: gradientBackgroundLight,
      transform: const GradientRotation(pi / 4));

  static LinearGradient getGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? decoration : lightDecoration;
  }
}
