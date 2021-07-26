import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/base_request.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class TermCondBloc extends Bloc<TermCondEvent, TermCondState> {
  @override
  TermCondState get initialState => TermCondInit();

  @override
  Stream<TermCondState> mapEventToState(TermCondEvent event) async* {
    if (event is GetTermCond) {
      yield* _mapGetTermCondToState();
    }
  }

  Stream<TermCondState> _mapGetTermCondToState() async* {
    try {
      yield TermCondLoading();

      var res = await ApiManager.getTermCond();

      if (res?.resultCode == 0 && !Func.isEmpty(res.termCond)) {
        // Remove first and last chars
        var termCondStr = res.termCond.substring(1);
        termCondStr = termCondStr.substring(0, termCondStr.length - 1);

        yield GetTermCondSuccess(termCondStr: termCondStr);
      } else {
        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? '${globals.text.termCond()} ${globals.text.notFound()}' : res.resultDesc);
      }
    } catch (e) {
      print(e);
      yield ShowSnackBar(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class TermCondEvent extends Equatable {
  TermCondEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class GetTermCond extends TermCondEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class TermCondState extends Equatable {
  TermCondState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class TermCondInit extends TermCondState {}

class TermCondLoading extends TermCondState {}

class GetTermCondSuccess extends TermCondState {
  final String termCondStr;

  GetTermCondSuccess({@required this.termCondStr}) : super([termCondStr]);

  @override
  String toString() {
    return 'GetTermCondSuccess { termCondStr: $termCondStr }';
  }
}

class ShowSnackBar extends TermCondState {
  final String text;

  ShowSnackBar({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'ShowSnackBar { text: $text }';
  }
}
