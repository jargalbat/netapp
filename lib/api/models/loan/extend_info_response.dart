import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/acnt/rcv_acnts.dart';
import 'package:netware/api/models/base_response.dart';

import 'fees.dart';

class ExtendInfoResponse extends BaseResponse {
  List<Fees> fees;
  Acnt acnt;
  List<RcvAcnts> rcvAcnts;
  String extendReminder;
  String paymentCode;
  double totalPay;

  ExtendInfoResponse({this.fees, this.acnt, this.rcvAcnts, this.extendReminder, this.paymentCode});

  ExtendInfoResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];

    if (json['fees'] != null) {
      fees = new List<Fees>();
      json['fees'].forEach((v) {
        fees.add(new Fees.fromJson(v));
      });
    }
    acnt = json['acnt'] != null ? new Acnt.fromJson(json['acnt']) : null;
    if (json['rcvAcnts'] != null) {
      rcvAcnts = new List<RcvAcnts>();
      json['rcvAcnts'].forEach((v) {
        rcvAcnts.add(new RcvAcnts.fromJson(v));
      });
    }
    extendReminder = json['extendReminder'];
    paymentCode = json['paymentCode'];

    totalPay = (json['totalPay'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fees != null) {
      data['fees'] = this.fees.map((v) => v.toJson()).toList();
    }
    if (this.acnt != null) {
      data['acnt'] = this.acnt.toJson();
    }
    if (this.rcvAcnts != null) {
      data['rcvAcnts'] = this.rcvAcnts.map((v) => v.toJson()).toList();
    }
    data['extendReminder'] = this.extendReminder;
    data['paymentCode'] = this.paymentCode;
    data['totalPay'] = this.totalPay;
    return data;
  }
}
