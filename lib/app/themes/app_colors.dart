import 'package:flutter/material.dart';
import 'package:netware/app/themes/themes.dart';
import 'package:netware/app/globals.dart';

// http://chir.ag/projects/name-that-color/#0053CD

class AppColors {
  static const Color blue = Color(0XFF0052CC);
  static const Color athensGray = Color(0XFFE4E7EC);
  static const Color athensGrayLight = Color(0XFFFAFBFC);
  static const Color havelockBlue = Color(0XFF78A1E0);
  static const Color slateGray = Color(0XFF7C8799);
  static const Color alabaster = Color(0XFF7C8799);
  static const Color emerald = Color(0XFF4CD964);
  static const Color mirage = Color(0XFF1B2330);
  static const Color doveGrey = Color(0XFF707070);
  static const Color jungleGreen = Color(0XFF29B35A);
  static const Color baliHai = Color(0XFF919FB8);
  static const Color scarlet = Color(0XFFFF3100); // Red
  static const Color regentGray = Color(0XFF8D98AB);
  static const Color dustyGray = Color(0XFF979797);

  /// Background
  static Color get bgWhite {
    return globals.theme == ThemeKey.LIGHT ? Colors.white : Colors.white;
  }

  static Color get bgGrey {
    return globals.theme == ThemeKey.LIGHT ? athensGray : athensGray;
  }

  static Color get bgGreyLight {
    return globals.theme == ThemeKey.LIGHT ? athensGrayLight : athensGrayLight;
  }

  static Color get bgBlue {
    return globals.theme == ThemeKey.LIGHT ? blue : blue;
  }

  /// STATUS BAR
  static Color get statusBarWhite {
    return globals.theme == ThemeKey.LIGHT ? Colors.grey : Colors.grey;
  }

  static Color get statusBarGrey {
    return globals.theme == ThemeKey.LIGHT ? Colors.grey : Colors.grey;
  }

  static Color get statusBarBlue {
    return globals.theme == ThemeKey.LIGHT ? blue : blue;
  }

  /// ICON
  static Color get iconBlue {
    return globals.theme == ThemeKey.LIGHT ? blue : blue;
  }

  static Color get iconWhite {
    return globals.theme == ThemeKey.LIGHT ? Colors.white : Colors.white;
  }

  static Color get iconMirage {
    return globals.theme == ThemeKey.LIGHT ? mirage : mirage;
  }

  static Color get iconDoveGrey {
    return globals.theme == ThemeKey.LIGHT ? doveGrey : doveGrey;
  }

  static Color get iconRegentGrey {
    return globals.theme == ThemeKey.LIGHT ? regentGray : regentGray;
  }

  static Color get iconRed {
    return globals.theme == ThemeKey.LIGHT ? scarlet : scarlet;
  }

  static Color get divider {
    return globals.theme == ThemeKey.LIGHT ? Colors.white : Colors.white;
  }

  /// LABEL
  static Color get lblWhite {
    return globals.theme == ThemeKey.LIGHT ? Colors.white : Colors.white;
  }

  static Color get lblDark {
    return globals.theme == ThemeKey.LIGHT ? mirage : mirage;
  }

  static Color get lblBlack {
    return globals.theme == ThemeKey.LIGHT ? Colors.black87 : Colors.black87;
  }

  static Color get lblScarlet {
    return globals.theme == ThemeKey.LIGHT ? scarlet : scarlet;
  }

  static Color get lblSubtitle {
    return globals.theme == ThemeKey.LIGHT ? slateGray : slateGray;
  }

  static Color get lblGrey {
    return globals.theme == ThemeKey.LIGHT ? regentGray : regentGray;
  }

  static Color get lblLightGrey {
    return globals.theme == ThemeKey.LIGHT ? athensGrayLight : athensGrayLight;
  }

  static Color get lblBlue {
    return globals.theme == ThemeKey.LIGHT ? blue : blue;
  }

  static Color get lblRed {
    return globals.theme == ThemeKey.LIGHT ? scarlet : scarlet;
  }

  /// TEXT BOX
  static Color get txt {
    return globals.theme == ThemeKey.LIGHT ? havelockBlue : havelockBlue;
  }

  static Color get txt2 {
    return globals.theme == ThemeKey.LIGHT ? blue : blue;
  }

  static Color get txtBgGrey {
    return globals.theme == ThemeKey.LIGHT ? athensGrayLight : athensGrayLight;
  }

  static Color get txtBgGreyDark {
    return globals.theme == ThemeKey.LIGHT ? athensGray : athensGray;
  }

  static Color get txtIcon {
    return globals.theme == ThemeKey.LIGHT ? Colors.white : Colors.white;
  }

  static Color get btnGrey {
    return globals.theme == ThemeKey.LIGHT ? athensGray : athensGray;
  }

  static Color get btnGreyDisabled {
    return globals.theme == ThemeKey.LIGHT ? doveGrey : doveGrey;
  }

  static Color get btnDisabled {
    return globals.theme == ThemeKey.LIGHT ? regentGray : regentGray;
  }

  static Color get btnGreyLight {
    return globals.theme == ThemeKey.LIGHT ? athensGrayLight : athensGrayLight;
  }

  static Color get btnBlue {
    return globals.theme == ThemeKey.LIGHT ? blue : blue;
  }

  static Color get chkUnselectedGrey {
    return globals.theme == ThemeKey.LIGHT ? regentGray : regentGray;
  }

  static Color get chkUnselectedWhite {
    return globals.theme == ThemeKey.LIGHT ? Colors.white : Colors.white;
  }

  /// TAB BAR
  static Color get tabSelected {
    return globals.theme == ThemeKey.LIGHT ? blue : blue;
  }

  static Color get imgActive {
    return globals.theme == ThemeKey.LIGHT ? blue : blue;
  }

  static Color get imgInactive {
    return globals.theme == ThemeKey.LIGHT ? baliHai : baliHai;
  }

  /// LINE
  static Color get lineLightGrey {
    return globals.theme == ThemeKey.LIGHT ? dustyGray : dustyGray;
  }

  static Color get lineGrey {
    return globals.theme == ThemeKey.LIGHT ? regentGray : regentGray;
  }

  static Color get lineGreyCard {
    return globals.theme == ThemeKey.LIGHT ? athensGray : athensGray;
  }
}
