import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/settings/bind_fb_request.dart';
import 'package:netware/api/models/settings/update_biometric_request.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  @override
  SettingsState get initialState => SettingsInit();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is BindFb) {
      yield* _mapBindFbToState(fbId: event.fbId, fbName: event.fbName);
    } else if (event is UnbindFb) {
      yield* _mapUnbindFbToState();
    } else if (event is UpdateBiometricEvent) {
      yield* _mapUpdateBiometricEventToState(event);
    }
  }

  /// Facebook холбох
  Stream<SettingsState> _mapBindFbToState({String fbId, String fbName}) async* {
    try {
      yield SettingsLoading();

      var req = BindFbRequest()
        ..fbId = fbId
        ..fbName = fbName;

      var res = await ApiManager.bindFb(req);

      if (res?.resultCode == 0) {
        globals.user.fbId = fbId;
        globals.user.fbName = fbName;
        yield BindFbSuccess(fbId: fbId, fbName: fbName);
      } else {
        yield BindFbFailed(text: Func.isEmpty(res?.resultDesc) ? globals.text.success() : res.resultDesc);
      }
    } catch (e) {
      print(e);
      yield BindFbFailed(text: globals.text.requestFailed());
    }
  }

  /// Facebook салгах
  Stream<SettingsState> _mapUnbindFbToState() async* {
    try {
      yield SettingsLoading();

      var res = await ApiManager.unbindFb();

      if (res?.resultCode == 0) {
        globals.user.fbId = '';
        globals.user.fbName = '';
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<SettingsState> _mapUpdateBiometricEventToState(UpdateBiometricEvent event) async* {
    try {
      yield SettingsLoading();

      UpdateBiometricRequest request = UpdateBiometricRequest()
        ..deviceCode = event.deviceCode
        ..biometricAuth = event.biometricAuth;

      var res = await ApiManager.updateBiometric(request);

      if (res?.resultCode == 0) {
        yield UpdateBiometricSuccess();
      } else {
        yield UpdateBiometricFailed(text: Func.isNotEmpty(res.resultDesc) ? res.resultDesc : globals.text.requestFailed());
      }
    } catch (e) {
      print(e);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class SettingsEvent extends Equatable {
  SettingsEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Facebook холбох
class BindFb extends SettingsEvent {
  final String fbId;
  final String fbName;

  BindFb({@required this.fbId, @required this.fbName})
      : assert(fbId != null),
        assert(fbName != null),
        super([fbId, fbName]);

  @override
  String toString() {
    return 'BindFb { fbId: $fbId, fbName: $fbName }';
  }
}

/// Facebook салгах
class UnbindFb extends SettingsEvent {}

/// Биометр холбох, салгах
class UpdateBiometricEvent extends SettingsEvent {
  UpdateBiometricEvent({@required this.deviceCode, @required this.biometricAuth}) : super([deviceCode, biometricAuth]);

  final String deviceCode;
  final int biometricAuth;

  @override
  String toString() {
    return 'UpdateBiometric { deviceCode: $deviceCode, biometricAuth: $biometricAuth }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class SettingsState extends Equatable {
  SettingsState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class SettingsInit extends SettingsState {}

class SettingsLoading extends SettingsState {}

/// Facebook холболт амжилттай
class BindFbSuccess extends SettingsState {
  final String fbId;
  final String fbName;

  BindFbSuccess({this.fbId, this.fbName}) : super([fbId, fbName]);

  @override
  List<Object> get props => [fbId, fbName];

  @override
  String toString() {
    return 'BindFbSuccess { fbId: $fbId, fbName: $fbName }';
  }
}

/// Facebook холболт амжилтгүй
class BindFbFailed extends SettingsState {
  final String text;

  BindFbFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'BindFbFailed { text: $text }';
  }
}

/// Facebook холболт амжилттай
class UpdateBiometricSuccess extends SettingsState {}

/// Facebook холболт амжилтгүй
class UpdateBiometricFailed extends SettingsState {
  final String text;

  UpdateBiometricFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'UpdateBiometricFailed { text: $text }';
  }
}

class ShowSnackBar extends SettingsState {
  final String text;

  ShowSnackBar({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'ShowFailedToast { text: $text }';
  }
}
