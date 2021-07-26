import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/models/loan/loan_prod_response.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class GetLoanBloc extends Bloc<GetLoanEvent, GetLoanState> {
  @override
  GetLoanState get initialState => GetLoanInit();

  @override
  Stream<GetLoanState> mapEventToState(GetLoanEvent event) async* {
    if (event is GetLoanProd) {
      yield* _mapGetLoanProdToState();
    }
  }

  Stream<GetLoanState> _mapGetLoanProdToState({String fbId, String fbName}) async* {
    try {
      yield GetLoanLoading();

      var res = await ApiManager.getLoanProd();

      if (res?.resultCode == 0 && res.prod != null && res.terms != null && res.terms.isNotEmpty) {
        yield GetLoanProdSuccess(loanProdResponse: res);
      } else {
        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? globals.text.noData() : res.resultDesc); // todo
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
abstract class GetLoanEvent extends Equatable {
  GetLoanEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Зээлийн бүтээгдэхүүн авах
class GetLoanProd extends GetLoanEvent {}

/// Facebook салгах
class UnbindFb extends GetLoanEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class GetLoanState extends Equatable {
  GetLoanState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class GetLoanInit extends GetLoanState {}

class GetLoanLoading extends GetLoanState {}

/// Зээлийн бүтээгдэхүүн амжилттай авсан
class GetLoanProdSuccess extends GetLoanState {
  final LoanProdResponse loanProdResponse;

  GetLoanProdSuccess({@required this.loanProdResponse}) : super([loanProdResponse]);

  @override
  List<Object> get props => [loanProdResponse];

  @override
  String toString() {
    return 'GetLoanProdSuccess { res: $loanProdResponse }';
  }
}

class ShowSnackBar extends GetLoanState {
  final String text;

  ShowSnackBar({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'ShowSnackBar { text: $text }';
  }
}
