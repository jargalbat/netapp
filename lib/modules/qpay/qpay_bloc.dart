import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/qpay/create_qpay_qrcode_request.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class QPayBloc extends Bloc<QPayEvent, QPayState> {
  @override
  QPayState get initialState => GetLoanInit();

  @override
  Stream<QPayState> mapEventToState(QPayEvent event) async* {
    if (event is CreateQpayQrCode) {
      yield* _mapCreateQpayQrCodeToState(event);
    }
  }

  Stream<QPayState> _mapCreateQpayQrCodeToState(CreateQpayQrCode event) async* {
    try {
      yield QPayLoading();

      var request = CreateQpayQrCodeRequest()
        ..acntCode = event.acntCode
        ..termSize = event.termSize
        ..paymentCode = event.paymentCode;

      var res = await ApiManager.createQpayQrCode(request);
      if (res?.resultCode == 0) {
        String deepLink = event.uriScheme + "q?" + "qPay_QRcode=" + Func.toStr(res.qrData) + "&object_type=" + "&object_id=";
        yield QPayQrCodeSuccess(deepLink: deepLink);
      } else {
        yield QPayQrCodeFailed(text: Func.isEmpty(res?.resultDesc) ? 'QR код үүсгэхэд алдаа гарлаа.' : res.resultDesc);
      }
    } catch (e) {
      print(e);
      yield QPayQrCodeFailed(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class QPayEvent extends Equatable {
  QPayEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Зээлийн бүтээгдэхүүн авах
class CreateQpayQrCode extends QPayEvent {
  CreateQpayQrCode({this.uriScheme, this.acntCode, this.termSize, this.paymentCode}) : super([acntCode, termSize, paymentCode]);

  final String uriScheme;
  final String acntCode;
  final int termSize;
  final String paymentCode;

  @override
  String toString() {
    return 'CreateQpayQrCode { uriScheme: $uriScheme, acntCode: $acntCode, termSize: $termSize, paymentCode: $paymentCode }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class QPayState extends Equatable {
  QPayState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class GetLoanInit extends QPayState {}

class QPayLoading extends QPayState {}

class QPayQrCodeSuccess extends QPayState {
  final String deepLink;

  QPayQrCodeSuccess({@required this.deepLink}) : super([deepLink]);

  @override
  List<Object> get props => [deepLink];

  @override
  String toString() {
    return 'QPayQrCodeSuccess { deepLink: $deepLink }';
  }
}

class QPayQrCodeFailed extends QPayState {
  final String text;

  QPayQrCodeFailed({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'QPayQrCodeFailed { text: $text }';
  }
}
