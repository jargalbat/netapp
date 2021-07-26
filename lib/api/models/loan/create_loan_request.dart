import 'package:netware/api/bloc/operation.dart';
import 'package:netware/api/models/base_request.dart';

class CreateLoanRequest extends BaseRequest {
  double reqAmt;
  int termSize;
  String bankCode;
  String bankAcntNo;

  CreateLoanRequest({this.reqAmt}) {
    this.func = Operation.createLoanRequest;
  }

  CreateLoanRequest.fromJson(Map<String, dynamic> json) {
    reqAmt = json['reqAmt'];
    termSize = json['termSize'];
    bankCode = json['bankCode'];
    bankAcntNo = json['bankAcntNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reqAmt'] = this.reqAmt;
    data['termSize'] = this.termSize;
    data['bankCode'] = this.bankCode;
    data['bankAcntNo'] = this.bankAcntNo;

    base(data);

    return data;
  }
}
