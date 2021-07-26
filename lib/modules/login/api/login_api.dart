import 'dart:async';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/modules/login/api/login_request.dart';
import 'package:netware/modules/login/api/login_response.dart';
import 'package:netware/modules/login/api/verify_user_device_request.dart';
import 'package:netware/modules/login/api/verify_user_device_response.dart';


class LoginApi {
  Future<LoginResponse> signIn(LoginRequest request) async {
    return LoginResponse.fromJson((await connectionManager.post(request)).data);
  }

  Future<VerifyUserDeviceResponse> verifyUserDevice(VerifyUserDeviceRequest request) async {
    return VerifyUserDeviceResponse.fromJson((await connectionManager.post(request)).data);
  }

//  Future<BaseResponse> signOut() async {
//    return BaseResponse.fromJson((await api.post(LogoutRequest())).data);
//  }
//
//  Future<UserData> currentUser() async {
//    return app.user;
//  }

}
