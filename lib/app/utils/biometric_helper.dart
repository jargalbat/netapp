import 'dart:io';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricHelper {
  var localAuth = LocalAuthentication();
  bool canCheckBiometrics = false;
  bool hasAvailableBiometrics = false;

  static const iosStrings = const IOSAuthMessages(
      cancelButton: 'cancel',
      goToSettingsButton: 'settings',
      goToSettingsDescription: 'Please set up your Touch ID.',
      lockOut: 'Please reenable your Touch ID');

  // Strings
//  var androidStrings = AndroidAuthMessages(
//    fingerprintHint: ' ',
//    //Touch sensor
//    fingerprintNotRecognized: loc.fpnotrecognized(),
//    //Fingerprint not recognized. Try again
//    fingerprintSuccess: loc.success(),
//    //Fingerprint recognized.
//    cancelButton: loc.btnCancel(),
//    signInTitle: loc.loginByBiometric(),
//    //Fingerprint Authentication
//    fingerprintRequiredTitle: loc.fpRequired(),
//    //Fingerprint required
//    goToSettingsButton: loc.goToSettings(),
//    // Go to settings
//    goToSettingsDescription: loc.goToSettingsDescription(),
//  );
//
//  var iosStrings = IOSAuthMessages(
//    lockOut: loc.lockOut(),
//    goToSettingsButton: loc.goToSettings(),
//    goToSettingsDescription: loc.goToSettingsDescriptionIOS(),
//    cancelButton: loc.btnOk(),
//  );

  BiometricHelper() {
    initBiometric();
  }

  initBiometric() async {
    try {
      // Тухайн төхөөрөмж biometric-тэй эсэх
      canCheckBiometrics = await localAuth.canCheckBiometrics;

      // Тухайн төхөөрөмжид идэвхтэй ажиллаж байгаа биометр байгаа эсэх
      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics = <BiometricType>[];
        availableBiometrics = await localAuth.getAvailableBiometrics();
        hasAvailableBiometrics = availableBiometrics.length > 0 ? true : false;
      }

      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
        }
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
      }
    }
  }

  Future<bool> checkBiometrics() async {
    bool didAuthenticate = false;

    try {
      didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: 'Biometric test',
        useErrorDialogs: true,
        // stickyAuth state нь хэзээ ч дуусдаггүй. өмнө нь прогресс ажиллаж байсан бол түүнийг дахиж дуудна. хэрэв давхар дуудвал алдаа гарна.
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
      }
    }

    return didAuthenticate;
  }

  void _cancelAuthentication() {
    localAuth.stopAuthentication();
  }
}
