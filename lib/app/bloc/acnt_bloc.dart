import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/acnt/bank_acnt_list_response.dart';
import 'package:netware/api/models/acnt/remove_bank_acnt_request.dart';
import 'package:netware/api/models/acnt/update_bank_acnt_request.dart';
import 'package:netware/api/models/loan/loan_list_response.dart';
import 'package:netware/api/models/loan/offline_loan_list_response.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AcntBloc extends Bloc<AcntEvent, AcntState> {
  @override
  AcntState get initialState => AcntInit();

  @override
  Stream<AcntState> mapEventToState(AcntEvent event) async* {
    if (event is GetOnlineLoanList) {
      yield* _mapGetOnlineLoanListToState();
    } else if (event is GetOfflineLoanList) {
      yield* _mapGetOfflineLoanListToState();
    } else if (event is GetBankAcntList) {
      yield* _mapGetBankAcntListToState();
    } else if (event is CalcLoanTotalBal) {
      yield* _mapCalcLoanTotalBalToState();
    } else if (event is RemoveBankAcntEvent) {
      yield* _mapRemoveBankAcntToState(event.bankCode);
    } else if (event is UpdateBankAcntEvent) {
      yield* _mapUpdateBankAcntEventToState(event);
    }
  }

  Stream<AcntState> _mapGetOnlineLoanListToState() async* {
    try {
      yield OnlineLoanListLoading();

      // test
//      if (globals.onlineLoanList != null) {
//        globals.onlineLoanList.acnts.add(globals.onlineLoanList.acnts[0]);
//        yield OnlineLoanListSuccess(onlineLoanListResponse: globals.onlineLoanList);
//        return;
//      }

      var res = await ApiManager.getLoanList();

      if (res?.resultCode == 0) {
        globals.onlineLoanList = res;

        yield OnlineLoanListSuccess(onlineLoanListResponse: res);
      } else {
        yield OnlineLoanListFailed(text: Func.isEmpty(res?.resultDesc) ? 'Зээлийн мэдээлэл олдсонгүй.' : res.resultDesc);
      }

      yield AcntDone();
    } catch (e) {
      print(e);
      yield OnlineLoanListFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<AcntState> _mapGetOfflineLoanListToState() async* {
    try {
      yield OfflineLoanListLoading();
      globals.currentBlocEvent = 'OfflineLoanListLoading'; // Хүсэлт маш удаан ирж буй учир түр зогсоов

      var res = await ApiManager.getLoanAcntsOffline();
      if (res?.resultCode == 0) {
        globals.offlineLoanList = res;
        yield OfflineLoanListSuccess(offlineLoanListResponse: res);
        globals.currentBlocEvent = 'OfflineLoanListSuccess';
      } else {
        yield OfflineLoanListFailed(text: Func.isEmpty(res?.resultDesc) ? 'Зээлийн мэдээлэл олдсонгүй.' : res.resultDesc);
        globals.currentBlocEvent = 'OfflineLoanListFailed';
      }

      yield AcntDone();
    } catch (e) {
      print(e);
      yield OfflineLoanListFailed(text: globals.text.errorOccurred());
      globals.currentBlocEvent = 'OfflineLoanListFailed';
    }
  }

  Stream<AcntState> _mapCalcLoanTotalBalToState() async* {
    try {
      double loanTotalBal = 0.0;
      int onlineLoanCount = 0;
      int offlineLoanCount = 0;
      int activeLoanCount = 0;

      // Онлайн зээл
      if (globals.onlineLoanList != null) {
        // Total bal
        loanTotalBal += (globals.onlineLoanList.curLoanTotalBal ?? 0.0);

        // Active loan count
        if (globals.onlineLoanList.acnts != null) {
          onlineLoanCount += globals.onlineLoanList.acnts.length;
        }
      }

      // Оффлайн зээл
      if (globals.offlineLoanList != null) {
        // Total bal
        loanTotalBal += (globals.offlineLoanList.curLoanTotalBal ?? 0.0);

        // Active loan count
        if (globals.offlineLoanList.acnts != null) {
          offlineLoanCount = globals.offlineLoanList.acnts.length;
        }
      }

      activeLoanCount = onlineLoanCount + offlineLoanCount;

      yield CalculatedLoanTotalBal(
        loanTotalBal: loanTotalBal,
        activeLoanCount: activeLoanCount,
        onlineLoanCount: onlineLoanCount,
        offlineLoanCount: offlineLoanCount,
      );
    } catch (e) {
      print(e);
      yield AcntFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<AcntState> _mapGetBankAcntListToState() async* {
    try {
      yield BankAcntLoading();

      var res = await ApiManager.getBankAcntList();
      if (res.resultCode == 0) {
        var bankAcntList = <BankAcnt>[];
        var bankAcntComboList = <ComboItem>[];

        BankAcnt mainBankAcnt; // Үндсэн данс
        if (res.bankAcntList != null && res.bankAcntList.isNotEmpty) {
          for (var el in res.bankAcntList) {
            if (el.isMain == 1) {
              mainBankAcnt = el;
            } else {
              bankAcntList.add(el);
            }

            bankAcntComboList.add(
              ComboItem()
                ..val = el
                ..txt = el.acntNo
                ..imageAssetName = DictionaryManager.getAssetNameByCode(el.bankCode),
            );
          }

          globals.bankAcntList = bankAcntList;
          yield BankAcntSuccess(bankAcntList: bankAcntList, bankAcntComboList: bankAcntComboList, mainBankAcnt: mainBankAcnt);
        } else {
          yield BankAcntNotFound();
        }
      } else {
        yield BankAcntFailed(text: Func.isEmpty(res?.resultDesc) ? globals.text.noData() : res.resultDesc); // todo
      }
    } catch (e) {
      print(e);
      yield BankAcntFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<AcntState> _mapRemoveBankAcntToState(String bankCode) async* {
    try {
      yield BankAcntLoading();

      var req = RemoveBankAcntRequest()..bankCode = bankCode;
      var res = await ApiManager.deleteBankAcnt(req);

      if (res?.resultCode == 0) {
        yield RemoveBankAcntSuccess();
      } else {
        yield RemoveBankAcntFailed(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield RemoveBankAcntFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<AcntState> _mapUpdateBankAcntEventToState(UpdateBankAcntEvent event) async* {
    try {
      yield BankAcntLoading();

      var req = UpdateBankAcntRequest()
        ..custCode = event.custCode
        ..bankCode = event.bankCode
        ..isMain = event.isMain;
      var res = await ApiManager.updateBankAcnt(req);

      if (res?.resultCode == 0) {
        yield UpdateBankAcntSuccess();
      } else {
        yield UpdateBankAcntFailed(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield UpdateBankAcntFailed(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class AcntEvent extends Equatable {
  AcntEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Зээлийн дансны жагсаалт, хүсэлт, нийт үлдэгдэл, лимит, бонус оноо авах
class GetOnlineLoanList extends AcntEvent {}

/// Уламжлалт зээлийн дансны жагсаалт авах
class GetOfflineLoanList extends AcntEvent {}

/// Нийт зээлийн үлдэгдлийг тооцоолж харуулах (Онлайн зээл + Офлайн зээл)
class CalcLoanTotalBal extends AcntEvent {}

/// Банкны дансны жагсаалт авах
class GetBankAcntList extends AcntEvent {}

class RemoveBankAcntEvent extends AcntEvent {
  final String bankCode;

  RemoveBankAcntEvent({this.bankCode}) : super([bankCode]);

  @override
  String toString() {
    return 'RemoveBankAcntEvent { bankCode: $bankCode }';
  }
}

class UpdateBankAcntEvent extends AcntEvent {
  final String custCode;
  final String bankCode;
  final int isMain;

  UpdateBankAcntEvent({this.custCode, this.bankCode, this.isMain}) : super([custCode, bankCode, isMain]);

  @override
  String toString() {
    return 'UpdateBankAcntEvent { custCode: $custCode, bankCode: $bankCode, isMain: $isMain }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class AcntState extends Equatable {
  AcntState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class AcntInit extends AcntState {}

class AcntLoading extends AcntState {}

class AcntDone extends AcntState {}

class AcntFailed extends AcntState {
  final String text;

  AcntFailed({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'AcntFailed { text: $text }';
  }
}

/// Online loan
class OnlineLoanListLoading extends AcntState {}

class OnlineLoanListSuccess extends AcntState {
  final OnlineLoanListResponse onlineLoanListResponse;

  OnlineLoanListSuccess({@required this.onlineLoanListResponse}) : super([onlineLoanListResponse]);

  @override
  String toString() {
    return 'OnlineLoanListSuccess { onlineLoanListResponse: $onlineLoanListResponse }';
  }
}

class OnlineLoanListFailed extends AcntState {
  final String text;

  OnlineLoanListFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'OnlineLoanListFailed { text: $text }';
  }
}

/// Offline loan
class OfflineLoanListLoading extends AcntState {}

class OfflineLoanListSuccess extends AcntState {
  final OfflineLoanListResponse offlineLoanListResponse;

  OfflineLoanListSuccess({@required this.offlineLoanListResponse}) : super([offlineLoanListResponse]);

  @override
  String toString() {
    return 'OfflineLoanListSuccess { res: $offlineLoanListResponse }';
  }
}

class OfflineLoanListFailed extends AcntState {
  final String text;

  OfflineLoanListFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'OfflineLoanListFailed { text: $text }';
  }
}

/// Calculate loan total balance and loan count
class CalculatedLoanTotalBal extends AcntState {
  CalculatedLoanTotalBal({
    this.loanTotalBal,
    this.activeLoanCount,
    this.onlineLoanCount,
    this.offlineLoanCount,
  }) : super([
          loanTotalBal,
          activeLoanCount,
          onlineLoanCount,
          offlineLoanCount,
        ]);

  final double loanTotalBal;
  final int activeLoanCount;
  final int onlineLoanCount;
  final int offlineLoanCount;

  @override
  String toString() {
    return 'CalculatedLoanTotalBal { loanTotalBalance: $loanTotalBal, '
        'loanCount: $activeLoanCount, onlineLoanCount: $onlineLoanCount, offlineLoanCount: $offlineLoanCount }';
  }
}

/// Bank acnt
class BankAcntLoading extends AcntState {}

class BankAcntSuccess extends AcntState {
  BankAcntSuccess({
    @required this.bankAcntList,
    this.bankAcntComboList,
    this.mainBankAcnt,
  }) : super([
          bankAcntList,
          mainBankAcnt,
        ]);

  final List<BankAcnt> bankAcntList;
  final List<ComboItem> bankAcntComboList;
  final BankAcnt mainBankAcnt;

  @override
  String toString() {
    return 'BankAcntSuccess { acntList: $bankAcntList, bankAcntComboList: $bankAcntComboList, mainBankAcnt: $mainBankAcnt }';
  }
}

class BankAcntNotFound extends AcntState {}

class BankAcntFailed extends AcntState {
  final String text;

  BankAcntFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'BankAcntFailed { text: $text }';
  }
}

class RemoveBankAcntSuccess extends AcntState {}

class RemoveBankAcntFailed extends AcntState {
  final String text;

  RemoveBankAcntFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'RemoveBankAcntFailed { text: $text }';
  }
}

class UpdateBankAcntSuccess extends AcntState {}

class UpdateBankAcntFailed extends AcntState {
  final String text;

  UpdateBankAcntFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'RemoveBankAcntFailed { text: $text }';
  }
}
