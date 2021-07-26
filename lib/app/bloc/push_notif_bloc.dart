import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

enum PushNotifMsgHandle { onMessage, onLaunch, onResume }

class PushNotificationBloc extends Bloc<PushNotificationEvent, PushNotificationState> {
//  final AppBloc appBloc;
//  final LoyaltyPointBloc loyaltyPointBloc;
//  final NotifCountBloc notifCountBloc;
//  final DashboardBloc dashboardBloc;

//  PushNotificationBloc(this.appBloc, this.loyaltyPointBloc, this.dashboardBloc, this.notifCountBloc);

  PushNotificationBloc();

  @override
  PushNotificationState get initialState => PushNotificationInitialing();

  @override
  Stream<PushNotificationState> mapEventToState(
    PushNotificationEvent event,
  ) async* {
    if (event is PushNotified) {
      yield* _mapPushNotifiedToState(event);
    }
  }

  Stream<PushNotificationState> _mapPushNotifiedToState(PushNotified event) async* {
    print('$runtimeType _mapPushNotifiedToState ${event.message}');

    Map<String, dynamic> msgMap = Map<String, dynamic>.from(event.message);
    String msg = 'test';
//    PushNotifMessage msg = parseMsg(msgMap);
//    print('$runtimeType parseMsg ${msg.toString()}');

    RouteSettings route = RouteSettings(
      name: "",
    );

    if (msg == null) return;

    switch (event.msgHandle) {
      case PushNotifMsgHandle.onMessage:
      case PushNotifMsgHandle.onLaunch:
      case PushNotifMsgHandle.onResume:
//        switch (msg.jsonData?.eventCode) {
//          case PNJsonData.LOAN_RESPONSE:
//            //todo
//            break;
//          case PNJsonData.CASA_CREDITED:
//            //todo
//            break;
//          case PNJsonData.LOYALTY_ADDED:
//            if (app.user.loggedIn)
//              loyaltyPointBloc.add(LoyaltyPointChanged(loyaltyPoint: Func.toDouble(msg.jsonData.loyaltyPoint), mode: LoyaltyPointMode.push));
//            break;
//
//          default:
//            if (!Func.isNullEmpty(msg.loanId) && !Func.isNullEmpty(msg.loanStatus)) {
//              if (app.user.loggedIn) route = RouteSettings(name: Routes.LoanList);
//            }
//
//            break;
//        }
        break;
    }

//    yield PushNotifying(event.msgHandle, msg, route);
    yield PushNotifying(event.msgHandle);
  }

//  PushNotifMessage parseMsg(Map<String, dynamic> message) {
//    PushNotifMessage msg;
//    try {
//      //{notification: {title: Хадгаламж нээсэн урамшуулал 5 оноо олгов., body: Loyalty},
//      // data: {
//      //     jsonData: {"eventCode":"LOYALTY_ADDED","loyaltyPoint":80},
//      //     acntId: , instId: , loanId: ,
//      //     body: Хадгаламж нээсэн урамшуулал 5 оноо олгов.,
//      //     icon: 1, loanStatus: , badge: 1,
//      //      sound: enabled,
//      //      title: Loyalty,
//      //      click_action: FLUTTER_NOTIFICATION_CLICK}}
//
//      msg = PushNotifMessage.fromJson(message);
//    } catch (_) {
//      print('$runtimeType parseMsg $_');
//    }
//
//    return msg;
//  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class PushNotificationEvent extends Equatable {
  PushNotificationEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class PushNotificationInit extends PushNotificationEvent {
  @override
  String toString() => 'PushNotificationInit';
}

class PushNotified extends PushNotificationEvent {
  final PushNotifMsgHandle msgHandle;
  final Map<String, dynamic> message;

  PushNotified(this.msgHandle, this.message) : super([msgHandle, message]);

  @override
  String toString() => 'PushNotified { msgHandle: $msgHandle, message: $message}';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PushNotificationState extends Equatable {
  PushNotificationState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;

  @override
  String toString() => 'PushNotificationState { obj: $obj }';
}

class PushNotificationInitialing extends PushNotificationState {
  PushNotificationInitialing() : super([]);

  @override
  String toString() => 'PushNotificationInitialing ${super.toString()}';
}

class PushNotifying extends PushNotificationState {
  PushNotifying(this.msgHandle) : super([msgHandle]);

  final PushNotifMsgHandle msgHandle;

//  final PushNotifMessage message;
//  final RouteSettings route;

//  PushNotifying(this.msgHandle, this.message, this.route) : super([msgHandle, message, route]);

  @override
  String toString() => 'PushNotifying ${super.toString()}';
}
