import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/api/models/settings/add_relative_request.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AddRelativeBloc extends Bloc<AddRelativeEvent, AddRelativeState> {
  @override
  AddRelativeState get initialState => AddRelativeInit();

  @override
  Stream<AddRelativeState> mapEventToState(AddRelativeEvent event) async* {
    if (event is GetRelativeComboList) {
      yield* _mapGetRelativeComboListToState();
    } else if (event is AddRelative) {
      yield* _mapAddRelativeToState(event.request);
    }
  }

  Stream<AddRelativeState> _mapGetRelativeComboListToState() async* {
    try {
      yield AddRelativeLoading();

      List<DictionaryData> dictionaryList = await DictionaryManager.getDictionaryData(DictionaryCode.relative);

      if (dictionaryList.isNotEmpty) {
        List<ComboItem> relativeComboList = DictionaryManager.getComboItemList(dictionaryList);
        yield GetRelativeComboListSuccess(relativeComboList: relativeComboList);
      } else {
        yield AddRelativeShowSnackBar(text: globals.text.noData());
      }
    } catch (e) {
      yield AddRelativeShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  Stream<AddRelativeState> _mapAddRelativeToState(AddRelativeRequest req) async* {
    try {
      yield AddRelativeLoading();

      var res = await ApiManager.insertRelative(req);

      if (res?.resultCode == 0) {
        yield AddRelativeSuccess();
      } else {
        yield AddRelativeFailed(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield AddRelativeShowSnackBar(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class AddRelativeEvent extends Equatable {
  AddRelativeEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class GetRelativeComboList extends AddRelativeEvent {}

/// Add relative
class AddRelative extends AddRelativeEvent {
  final AddRelativeRequest request;

  AddRelative({@required this.request}) : assert(request != null);

  @override
  String toString() {
    return 'AddRelative { request: request }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class AddRelativeState extends Equatable {
  AddRelativeState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class AddRelativeInit extends AddRelativeState {}

class AddRelativeLoading extends AddRelativeState {}

class GetRelativeComboListSuccess extends AddRelativeState {
  final List<ComboItem> relativeComboList;

  GetRelativeComboListSuccess({@required this.relativeComboList}) : super([relativeComboList]);

  @override
  String toString() {
    return 'GetRelativeComboListSuccess { relativeComboList: $relativeComboList }';
  }
}

class AddRelativeSuccess extends AddRelativeState {}

class AddRelativeFailed extends AddRelativeState {
  final String text;

  AddRelativeFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'AddRelativeFailed { text: $text }';
  }
}

class AddRelativeShowSnackBar extends AddRelativeState {
  final String text;

  AddRelativeShowSnackBar({this.text}) : super([text]);

  @override
  String toString() {
    return 'AddRelativeShowSnackBar { text: $text }';
  }
}
