import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/acnt/rcv_acnts.dart';
import 'package:netware/api/models/base_response.dart';

class OfflinePayInfoResponse extends BaseResponse {
  double totalPay;
  String paymentCode;
  Acnt acnt;
  List<RcvAcnts> rcvAcnts;
  double totalPayQpay;

  OfflinePayInfoResponse(
      {this.totalPay,
      this.paymentCode,
      this.acnt,
      this.rcvAcnts,
      this.totalPayQpay});

  OfflinePayInfoResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];

    totalPay = (json['totalPay'] ?? 0).toDouble();
    paymentCode = json['paymentCode'];
    acnt = json['acnt'] != null ? new Acnt.fromJson(json['acnt']) : null;
    if (json['rcvAcnts'] != null) {
      rcvAcnts = new List<RcvAcnts>();
      json['rcvAcnts'].forEach((v) {
        rcvAcnts.add(new RcvAcnts.fromJson(v));
      });
    }

    totalPayQpay = (json['totalPayQpay'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalPay'] = this.totalPay;
    data['paymentCode'] = this.paymentCode;
    if (this.acnt != null) {
      data['acnt'] = this.acnt.toJson();
    }
    if (this.rcvAcnts != null) {
      data['rcvAcnts'] = this.rcvAcnts.map((v) => v.toJson()).toList();
    }
    data['totalPayQpay'] = this.totalPayQpay;

    return data;
  }
}
