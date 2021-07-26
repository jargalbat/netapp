import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class SendTanRequest extends BaseRequest {
  String userKey;
  String mobileNo;

  SendTanRequest({this.userKey, this.mobileNo}) {
    this.func = Operation.stepSendTAN;
    this.userKey = userKey;
    this.mobileNo = mobileNo;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userKey'] = this.userKey;
    data['mobileNo'] = this.mobileNo;

    /// base data
    base(data);

    return data;
  }
}
