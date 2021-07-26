import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_helper.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/models/settings/settings_link_response.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  @override
  HelpState get initialState => HelpInit();

  @override
  Stream<HelpState> mapEventToState(HelpEvent event) async* {
    if (event is GetSettingsLinks) {
      yield* _mapGetSettingsLinksToState();
    }
  }

  Stream<HelpState> _mapGetSettingsLinksToState() async* {
    try {
      yield HelpLoading();

      var res = await ApiManager.getSettingsLinks();

      if (res?.resultCode == 0) {
        res.faq = ApiHelper.baseUrl + '/' + Func.toStr(res.faq);
        res.userGuide = ApiHelper.baseUrl + '/' + Func.toStr(res.userGuide);

        yield GetSettingsLinksSuccess(settingsLinkResponse: res);
      } else {
        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      print(e);
      yield ShowSnackBar(text: globals.text.requestFailed());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class HelpEvent extends Equatable {
  HelpEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class GetSettingsLinks extends HelpEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class HelpState extends Equatable {
  HelpState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class HelpInit extends HelpState {}

class HelpLoading extends HelpState {}

class GetSettingsLinksSuccess extends HelpState {
  final SettingsLinkResponse settingsLinkResponse;

  GetSettingsLinksSuccess({this.settingsLinkResponse}) : super([settingsLinkResponse]);

  @override
  String toString() {
    return 'GetSettingsLinksSuccess { settingsLinkResponse: $settingsLinkResponse }';
  }
}

class ShowSnackBar extends HelpState {
  final String text;

  ShowSnackBar({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'ShowFailedToast { text: $text }';
  }
}
