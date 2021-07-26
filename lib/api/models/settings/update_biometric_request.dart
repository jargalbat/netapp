import 'package:netware/api/bloc/operation.dart';
import 'package:netware/api/models/base_request.dart';

class UpdateBiometricRequest extends BaseRequest {
  String deviceCode;
  int biometricAuth;

  UpdateBiometricRequest({this.deviceCode, this.biometricAuth}) {
    this.func = Operation.updateBiometric;
  }

  UpdateBiometricRequest.fromJson(Map<String, dynamic> json) {
    deviceCode = json['deviceCode'];
    biometricAuth = json['biometricAuth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceCode'] = this.deviceCode;
    data['biometricAuth'] = this.biometricAuth;

    base(data);

    return data;
  }
}
