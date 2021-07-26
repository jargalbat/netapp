import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_helper.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/api/models/loan/limit_fee_score_response.dart';
import 'package:netware/api/models/net_point/use_bonus_fee_request.dart';
import 'package:netware/api/models/net_point/use_bonus_limit_request.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class FeeScoreBloc extends Bloc<FeeScoreEvent, FeeScoreState> {
  @override
  FeeScoreState get initialState => LimitFeeScoreInit();

  @override
  Stream<FeeScoreState> mapEventToState(FeeScoreEvent event) async* {
    if (event is GetFeeScore) {
      yield* _mapGetFeeScoreToState();
    } else if (event is UseBonusLimit) {
      yield* _mapUseBonusLimitToState();
    } else if (event is UseBonusFee) {
      yield* _mapUseBonusFeeToState();
    }
  }

  Stream<FeeScoreState> _mapGetFeeScoreToState() async* {
    try {
      yield LimitFeeScoreLoading();

      // test
//      if (globals.feeScore != null) {
//      yield GetLimitFeeScoreSuccess(limitFeeScoreResponse: globals.feeScore);
//      }

      FeeScoreResponse response = await ApiManager.getLimitFeeScore();
      if (response.resultCode == ResponseCode.Success) {
        globals.feeScore = response;
        yield GetLimitFeeScoreSuccess(limitFeeScoreResponse: response);
      } else {
        yield FeeScoreFailed(text: Func.isNotEmpty(response.resultDesc) ? response.resultDesc : globals.text.noData());
      }
    } catch (e) {
      yield FeeScoreFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<FeeScoreState> _mapUseBonusLimitToState() async* {
    try {
      yield LimitFeeScoreLoading();

      UseBonusLimitRequest request = UseBonusLimitRequest()..score = globals.feeScore.useMinScore;
      var res = await ApiManager.useBonusLimit(request);

      if (res?.resultCode == ResponseCode.Success) {
        yield UseBonusLimitSuccess();
      } else {
        yield FeeScoreFailed(text: Func.isNotEmpty(res?.resultDesc) ? res.resultDesc : globals.text.requestFailed());
      }
    } catch (e) {
      print(e);
      yield FeeScoreFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<FeeScoreState> _mapUseBonusFeeToState() async* {
    try {
      yield LimitFeeScoreLoading();

      UseBonusFeeRequest request = UseBonusFeeRequest()..score = globals.feeScore.useMinScore;
      var res = await ApiManager.useBonusFee(request);

      if (res?.resultCode == ResponseCode.Success) {
        yield UseBonusFeeSuccess();
      } else {
        yield FeeScoreFailed(text: Func.isNotEmpty(res?.resultDesc) ? res.resultDesc : globals.text.requestFailed());
      }
    } catch (e) {
      print(e);
      yield FeeScoreFailed(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class FeeScoreEvent extends Equatable {
  FeeScoreEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

// Харилцагчийн зээлийн лимит, шимтгэл, онооны мэдээллийг авах
class GetFeeScore extends FeeScoreEvent {}

// Бонус оноог зээлийн лимит өсгөхөд ашиглах
class UseBonusLimit extends FeeScoreEvent {}

// Бонус оноог зээлийн шимтгэл бууруулахад ашиглах
class UseBonusFee extends FeeScoreEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class FeeScoreState extends Equatable {
  FeeScoreState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class LimitFeeScoreInit extends FeeScoreState {}

class LimitFeeScoreLoading extends FeeScoreState {}

class GetLimitFeeScoreSuccess extends FeeScoreState {
  GetLimitFeeScoreSuccess({@required this.limitFeeScoreResponse}) : super([limitFeeScoreResponse]);

  final FeeScoreResponse limitFeeScoreResponse;

  @override
  String toString() {
    return 'FeeScoreFailed { limitFeeScoreResponse: $limitFeeScoreResponse }';
  }
}

class UseBonusLimitSuccess extends FeeScoreState {}

class UseBonusFeeSuccess extends FeeScoreState {}

class FeeScoreFailed extends FeeScoreState {
  final String text;

  FeeScoreFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'FeeScoreFailed { text: $text }';
  }
}
