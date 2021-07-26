import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class VerifyTanRequest extends BaseRequest {
  String userKey;
  String tanNo;
  String deviceCode;
  String deviceName;
  String pushNotifToken;

  VerifyTanRequest({this.userKey, this.tanNo, this.deviceCode, this.deviceName, this.pushNotifToken}) {
    this.func = Operation.stepVerifyTAN;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userKey'] = this.userKey;
    data['tanNo'] = this.tanNo;
    data['deviceCode'] = this.deviceCode;
    data['deviceName'] = this.deviceName;
    data['pushNotifToken'] = this.pushNotifToken;

    /// base data
    base(data);

    return data;
  }
}
