import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_helper.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/acnt/get_acnt_detail_request.dart';
import 'package:netware/api/models/acnt/get_acnt_detail_response.dart';
import 'package:netware/api/models/base_response.dart';
import 'package:netware/api/models/loan/extend_info_response.dart';
import 'package:netware/api/models/loan/get_extend_info_request.dart';
import 'package:netware/api/models/loan/get_pay_info_offline_request.dart';
import 'package:netware/api/models/loan/get_pay_info_request.dart';
import 'package:netware/api/models/loan/offline_pay_info_response.dart';
import 'package:netware/api/models/loan/online_pay_info_response.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AcntDetailBloc extends Bloc<AcntDetailEvent, AcntDetailState> {
  @override
  AcntDetailState get initialState => AcntDetailInit();

  @override
  Stream<AcntDetailState> mapEventToState(AcntDetailEvent event) async* {
    if (event is GetOnlineAcntDetailEvent) {
      yield* _mapGetOnlineAcntDetailEventToState(event.onlineAcntNo);
    } else if (event is GetOfflineAcntDetailEvent) {
      yield* _mapGetOfflineAcntDetailEventToState(event.offlineAcntNo);
    } else if (event is GetPayInfoOnlineEvent) {
      yield* _mapGetPayInfoOnlineEventToState(event.onlineAcntNo);
    } else if (event is GetPayInfoOfflineEvent) {
      yield* _mapGetPayInfoOfflineEventToState(event.offlineAcntNo);
    } else if (event is GetExtendLoanInfo) {
      yield* _mapGetExtendLoanInfoToState(event.acntNo);
    }
  }

  Stream<AcntDetailState> _mapGetOnlineAcntDetailEventToState(String acntNo) async* {
    try {
      yield AcntDetailLoading();

      var request = GetAcntDetailRequest()..acntNo = Func.toStr(acntNo);
      var res = await ApiManager.getAcntDetail(request);

      String test = '';
      if (res?.resultCode == 0) {
        yield AcntDetailSuccess(acntDetail: res);
      } else {
        yield AcntDetailFailed(text: Func.isEmpty(res?.resultDesc) ? 'Дансны дэлгэрэнгүй мэдээлэл олдсонгүй.' : res.resultDesc);
      }
    } catch (e) {
      print(e);
      yield AcntDetailFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<AcntDetailState> _mapGetOfflineAcntDetailEventToState(String acntNo) async* {
    try {
      yield AcntDetailLoading();

      var request = GetOfflineAcntDetailRequest()..acntNo = Func.toStr(acntNo);
      var res = await ApiManager.getOfflineAcntDetail(request);

      String test = '';
      if (res?.resultCode == 0) {
        yield AcntDetailSuccess(acntDetail: res);
      } else {
        yield AcntDetailFailed(text: Func.isEmpty(res?.resultDesc) ? 'Дансны дэлгэрэнгүй мэдээлэл олдсонгүй.' : res.resultDesc);
      }
    } catch (e) {
      print(e);
      yield AcntDetailFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<AcntDetailState> _mapGetPayInfoOnlineEventToState(String onlineAcntNo) async* {
    try {
      yield AcntDetailLoading();

      var request = GetPayInfoOnlineRequest()..acntNo = Func.toStr(onlineAcntNo);
      OnlinePayInfoResponse res = await ApiManager.getPayInfoOnline(request);

      if (res?.resultCode == 0 && res.rcvAcnts != null && res.rcvAcnts.isNotEmpty) {
        var rcvAcntComboList = <ComboItem>[];
        for (var el in res.rcvAcnts) {
          rcvAcntComboList.add(
            ComboItem()
              ..val = el
              ..txt = el.acntNo
              ..imageAssetName = DictionaryManager.getAssetNameByCode(el.bankCode),
          );
        }

        yield PayInfoOnlineSuccess(onlinePayInfoResponse: res, rcvAcntList: rcvAcntComboList);
      } else {
        yield PayInfoOnlineFailed(text: Func.isEmpty(res?.resultDesc) ? 'Зээл төлөлтийн мэдээлэл олдсонгүй.' : res.resultDesc);
      }

      print('test');
    } catch (e) {
      print(e);
      yield PayInfoOnlineFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<AcntDetailState> _mapGetPayInfoOfflineEventToState(String offlineAcntNo) async* {
    try {
      yield AcntDetailLoading();

      var request = GetPayInfoOfflineRequest()..acntNo = Func.toStr(offlineAcntNo);
      var res = await ApiManager.getPayInfoOffline(request);

      if (res?.resultCode == 0 && res.rcvAcnts != null && res.rcvAcnts.isNotEmpty) {
        var rcvAcntComboList = <ComboItem>[];
        for (var el in res.rcvAcnts) {
          rcvAcntComboList.add(
            ComboItem()
              ..val = el
              ..txt = el.acntNo
              ..imageAssetName = DictionaryManager.getAssetNameByCode(el.bankCode),
          );
        }

        yield PayInfoOfflineSuccess(offlinePayInfoResponse: res, rcvAcntList: rcvAcntComboList);
      } else {
        yield PayInfoOfflineFailed(text: Func.isEmpty(res?.resultDesc) ? 'Зээл төлөлтийн мэдээлэл олдсонгүй.' : res.resultDesc);
      }
    } catch (e) {
      print(e);
      yield PayInfoOfflineFailed(text: globals.text.errorOccurred());
    }
  }

  Stream<AcntDetailState> _mapGetExtendLoanInfoToState(String acntNo) async* {
    try {
      yield AcntDetailLoading();

      var request = GetExtendInfoRequest()..acntNo = Func.toStr(acntNo);
      var res = await ApiManager.getExtendInfo(request);

      if (res?.resultCode == 0 && res.fees != null && res.fees.isNotEmpty) {
        var rcvAcntComboList = <ComboItem>[];
        for (var el in res.rcvAcnts) {
          rcvAcntComboList.add(
            ComboItem()
              ..val = el
              ..txt = el.acntNo
              ..imageAssetName = DictionaryManager.getAssetNameByCode(el.bankCode),
          );
        }

        yield ExtendInfoSuccess(extendInfoResponse: res, rcvAcntList: rcvAcntComboList);
      } else {
        yield ExtendInfoFailed(text: Func.isEmpty(res?.resultDesc) ? 'Зээлийн мэдээлэл олдсонгүй.' : res.resultDesc);
      }
    } catch (e) {
      print(e);
      yield ExtendInfoFailed(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class AcntDetailEvent extends Equatable {
  AcntDetailEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Онлайн дансны дэлгэрэнгүй мэдээлэл
class GetOnlineAcntDetailEvent extends AcntDetailEvent {
  final String onlineAcntNo;

  GetOnlineAcntDetailEvent({@required this.onlineAcntNo}) : super([onlineAcntNo]);

  @override
  String toString() {
    return 'GetOnlineAcntDetailEvent { onlineAcntNo: $onlineAcntNo }';
  }
}

/// Офлайн дансны дэлгэрэнгүй мэдээлэл
class GetOfflineAcntDetailEvent extends AcntDetailEvent {
  final String offlineAcntNo;

  GetOfflineAcntDetailEvent({@required this.offlineAcntNo}) : super([offlineAcntNo]);

  @override
  String toString() {
    return 'GetOfflineAcntDetailEvent { offlineAcntNo: $offlineAcntNo }';
  }
}

/// Онлайн дансны төлөлтийн дэлгэрэнгүй мэдээлэл
class GetPayInfoOnlineEvent extends AcntDetailEvent {
  final String onlineAcntNo;

  GetPayInfoOnlineEvent({@required this.onlineAcntNo}) : super([onlineAcntNo]);

  @override
  String toString() {
    return 'GetPayInfoOnlineEvent { onlineAcntNo: $onlineAcntNo }';
  }
}

/// Офлайн дансны төлөлтийн дэлгэрэнгүй мэдээлэл
class GetPayInfoOfflineEvent extends AcntDetailEvent {
  final String offlineAcntNo;

  GetPayInfoOfflineEvent({@required this.offlineAcntNo}) : super([offlineAcntNo]);

  @override
  String toString() {
    return 'GetPayInfoOfflineEvent { offlineAcntNo: $offlineAcntNo }';
  }
}

/// Зээлийн хугацаа сунгах шимтгэлийн мэдээлэл авах
class GetExtendLoanInfo extends AcntDetailEvent {
  final String acntNo;

  GetExtendLoanInfo({@required this.acntNo}) : super([acntNo]);

  @override
  String toString() {
    return 'GetExtendLoanInfo { acntNo: $acntNo }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class AcntDetailState extends Equatable {
  AcntDetailState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class AcntDetailInit extends AcntDetailState {}

class AcntDetailLoading extends AcntDetailState {}

class AcntDetailSuccess extends AcntDetailState {
  final AcntDetailResponse acntDetail;

  AcntDetailSuccess({@required this.acntDetail}) : super([acntDetail]);

  @override
  String toString() {
    return 'AcntDetailSuccess { GetAcntDetailResponse: $acntDetail }';
  }
}

class PayInfoOnlineSuccess extends AcntDetailState {
  final OnlinePayInfoResponse onlinePayInfoResponse;
  final List<ComboItem> rcvAcntList;

  PayInfoOnlineSuccess({@required this.onlinePayInfoResponse, this.rcvAcntList}) : super([onlinePayInfoResponse, rcvAcntList]);

  @override
  String toString() {
    return 'PayInfoOnlineSuccess { onlinePayInfoResponse: $onlinePayInfoResponse }';
  }
}

class PayInfoOnlineFailed extends AcntDetailState {
  final String text;

  PayInfoOnlineFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'PayInfoOnlineFailed { text: $text }';
  }
}

class PayInfoOfflineSuccess extends AcntDetailState {
  final OfflinePayInfoResponse offlinePayInfoResponse;
  final List<ComboItem> rcvAcntList;

  PayInfoOfflineSuccess({@required this.offlinePayInfoResponse, this.rcvAcntList}) : super([offlinePayInfoResponse, rcvAcntList]);

  @override
  String toString() {
    return 'PayInfoOfflineSuccess { offlinePayInfoResponse: $offlinePayInfoResponse }';
  }
}

class PayInfoOfflineFailed extends AcntDetailState {
  final String text;

  PayInfoOfflineFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'PayInfoOfflineFailed { text: $text }';
  }
}

class AcntDetailFailed extends AcntDetailState {
  final String text;

  AcntDetailFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'AcntDetailFailed { text: $text }';
  }
}

/// Зээлийн бүтээгдэхүүн амжилттай авсан
class ExtendInfoSuccess extends AcntDetailState {
  final ExtendInfoResponse extendInfoResponse;
  final List<ComboItem> rcvAcntList;

  ExtendInfoSuccess({@required this.extendInfoResponse, this.rcvAcntList}) : super([extendInfoResponse, rcvAcntList]);

  @override
  String toString() {
    return 'ExtendInfoResponse { extendInfoResponse: $extendInfoResponse, rcvAcntList: $rcvAcntList }';
  }
}

class ExtendInfoFailed extends AcntDetailState {
  final String text;

  ExtendInfoFailed({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'ExtendInfoFailed { text: $text }';
  }
}
