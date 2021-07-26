import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:netware/api/models/acnt/bank_acnt_list_response.dart';
import 'package:netware/api/models/loan/limit_fee_score_response.dart';
import 'package:netware/api/models/loan/loan_list_response.dart';
import 'package:netware/api/models/loan/offline_loan_list_response.dart';
import 'package:netware/app/bloc/app_bloc.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/shared_pref_key.dart';
import 'package:netware/app/themes/themes.dart';
import 'package:netware/app/utils/device_helper.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/modules/login/api/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

Globals globals;
final appBloc = AppBloc();

class Globals {
  bool isTest = false;

  static Globals _instance;

  factory Globals({locale}) {
    if (_instance == null) {
      _instance = Globals._internal(locale);
    }
    return _instance;
  }

  Globals._internal(Locale lcl) {
    _init(lcl);
  }

  _init(Locale lcl, {bool isRef = false}) async {
    // Shared pref
    sharedPref = await SharedPreferences.getInstance();

    // Locale
    lcl = lcl ?? Locale(sharedPref?.getString(SharedPrefKey.Locale) ?? LangCode.mn, ''); // Localization.fetchLocale();
    _locale = lcl;
//    _locale = Locale(LangCode.en); //todo test

    // Device id
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceCode = androidInfo.androidId;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      deviceCode = iosInfo.identifierForVendor;
      deviceName = DeviceHelper.getIosDeviceName(iosInfo.model);
    }

    pushNotifToken = Func.toStr(globals.sharedPref.getString(SharedPrefKey.PushNotifToken));
  }

  /// State management
  String currentBlocEvent = '';

  /// Shared pref
  SharedPreferences sharedPref;

  /// Theme
  ThemeKey _themeKey = ThemeKey.LIGHT;

  ThemeKey get theme {
    if (_themeKey == null) _themeKey = ThemeKey.LIGHT;
    return _themeKey;
  }

  set theme(ThemeKey tm) {
    this._themeKey = tm;
    globals.sharedPref?.setString(SharedPrefKey.Theme, tm.toString());
  }

  /// Language
  get langCode => locale.languageCode ?? MN;

//  set langCode(ThemeKey tm) {
//    this._themeKey = tm;
//    SP?.setString(SPKey.APP_THEME, tm.toString());
//  }

  get langId => locale.languageCode == EN ? "1" : "0";
  Locale _locale = Locale(MN);

  Locale get locale {
    return _locale;
  }

  set locale(Locale lcl) {
    _locale = lcl;
    globals.sharedPref?.setString(SharedPrefKey.Locale, lcl.languageCode);
  }

  Iterable<Locale> supportedLocales() => supportedLanguagesCodes.map<Locale>((language) => Locale(language, ''));
  Localization text;

//  Localization get text => _loc;
//  set text(Localization o) {
//    _loc = o;
//  }

  /// User
  UserInfo user = UserInfo();

  /// Device
  String deviceCode;
  String deviceName;
  int biometricAuth;
  String pushNotifToken;

  /// Session
  final int appIdleTimeOutSec = 300; // Удаан хугацаанд үйлдэл хийхгүй бол автоматаар logout хийлгэх хугацаа

  /// Loan
  OnlineLoanListResponse onlineLoanList; // Онлайн зээлийн жагсаалт
  OfflineLoanListResponse offlineLoanList; // Офлайн зээлийн жагсаалт

  /// Cust fee and score
  FeeScoreResponse feeScore;

  /// Bank acnt list
  List<BankAcnt> bankAcntList;

  /// Logout хийхэд харилцагчийн мэдээллийг устгана
  void clear() {
    user = null;
    onlineLoanList = null;
    offlineLoanList = null;
    feeScore = null;
    bankAcntList = null;
    biometricAuth = null;
  }
}
