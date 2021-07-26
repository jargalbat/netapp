import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_helper.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/push_notif_helper.dart';
import 'package:netware/main.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AppBloc extends Bloc<AppEvent, AppState> {
  AppState get initialState => AppInitState();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is InitGlobals) {
      yield* _mapInitGlobals();
    } else if (event is ChangeLang) {
      yield* _mapChangeLangToState(event.locale);
    } else if (event is ChangeLangMN) {
      yield* _mapLangMNToState(event.locale);
    } else if (event is ChangeLangEN) {
      yield* _mapLangENToState(event.locale);
    } else if (event is LogoutEvent) {
      yield* _mapLogoutToState();
    }
  }

  Stream<AppState> _mapInitGlobals() async* {
    PushNotifManager(pushNotifBloc)..init();
  }

//  Stream<AppState> _mapShowLoginToState() async* {
////    await justWait(milliseconds: 1500);
//    yield ShowLoginState();
//  }

//  Future<void> justWait({int milliseconds}) async {
//    await Future.delayed(Duration(milliseconds: milliseconds));
//  }

  Stream<AppState> _mapChangeLangToState(Locale locale) async* {
    globals.locale = locale;

//    yield state.localeChanging();
    yield LocaleChangedState(locale: globals.locale);
  }

  Stream<AppState> _mapLangMNToState(Locale locale) async* {
    globals.locale = locale;

//    yield state.localeChanging();
    yield LangMNState(locale: locale);
  }

  Stream<AppState> _mapLangENToState(Locale locale) async* {
    globals.locale = locale;

//    yield state.localeChanging();
    yield LangENState(locale: locale);
  }

  Stream<AppState> _mapLogoutToState() async* {
    globals.clear();
    yield LogoutState();
//    if (connectionManager != null) {
//      connectionManager.init(url: ApiHelper.baseUrl, isInit: true);
//    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class AppEvent extends Equatable {
  AppEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class InitGlobals extends AppEvent {
  @override
  String toString() => 'InitGlobals';
}

//class ShowLogin extends AppEvent {
//  @override
//  String toString() => 'ShowLogin';
//}

class ChangeLang extends AppEvent {
  final Locale locale;

  ChangeLang({@required this.locale}) : super([locale]);

  @override
  String toString() => 'ChangeLang';
}

class ChangeLangMN extends AppEvent {
  final Locale locale;

  ChangeLangMN({@required this.locale}) : super([locale]);

  @override
  String toString() => 'ChangeLang';
}

class ChangeLangEN extends AppEvent {
  final Locale locale;

  ChangeLangEN({@required this.locale}) : super([locale]);

  @override
  String toString() => 'ChangeLang';
}

class LogoutEvent extends AppEvent {
  final bool firstTime;

  LogoutEvent({this.firstTime = false}) : super([firstTime]);

  @override
  String toString() => 'LogoutEvent';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class AppState extends Equatable {
  AppState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class AppInitState extends AppState {}

//class ShowSplashState extends AppState {}
//
//class ShowLoginState extends AppState {}

class AppLoadingState extends AppState {}

class AppFailedState extends AppState {
  final String error;

  AppFailedState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'AppFailure { error: $error }';
}

class LoggedSuccessState extends AppState {}

class LogoutState extends AppState {}

class LocaleChangedState extends AppState {
  final Locale locale;

  LocaleChangedState({@required this.locale});

  @override
  List<Object> get props => [locale];

  @override
  String toString() => 'AppFailure { locale: ${locale.toString()} }';
}

class LangMNState extends AppState {
  final Locale locale;

  LangMNState({@required this.locale});

  @override
  List<Object> get props => [locale];

  @override
  String toString() => 'AppFailure { locale: ${locale.toString()} }';
}

class LangENState extends AppState {
  final Locale locale;

  LangENState({@required this.locale});

  @override
  List<Object> get props => [locale];

  @override
  String toString() => 'LangENState { locale: ${locale.toString()} }';
}
