import 'package:flutter/material.dart';
import 'package:netware/app/assets/font_asset.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';

enum ThemeKey { LIGHT, DARK }

class Themes {
  static LinearGradient get bgAccentGradient => LinearGradient(
      colors: [Colors.white, Colors.white],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static ThemeData get appTheme => ThemeData(
      brightness: (globals?.theme ?? ThemeKey.LIGHT) == ThemeKey.LIGHT
          ? Brightness.light
          : Brightness.dark,

      // Generator: http://mcg.mbitson.com/#!?mcgpalette0=%233f51b5
      primarySwatch: (globals?.theme ?? ThemeKey.LIGHT) == ThemeKey.LIGHT
          ? MaterialColor(0XFF0053CD, <int, Color>{
              50: Color(0xFFe0eaf9),
              100: Color(0xFFb3cbf0),
              200: Color(0xFF80a9e6),
              300: Color(0xFF4d87dc),
              400: Color(0xFF266dd5),
              500: Color(0xFF0053cd),
              600: Color(0xFF004cc8),
              700: Color(0xFF0042c1),
              800: Color(0xFF0039ba),
              900: Color(0xFF0029ae),
            })
          : MaterialColor(0XFF0053CD, <int, Color>{
              50: Color(0xFFe0eaf9),
              100: Color(0xFFb3cbf0),
              200: Color(0xFF80a9e6),
              300: Color(0xFF4d87dc),
              400: Color(0xFF266dd5),
              500: Color(0xFF0053cd),
              600: Color(0xFF004cc8),
              700: Color(0xFF0042c1),
              800: Color(0xFF0039ba),
              900: Color(0xFF0029ae),
            }),
      primaryColor: (globals?.theme ?? ThemeKey.LIGHT) == ThemeKey.LIGHT
          ? AppColors.blue
          : AppColors.blue,
      accentColor: (globals?.theme ?? ThemeKey.LIGHT) == ThemeKey.LIGHT
          ? AppColors.blue
          : AppColors.blue,
      scaffoldBackgroundColor: AppColors.bgGrey,
      fontFamily: FontAsset.SFProDisplay,
      dialogTheme: DialogTheme(
          titleTextStyle: TextStyle(), contentTextStyle: TextStyle()));
}

/// Color contrast
//  100% - FF
//  95% - F2
//  90% - E6
//  85% - D9
//  80% - CC
//  75% - BF
//  70% - B3
//  65% - A6
//  60% - 99
//  55% - 8C
//  50% - 80
//  45% - 73
//  40% - 66
//  35% - 59
//  30% - 4D
//  25% - 40
//  20% - 33
//  15% - 26
//  10% - 1A
//  5% - 0D
//  0% - 00

/// TextTheme arguments
//  NAME       SIZE   WEIGHT   SPACING  2018 NAME
//  display4   112.0  thin     0.0      headline1
//  display3   56.0   normal   0.0      headline2
//  display2   45.0   normal   0.0      headline3
//  display1   34.0   normal   0.0      headline4
//  headline   24.0   normal   0.0      headline5
//  title      20.0   medium   0.0      headline6
//  subhead    16.0   normal   0.0      subtitle1
//  body2      14.0   medium   0.0      body1 - Энгийн текст
//  body1      14.0   normal   0.0      body2 - Энгийн текст
//  caption    12.0   normal   0.0      caption - Энгийн текст
//  button     14.0   medium   0.0      button
//  subtitle   14.0   medium   0.0      subtitle2
//  overline   10.0   normal   0.0      overline
