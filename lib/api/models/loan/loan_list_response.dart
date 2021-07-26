import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/base_response.dart';

class OnlineLoanListResponse extends BaseResponse {
  Request request;
  List<Acnt> acnts;
  double curLoanTotalBal;
  double curLimit;
  int bonusScore;

  OnlineLoanListResponse({this.request, this.acnts, this.curLoanTotalBal, this.curLimit, this.bonusScore});

  OnlineLoanListResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];

    request = json['request'] != null ? new Request.fromJson(json['request']) : null;
    if (json['acnts'] != null) {
      acnts = new List<Acnt>();
      json['acnts'].forEach((v) {
        acnts.add(new Acnt.fromJson(v));
      });
    }

    curLoanTotalBal = (json['curLoanTotalBal'] ?? 0).toDouble();
    curLimit = (json['curLimit'] ?? 0).toDouble();
    bonusScore = json['bonusScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.request != null) {
      data['request'] = this.request.toJson();
    }
    if (this.acnts != null) {
      data['acnts'] = this.acnts.map((v) => v.toJson()).toList();
    }

    data['curLoanTotalBal'] = this.curLoanTotalBal;
    data['curLimit'] = this.curLimit;
    data['bonusScore'] = this.bonusScore;

    return data;
  }
}

class Request {
  String companyCode;
  int termSize;
  String bankCode;
  int reqAmt;
  int otherFee;
  int advAmt;
  String custCode;
  int advFee;
  String prodCode;
  int createdBy;
  int requestId;
  String createdDatetime;
  String bankAcntNo;
  int approvedAmt;
  String termUnit;
  String status;

  Request(
      {this.companyCode,
      this.termSize,
      this.bankCode,
      this.reqAmt,
      this.otherFee,
      this.advAmt,
      this.custCode,
      this.advFee,
      this.prodCode,
      this.createdBy,
      this.requestId,
      this.createdDatetime,
      this.bankAcntNo,
      this.approvedAmt,
      this.termUnit,
      this.status});

  Request.fromJson(Map<String, dynamic> json) {
    companyCode = json['companyCode'];
    termSize = json['termSize'];
    bankCode = json['bankCode'];
    reqAmt = json['reqAmt'];
    otherFee = json['otherFee'];
    advAmt = json['advAmt'];
    custCode = json['custCode'];
    advFee = json['advFee'];
    prodCode = json['prodCode'];
    createdBy = json['createdBy'];
    requestId = json['requestId'];
    createdDatetime = json['createdDatetime'];
    bankAcntNo = json['bankAcntNo'];
    approvedAmt = json['approvedAmt'];
    termUnit = json['termUnit'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyCode'] = this.companyCode;
    data['termSize'] = this.termSize;
    data['bankCode'] = this.bankCode;
    data['reqAmt'] = this.reqAmt;
    data['otherFee'] = this.otherFee;
    data['advAmt'] = this.advAmt;
    data['custCode'] = this.custCode;
    data['advFee'] = this.advFee;
    data['prodCode'] = this.prodCode;
    data['createdBy'] = this.createdBy;
    data['requestId'] = this.requestId;
    data['createdDatetime'] = this.createdDatetime;
    data['bankAcntNo'] = this.bankAcntNo;
    data['approvedAmt'] = this.approvedAmt;
    data['termUnit'] = this.termUnit;
    data['status'] = this.status;
    return data;
  }
}

