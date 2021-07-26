import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class VerifyUserDeviceRequest extends BaseRequest {
  String deviceCode;
  String pushNotifToken;
  String tan;
  String mobileNo;
  String rememberMe;

  VerifyUserDeviceRequest({this.deviceCode, this.pushNotifToken, this.tan, this.mobileNo, this.rememberMe}) {
    this.func = Operation.verifyUserDevice;
  }

  VerifyUserDeviceRequest.fromJson(Map<String, dynamic> json) {
    deviceCode = json['deviceCode'];
    pushNotifToken = json['pushNotifToken'];
    tan = json['tan'];
    mobileNo = json['mobileNo'];
    rememberMe = json['rememberMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceCode'] = this.deviceCode;
    data['pushNotifToken'] = this.pushNotifToken;
    data['tan'] = this.tan;
    data['mobileNo'] = this.mobileNo;
    data['rememberMe'] = this.rememberMe;
    return data;
  }
}
