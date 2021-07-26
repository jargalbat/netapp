import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class AddBankAcntRequest extends BaseRequest {
  AddBankAcntRequest({
    this.bankCode,
    this.acntNo,
    this.curCode,
    this.acntName,
    this.isMain,
  }) {
    this.func = Operation.insertBankAcnt;
  }

  final String bankCode;
  final String acntNo;
  final String curCode;
  final String acntName;
  final int isMain;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['bankCode'] = this.bankCode;
    data['acntNo'] = this.acntNo;
    data['curCode'] = this.curCode;
    data['acntName'] = this.acntName;
    data['isMain'] = this.isMain;

    base(data);

    return data;
  }
}
