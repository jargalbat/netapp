import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/settings/relative_list_response.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class RelativeBloc extends Bloc<RelativeEvent, RelativeState> {
  @override
  RelativeState get initialState => RelativeInit();

  @override
  Stream<RelativeState> mapEventToState(RelativeEvent event) async* {
    if (event is GetRelativeList) {
      yield* _mapGetRelativeListToState();
    }
  }

  Stream<RelativeState> _mapGetRelativeListToState() async* {
    try {
      yield RelativeLoading();

      var res = await ApiManager.selectRelative();
      if (res.resultCode == 0) {
        if (res.relativeList != null && res.relativeList.isNotEmpty) {
          yield GetRelativeListSuccess(relativeList: res.relativeList);
        } else {
          yield RelativeListNotFound();
        }
      } else {
        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? '${globals.text.relative()} ${globals.text.notFound()}.' : res.resultDesc);
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
abstract class RelativeEvent extends Equatable {
  RelativeEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class GetRelativeList extends RelativeEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class RelativeState extends Equatable {
  RelativeState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class RelativeInit extends RelativeState {}

class RelativeLoading extends RelativeState {}

class GetRelativeListSuccess extends RelativeState {
  GetRelativeListSuccess({
    @required this.relativeList,
  }) : super([relativeList]);

  final List<Relative> relativeList;

  @override
  List<Object> get props => [relativeList];

  @override
  String toString() {
    return 'GetRelativeListSuccess { relativeList: $relativeList }';
  }
}

class RelativeListNotFound extends RelativeState {}

class ShowSnackBar extends RelativeState {
  final String text;

  ShowSnackBar({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'ShowSnackBar { text: $text }';
  }
}
