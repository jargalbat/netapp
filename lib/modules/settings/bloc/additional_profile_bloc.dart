import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/models/customer/update_cust_addition_request.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AdditionalProfileBloc extends Bloc<AdditionalProfileEvent, AdditionalProfileState> {
  @override
  AdditionalProfileState get initialState => ProfileAdditionalInit();

  @override
  Stream<AdditionalProfileState> mapEventToState(AdditionalProfileEvent event) async* {
    if (event is GetDictEdu) {
      yield* _mapGetDictEduToState();
    } else if (event is GetDictHomeType) {
      yield* _mapGetDictHomeTypeToState();
    } else if (event is GetDictHomeOwnership) {
      yield* _mapGetDictHomeOwnershipToState();
    } else if (event is GetDictWorkPlace) {
      yield* _mapGetDictWorkPlaceToState();
    } else if (event is GetDictWorkPosition) {
      yield* _mapGetDictWorkPositionToState();
    } else if (event is GetNumbersList) {
      yield* _mapGetNumbersListToState();
    } else if (event is InsertAdditionalProfile) {
      yield* _mapInsertAdditionalProfileToState(event.request);
    }
  }

  /// Dictionary - Боловсрол
  Stream<AdditionalProfileState> _mapGetDictEduToState() async* {
    try {
//      yield ProfileAdditionalLoading();

      List<DictionaryData> dictionaryList = await DictionaryManager.getDictionaryData(DictionaryCode.edu);

      if (dictionaryList.isNotEmpty) {
        List<ComboItem> comboList = DictionaryManager.getComboItemList(dictionaryList);
        yield GetDictEduSuccess(comboList: comboList);
      } else {
        yield PaShowSnackBar(text: globals.text.noData());
      }
    } catch (e) {
      yield PaShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  /// Dictionary - Орон сууцны төрөл
  Stream<AdditionalProfileState> _mapGetDictHomeTypeToState() async* {
    try {
//      yield ProfileAdditionalLoading();

      List<DictionaryData> dictionaryList = await DictionaryManager.getDictionaryData(DictionaryCode.homeType);

      if (dictionaryList.isNotEmpty) {
        List<ComboItem> comboList = DictionaryManager.getComboItemList(dictionaryList);
        yield GetDictHomeTypeSuccess(comboList: comboList);
      } else {
        yield PaShowSnackBar(text: globals.text.noData());
      }
    } catch (e) {
      yield PaShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  /// Dictionary - Хаягийн эзэмшлийн байдал
  Stream<AdditionalProfileState> _mapGetDictHomeOwnershipToState() async* {
    try {
//      yield ProfileAdditionalLoading();

      List<DictionaryData> dictionaryList = await DictionaryManager.getDictionaryData(DictionaryCode.homeOwnership);

//      dictionaryList = List<DictionaryData>()
//        ..add(DictionaryData()
//          ..orderNo = 0
//          ..txt = 'Өөрөө эзэмшдэг'
//          ..val = 'owner')
//        ..add(DictionaryData()
//          ..orderNo = 1
//          ..txt = 'Хамтран эзэмшдэг'
//          ..val = 'partner');

      if (dictionaryList.isNotEmpty) {
        List<ComboItem> comboList = DictionaryManager.getComboItemList(dictionaryList);
        yield GetDictHomeOwnershipSuccess(comboList: comboList);
      } else {
        yield PaShowSnackBar(text: globals.text.noData());
      }
    } catch (e) {
      yield PaShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  /// Dictionary - Ажлын газар
  Stream<AdditionalProfileState> _mapGetDictWorkPlaceToState() async* {
    try {
//      yield ProfileAdditionalLoading();

      List<DictionaryData> dictionaryList = await DictionaryManager.getDictionaryData(DictionaryCode.employmentType);

      if (dictionaryList.isNotEmpty) {
        List<ComboItem> comboList = DictionaryManager.getComboItemList(dictionaryList);
        yield GetDictWorkPlaceSuccess(comboList: comboList);
      } else {
        yield PaShowSnackBar(text: globals.text.noData());
      }
    } catch (e) {
      yield PaShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  /// Dictionary - Албан тушаал
  Stream<AdditionalProfileState> _mapGetDictWorkPositionToState() async* {
    try {
//      yield ProfileAdditionalLoading();

      List<DictionaryData> dictionaryList = await DictionaryManager.getDictionaryData(DictionaryCode.workPosition);

      if (dictionaryList.isNotEmpty) {
        List<ComboItem> comboList = DictionaryManager.getComboItemList(dictionaryList);
        yield GetDictWorkPositionSuccess(comboList: comboList);
      } else {
        yield PaShowSnackBar(text: globals.text.noData());
      }
    } catch (e) {
      yield PaShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  /// Dictionary - Албан тушаал
  Stream<AdditionalProfileState> _mapGetNumbersListToState() async* {
    try {
//      yield ProfileAdditionalLoading();

      List<ComboItem> comboList = List<ComboItem>()
        ..add(ComboItem()
          ..txt = '1'
          ..val = 1)
        ..add(ComboItem()
          ..txt = '2'
          ..val = 2)
        ..add(ComboItem()
          ..txt = '3'
          ..val = 3)
        ..add(ComboItem()
          ..txt = '4'
          ..val = 4)
        ..add(ComboItem()
          ..txt = globals.text.higherThan().replaceAll(AppHelper.textHolder, '5')
          ..val = 5);

      yield GetNumbersListSuccess(comboList: comboList);
    } catch (e) {
      yield PaShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  /// Харилцагчийн нэмэлт мэдээлэл хадгалах
  Stream<AdditionalProfileState> _mapInsertAdditionalProfileToState(UpdateCustAdditionRequest req) async* {
    try {
      yield ProfileAdditionalLoading();
      var res = await ApiManager.updateCustAddition(req);
      if (res?.resultCode == 0) {
        yield InsertAdditionalProfileSuccess();
      } else {
        yield InsertAdditionalProfileFailed(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield PaShowSnackBar(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class AdditionalProfileEvent extends Equatable {
  AdditionalProfileEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

// Dictionary - Боловсрол
class GetDictEdu extends AdditionalProfileEvent {}

// Dictionary - Орон сууцны төрөл
class GetDictHomeType extends AdditionalProfileEvent {}

// Dictionary - Хаягийн эзэмшлийн байдал
class GetDictHomeOwnership extends AdditionalProfileEvent {}

// Dictionary - Ажлын газар
class GetDictWorkPlace extends AdditionalProfileEvent {}

// Dictionary - Албан тушаал
class GetDictWorkPosition extends AdditionalProfileEvent {}

// Dictionary - Ам бүл, Өрхийн орлоготой гишүүдийн тоо
class GetNumbersList extends AdditionalProfileEvent {}

// Харилцагчийн нэмэлт мэдээлэл хадгалах
class InsertAdditionalProfile extends AdditionalProfileEvent {
  final UpdateCustAdditionRequest request;

  InsertAdditionalProfile({@required this.request}) : assert(request != null);

  @override
  String toString() {
    return 'InsertAdditionalProfileData { request: $request }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class AdditionalProfileState extends Equatable {
  AdditionalProfileState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class ProfileAdditionalInit extends AdditionalProfileState {}

class ProfileAdditionalLoading extends AdditionalProfileState {}

class GetDictEduSuccess extends AdditionalProfileState {
  final List<ComboItem> comboList;

  GetDictEduSuccess({@required this.comboList}) : super([comboList]);

  @override
  String toString() {
    return 'GetDictEduSuccess { comboList: $comboList }';
  }
}

class GetDictHomeTypeSuccess extends AdditionalProfileState {
  final List<ComboItem> comboList;

  GetDictHomeTypeSuccess({@required this.comboList}) : super([comboList]);

  @override
  String toString() {
    return 'GetDictHomeTypeSuccess { comboList: $comboList }';
  }
}

class GetDictHomeOwnershipSuccess extends AdditionalProfileState {
  final List<ComboItem> comboList;

  GetDictHomeOwnershipSuccess({@required this.comboList}) : super([comboList]);

  @override
  String toString() {
    return 'GetDictHomeOwnership { comboList: $comboList }';
  }
}

class GetDictWorkPlaceSuccess extends AdditionalProfileState {
  final List<ComboItem> comboList;

  GetDictWorkPlaceSuccess({@required this.comboList}) : super([comboList]);

  @override
  String toString() {
    return 'GetDictWorkPlaceSuccess { comboList: $comboList }';
  }
}

class GetDictWorkPositionSuccess extends AdditionalProfileState {
  final List<ComboItem> comboList;

  GetDictWorkPositionSuccess({@required this.comboList}) : super([comboList]);

  @override
  String toString() {
    return 'GetDictWorkPositionSuccess { comboList: $comboList }';
  }
}

class GetNumbersListSuccess extends AdditionalProfileState {
  final List<ComboItem> comboList;

  GetNumbersListSuccess({@required this.comboList}) : super([comboList]);

  @override
  String toString() {
    return 'GetNumbersListSuccess { comboList: $comboList }';
  }
}

class InsertAdditionalProfileSuccess extends AdditionalProfileState {}

class InsertAdditionalProfileFailed extends AdditionalProfileState {
  final String text;

  InsertAdditionalProfileFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'InsertAdditionalProfileFailed { text: $text }';
  }
}

class PaShowSnackBar extends AdditionalProfileState {
  final String text;

  PaShowSnackBar({this.text}) : super([text]);

  @override
  String toString() {
    return 'RelativeDetailShowSnackBar { text: $text }';
  }
}
