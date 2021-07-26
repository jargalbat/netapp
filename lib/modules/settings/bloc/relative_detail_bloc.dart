import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/api/models/settings/add_relative_request.dart';
import 'package:netware/api/models/settings/remove_relative_request.dart';
import 'package:netware/api/models/settings/update_relative_request.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class RelativeDetailBloc extends Bloc<RelativeDetailEvent, RelativeDetailState> {
  @override
  RelativeDetailState get initialState => RelativeDetailInit();

  @override
  Stream<RelativeDetailState> mapEventToState(RelativeDetailEvent event) async* {
    if (event is GetRelativeComboList) {
      yield* _mapGetRelativeComboListToState();
    } else if (event is UpdateRelative) {
      yield* _mapUpdateRelativeToState(event.request);
    } else if (event is RemoveRelative) {
      yield* _mapRemoveRelativeToState(event.relativeId);
    }
  }

  Stream<RelativeDetailState> _mapGetRelativeComboListToState() async* {
    try {
      yield RelativeDetailLoading();

      List<DictionaryData> dictionaryList = await DictionaryManager.getDictionaryData(DictionaryCode.relative);

      if (dictionaryList.isNotEmpty) {
        List<ComboItem> relativeComboList = DictionaryManager.getComboItemList(dictionaryList);
        yield GetRelativeComboListSuccess(relativeComboList: relativeComboList);
      } else {
        yield RelativeDetailShowSnackBar(text: globals.text.noData());
      }
    } catch (e) {
      yield RelativeDetailShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  Stream<RelativeDetailState> _mapUpdateRelativeToState(UpdateRelativeRequest req) async* {
    try {
      yield RelativeDetailLoading();

      var res = await ApiManager.updateRelative(req);

      if (res?.resultCode == 0) {
        yield UpdateRelativeSuccess();
      } else {
        yield UpdateRelativeFailed(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield RelativeDetailShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  Stream<RelativeDetailState> _mapRemoveRelativeToState(int relativeId) async* {
    try {
      yield RelativeDetailLoading();

      var req = RemoveRelativeRequest()..relativeId = relativeId;
      var res = await ApiManager.deleteRelative(req);

      if (res?.resultCode == 0) {
        yield RemoveRelativeSuccess();
      } else {
        yield RemoveRelativeFailed(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield RelativeDetailShowSnackBar(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class RelativeDetailEvent extends Equatable {
  RelativeDetailEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class GetRelativeComboList extends RelativeDetailEvent {}

/// Update relative
class UpdateRelative extends RelativeDetailEvent {
  final UpdateRelativeRequest request;

  UpdateRelative({@required this.request}) : assert(request != null);

  @override
  String toString() {
    return 'UpdateRelative { request: request }';
  }
}

/// Remove relative
class RemoveRelative extends RelativeDetailEvent {
  final int relativeId;

  RemoveRelative({@required this.relativeId}) : assert(relativeId != null);

  @override
  String toString() {
    return 'RemoveRelative { relativeId: relativeId }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class RelativeDetailState extends Equatable {
  RelativeDetailState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class RelativeDetailInit extends RelativeDetailState {}

class RelativeDetailLoading extends RelativeDetailState {}

class GetRelativeComboListSuccess extends RelativeDetailState {
  final List<ComboItem> relativeComboList;

  GetRelativeComboListSuccess({@required this.relativeComboList}) : super([relativeComboList]);

  @override
  String toString() {
    return 'GetRelativeComboListSuccess { relativeComboList: $relativeComboList }';
  }
}

class UpdateRelativeSuccess extends RelativeDetailState {}

class UpdateRelativeFailed extends RelativeDetailState {
  final String text;

  UpdateRelativeFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'UpdateRelativeFailed { text: $text }';
  }
}

class RemoveRelativeSuccess extends RelativeDetailState {}

class RemoveRelativeFailed extends RelativeDetailState {
  final String text;

  RemoveRelativeFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'RemoveRelativeFailed { text: $text }';
  }
}

class RelativeDetailShowSnackBar extends RelativeDetailState {
  final String text;

  RelativeDetailShowSnackBar({this.text}) : super([text]);

  @override
  String toString() {
    return 'RelativeDetailShowSnackBar { text: $text }';
  }
}
