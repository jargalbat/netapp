import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:netware/app/bloc/push_notif_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/shared_pref_key.dart';
import 'package:netware/app/utils/func.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotifManager {
  PushNotificationBloc pushNotifBloc;

  static PushNotifManager _instance;

  factory PushNotifManager(PushNotificationBloc pushNotifBloc) {
    if (_instance == null) {
      _instance = PushNotifManager._internal(pushNotifBloc);
    }
    return _instance;
  }

  PushNotifManager._internal(PushNotificationBloc pushNotifBloc) {
    this.pushNotifBloc = pushNotifBloc;
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void init() async {
    /// Push notif token
    if (globals.sharedPref == null) globals.sharedPref = await SharedPreferences.getInstance();
    globals.pushNotifToken = Func.toStr(globals.sharedPref.getString(SharedPrefKey.PushNotifToken));
//    globals.pushNotifToken = '';
    print('pushNotifToken: ${globals.pushNotifToken}');

    if (Func.isEmpty(globals.pushNotifToken)) {
      if (Platform.isIOS) {
        _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
        _firebaseMessaging.onIosSettingsRegistered.first.then((settings) {
          if (settings.alert) {
            _firebaseMessaging.getToken().then((token) {
              globals.pushNotifToken = token;
              globals.sharedPref.setString(SharedPrefKey.PushNotifToken, token);
              print('pushNotifToken: ${globals.pushNotifToken}');
            });
          }
        });
      } else if (Platform.isAndroid) {
        _firebaseMessaging.getToken().then((token) {
          globals.pushNotifToken = token;
          globals.sharedPref.setString(SharedPrefKey.PushNotifToken, token);
          print('pushNotifToken: ${globals.pushNotifToken}');
        });
      }
    }

    /// Configure
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      pushNotifBloc.add(PushNotified(PushNotifMsgHandle.onMessage, message));
      return Future.microtask(() => true);
    }, onResume: (Map<String, dynamic> message) {
      pushNotifBloc.add(PushNotified(PushNotifMsgHandle.onResume, message));
      return Future.microtask(() => true);
    }, onLaunch: (Map<String, dynamic> message) {
      pushNotifBloc.add(PushNotified(PushNotifMsgHandle.onLaunch, message));
      return Future.microtask(() => true);
    });
  }

//  void _requestPermissionOniOS() {
//    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
//    _firebaseMessaging.onIosSettingsRegistered.first.then((settings) {
//      if (settings.alert) {
//        _firebaseMessaging.getToken().then((token) => globals.pushNotifToken = token);
//      }
//    });
//  }
}
