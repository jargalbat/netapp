import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/models/settings/bind_fb_request.dart';
import 'package:netware/api/models/settings/device_list_response.dart';
import 'package:netware/api/models/settings/remove_device_request.dart';
import 'package:netware/api/models/settings/update_profile_request.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';
import 'combobox.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class ComboBloc extends Bloc<ComboEvent, ComboState> {
  @override
  ComboState get initialState => ComboInit();

  @override
  Stream<ComboState> mapEventToState(ComboEvent event) async* {
    if (event is SelectItemEvent) {
      yield* _mapSelectItemEventToState(event.text);
    } else if (event is SelectItemEvent2) {
      yield* _mapSelectItemEvent2ToState(event.text);
    } else if (event is SelectRelativeItemEvent) {
      yield* _mapSelectRelativeItemEventToState(event.text);
    }
  }

  Stream<ComboState> _mapSelectItemEventToState(String text) async* {
    try {
      yield SelectItemState(text: text);
    } catch (e) {
      print(e);
    }
  }

  Stream<ComboState> _mapSelectItemEvent2ToState(String text) async* {
    try {
      yield SelectItemState2(text: text);
    } catch (e) {
      print(e);
    }
  }

  Stream<ComboState> _mapSelectRelativeItemEventToState(String text) async* {
    try {
      yield SelectRelativeItemState(text: text);
    } catch (e) {
      print(e);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class ComboEvent extends Equatable {
  ComboEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class ComboDoneEvent extends ComboEvent {}

class SelectItemEvent extends ComboEvent {
  final String text;

  SelectItemEvent({@required this.text}) : super([text]);

  @override
  String toString() {
    return 'SelectItemEvent { text: $text }';
  }
}

class SelectItemEvent2 extends ComboEvent {
  final String text;

  SelectItemEvent2({@required this.text}) : super([text]);

  @override
  String toString() {
    return 'SelectItemEvent2 { text: $text }';
  }
}

class SelectRelativeItemEvent extends ComboEvent {
  final String text;

  SelectRelativeItemEvent({@required this.text}) : super([text]);

  @override
  String toString() {
    return 'SelectRelativeItemEvent { text: $text }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class ComboState extends Equatable {
  final List<Object> obj;

  ComboState([this.obj]);

  @override
  List<Object> get props => obj;
}

class ComboInit extends ComboState {}

class ComboDoneState extends ComboState {}

class SelectItemState extends ComboState {
  final String text;

  SelectItemState({this.text}) : super([text]);

  @override
  String toString() {
    return 'SelectItemState { text: $text }';
  }
}

class SelectItemState2 extends ComboState {
  final String text;

  SelectItemState2({this.text}) : super([text]);

  @override
  String toString() {
    return 'SelectItemState2 { text: $text }';
  }
}

/// Холбоотой хүмүүс - Таны хэн болох
class SelectRelativeItemState extends ComboState {
  final String text;

  SelectRelativeItemState({this.text}) : super([text]);

  @override
  String toString() {
    return 'SelectRelativeItemState { text: $text }';
  }
}
