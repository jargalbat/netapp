import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/acnt/rcv_acnts.dart';
import 'package:netware/api/models/base_response.dart';

import 'fee_terms.dart';

class OnlinePayInfoResponse extends BaseResponse {
  List<Fees> fees;
  double totalPay;
  String paymentCode;
  Acnt acnt;
  List<RcvAcnts> rcvAcnts;
  String extendReminder;
  double totalPayQpay;

  OnlinePayInfoResponse({
    this.fees,
    this.totalPay,
    this.paymentCode,
    this.acnt,
    this.rcvAcnts,
    this.extendReminder,
    this.totalPayQpay,
  });

  OnlinePayInfoResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];

    if (json['fees'] != null) {
      fees = new List<Fees>();
      json['fees'].forEach((v) {
        fees.add(new Fees.fromJson(v));
      });
    }
    totalPay = (json['totalPay'] ?? 0).toDouble();
    paymentCode = json['paymentCode'];
    acnt = json['acnt'] != null ? new Acnt.fromJson(json['acnt']) : null;
    if (json['rcvAcnts'] != null) {
      rcvAcnts = new List<RcvAcnts>();
      json['rcvAcnts'].forEach((v) {
        rcvAcnts.add(new RcvAcnts.fromJson(v));
      });
    }
    extendReminder = json['extendReminder'];
    totalPayQpay = (json['totalPayQpay'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fees != null) {
      data['fees'] = this.fees.map((v) => v.toJson()).toList();
    }
    data['totalPay'] = this.totalPay;
    data['paymentCode'] = this.paymentCode;
    if (this.acnt != null) {
      data['acnt'] = this.acnt.toJson();
    }
    if (this.rcvAcnts != null) {
      data['rcvAcnts'] = this.rcvAcnts.map((v) => v.toJson()).toList();
    }
    data['extendReminder'] = this.extendReminder;
    data['totalPayQpay'] = this.totalPayQpay;

    return data;
  }
}

class Fees {
  int orderNo;
  int isMain;
  List<FeeTerms> feeTerms;
  String calcType;
  String description;
  int feeId;

  Fees(
      {this.orderNo,
      this.isMain,
      this.feeTerms,
      this.calcType,
      this.description,
      this.feeId});

  Fees.fromJson(Map<String, dynamic> json) {
    orderNo = json['orderNo'];
    isMain = json['isMain'];
    if (json['feeTerms'] != null) {
      feeTerms = new List<FeeTerms>();
      json['feeTerms'].forEach((v) {
        feeTerms.add(new FeeTerms.fromJson(v));
      });
    }
    calcType = json['calcType'];
    description = json['description'];
    feeId = json['feeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNo'] = this.orderNo;
    data['isMain'] = this.isMain;
    if (this.feeTerms != null) {
      data['feeTerms'] = this.feeTerms.map((v) => v.toJson()).toList();
    }
    data['calcType'] = this.calcType;
    data['description'] = this.description;
    data['feeId'] = this.feeId;
    return data;
  }
}
