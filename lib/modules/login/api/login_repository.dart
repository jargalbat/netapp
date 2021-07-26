import 'dart:async';

import 'login_api.dart';
import 'login_request.dart';
import 'login_response.dart';
import 'verify_user_device_request.dart';
import 'verify_user_device_response.dart';

class LoginRepository {
  final LoginApi _loginApi = LoginApi();

  static LoginRepository _instance;

  factory LoginRepository() {
    if (_instance == null) {
      _instance = LoginRepository._internal();
    }
    return _instance;
  }

  LoginRepository._internal();

  Future<LoginResponse> signIn(LoginRequest request) async {
    return await _loginApi.signIn(request);
  }

  Future<VerifyUserDeviceResponse> verifyUserDevice(VerifyUserDeviceRequest request) async {
    return await _loginApi.verifyUserDevice(request);
  }
}
