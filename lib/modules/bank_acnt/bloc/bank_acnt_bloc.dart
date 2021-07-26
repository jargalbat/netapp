//todo AcntBloc ashiglasan
//import 'package:equatable/equatable.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:netware/api/bloc/api_manager.dart';
//import 'package:netware/api/models/acnt/bank_acnt_list_response.dart';
//import 'package:netware/app/globals.dart';
//import 'package:netware/app/utils/func.dart';
//
///// ---------------------------------------------------------------------------------------------------------------------------------------------------
///// BLOC
///// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
//class BankAcntBloc extends Bloc<BankAcntEvent, BankAcntState> {
//  @override
//  BankAcntState get initialState => BankAcntInit();
//
//  @override
//  Stream<BankAcntState> mapEventToState(BankAcntEvent event) async* {
//    if (event is GetBankAcntList) {
//      yield* _mapGetBankAcntListToState();
//    }
//  }
//
//  /// Бусад банкны дансны жагсаалт авах
//  Stream<BankAcntState> _mapGetBankAcntListToState() async* {
//    try {
//      yield BankAcntLoading();
//
//      var res = await ApiManager.getAcntList();
//      if (res.resultCode == 0) {
//        var bankAcntList = <BankAcnt>[];
//        BankAcnt mainBankAcnt; // Үндсэн данс
//        for (var el in res.bankAcntList) {
//          if (el.isMain == 1) {
//            mainBankAcnt = el;
//          } else {
//            bankAcntList.add(el);
//          }
//        }
//
//        yield GetBankAcntListSuccess(bankAcntList: bankAcntList, mainBankAcnt: mainBankAcnt);
//      } else {
//        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? 'Данс олдсонгүй.' : res.resultDesc); // todo
//      }
//    } catch (e) {
//      print(e);
//      yield ShowSnackBar(text: globals.text.errorOccurred());
//    }
//  }
//}
//
///// ---------------------------------------------------------------------------------------------------------------------------------------------------
///// BLOC EVENTS
///// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
//@immutable
//abstract class BankAcntEvent extends Equatable {
//  BankAcntEvent([this.obj]);
//
//  final List<Object> obj;
//
//  @override
//  List<Object> get props => obj;
//}
//
///// Дансны жагсаалт авах
//class GetBankAcntList extends BankAcntEvent {}
//
///// ---------------------------------------------------------------------------------------------------------------------------------------------------
///// BLOC STATES
///// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
//@immutable
//abstract class BankAcntState extends Equatable {
//  BankAcntState([this.obj]);
//
//  final List<Object> obj;
//
//  @override
//  List<Object> get props => obj;
//}
//
//class BankAcntInit extends BankAcntState {}
//
//class BankAcntLoading extends BankAcntState {}
//
//class GetBankAcntListSuccess extends BankAcntState {
//  GetBankAcntListSuccess({
//    @required this.bankAcntList,
//    this.mainBankAcnt,
//  }) : super([bankAcntList, mainBankAcnt]);
//
//  final List<BankAcnt> bankAcntList;
//  final BankAcnt mainBankAcnt;
//
//  @override
//  List<Object> get props => [bankAcntList, mainBankAcnt];
//
//  @override
//  String toString() {
//    return 'GetBankAcntListSuccess { acntList: $bankAcntList, mainBankAcnt: $mainBankAcnt }';
//  }
//}
//
//class ShowSnackBar extends BankAcntState {
//  final String text;
//
//  ShowSnackBar({this.text}) : super([text]);
//
//  @override
//  List<Object> get props => [text];
//
//  @override
//  String toString() {
//    return 'ShowSnackBar { text: $text }';
//  }
import 'package:netware/app/bloc/acnt_bloc.dart';

//}
