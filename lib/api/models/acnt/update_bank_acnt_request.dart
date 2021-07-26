import 'package:netware/api/bloc/operation.dart';
import 'package:netware/api/models/base_request.dart';

class UpdateBankAcntRequest extends BaseRequest {
  String custCode;
  String bankCode;
  int isMain;

  UpdateBankAcntRequest({this.bankCode}) {
    this.func = Operation.updateBankAcnt;
  }

  UpdateBankAcntRequest.fromJson(Map<String, dynamic> json) {
    custCode = json['custCode'];
    bankCode = json['bankCode'];
    isMain = json['isMain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['custCode'] = this.custCode;
    data['bankCode'] = this.bankCode;
    data['isMain'] = this.isMain;

    base(data);

    return data;
  }
}
