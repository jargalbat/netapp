import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/acnt/add_bank_acnt_request.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AddBankAcntBloc extends Bloc<AddBankAcntEvent, AddBankAcntState> {
  @override
  AddBankAcntState get initialState => AddBankAcntInit();

  @override
  Stream<AddBankAcntState> mapEventToState(AddBankAcntEvent event) async* {
    if (event is GetBankList) {
      yield* _mapGetBankListToState();
    } else if (event is AddBankAcnt) {
      yield* _mapAddBankAcntToState(event);
    }
  }

  /// Банкны жагсаалт авах
  Stream<AddBankAcntState> _mapGetBankListToState() async* {
    try {
      yield AddBankAcntLoading();

      List<DictionaryData> bankList = await DictionaryManager.getDictionaryData(DictionaryCode.bankList);

      if (bankList.isNotEmpty) {
        yield GetBankListSuccess(bankList: bankList);
      } else {
//        yield ShowSnackBar(text: 'Банкны данс олдсонгүй.'); // todo
      }
    } catch (e) {
      print(e);
      yield ShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  /// Банкны данс нэмэх
  Stream<AddBankAcntState> _mapAddBankAcntToState(AddBankAcnt event) async* {
    try {
      yield AddBankAcntLoading();

      var req = AddBankAcntRequest(
        bankCode: event.bankCode,
        acntNo: event.acntNo,
        curCode: 'MNT',
        acntName: globals.user.firstName,
        isMain: event.isMain,
      );

      var res = await ApiManager.addBankAcnt(req);

      if (res.resultCode == 0) {
        yield AddBankAcntSuccess();
      } else {
        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? 'Амжилтгүй' : res.resultDesc);
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
abstract class AddBankAcntEvent extends Equatable {
  AddBankAcntEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Банкны жагсаалт авах
class GetBankList extends AddBankAcntEvent {}

/// Банк нэмэх
class AddBankAcnt extends AddBankAcntEvent {
  final String bankCode;
  final String acntNo;
  final int isMain;

  AddBankAcnt({
    @required this.bankCode,
    @required this.acntNo,
    @required this.isMain,
  })  : assert(bankCode != null && acntNo != null && isMain != null),
        super([bankCode, isMain]);

  @override
  List<Object> get props => [bankCode, acntNo, isMain];

  @override
  String toString() {
    return 'AddBankAcnt { bankCode: $bankCode, acntNo: $acntNo, isMain: $isMain }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class AddBankAcntState extends Equatable {
  AddBankAcntState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class AddBankAcntInit extends AddBankAcntState {}

class AddBankAcntLoading extends AddBankAcntState {}

class GetBankListSuccess extends AddBankAcntState {
  GetBankListSuccess({@required this.bankList}) : super([bankList]);

  final List<DictionaryData> bankList;

  @override
  List<Object> get props => [bankList];

  @override
  String toString() {
    return 'GetBankListSuccess { bankList: $bankList }';
  }
}

class AddBankAcntSuccess extends AddBankAcntState {}

class ShowSnackBar extends AddBankAcntState {
  final String text;

  ShowSnackBar({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'ShowSnackBar { text: $text }';
  }
}
