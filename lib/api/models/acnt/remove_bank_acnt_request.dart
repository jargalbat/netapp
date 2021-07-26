import 'package:netware/api/bloc/operation.dart';
import 'package:netware/api/models/base_request.dart';

class RemoveBankAcntRequest extends BaseRequest {
  String bankCode;

  RemoveBankAcntRequest({this.bankCode}) {
    this.func = Operation.deleteBankAcnt;
  }

  RemoveBankAcntRequest.fromJson(Map<String, dynamic> json) {
    bankCode = json['bankCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankCode'] = this.bankCode;

    base(data);

    return data;
  }
}
