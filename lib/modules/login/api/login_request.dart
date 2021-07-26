import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class LoginRequest extends BaseRequest {
  final String loginName;
  final String password;
  final String deviceCode;
  final String deviceName;

  LoginRequest({
    this.loginName,
    this.password,
    this.deviceCode,
    this.deviceName,
  }) {
    this.func = Operation.login;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['loginName'] = this.loginName;
    data['password'] = this.password;
    data['deviceCode'] = this.deviceCode;
    data['deviceName'] = this.deviceName;

    /// base data
    base(data);

    return data;
  }

  @override
  String toString() {
    return '''LoginRequest {
      loginName: $loginName,
      password: $password,
      deviceCode: $deviceCode,
      deviceName: $deviceName,
    }''';
  }
}
