import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/shared_pref_key.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/modules/login/api/login_repository.dart';
import 'package:netware/modules/login/api/login_request.dart';
import 'package:netware/modules/login/api/login_response.dart';
import 'package:netware/app/utils/biometric_helper.dart';
import 'package:flutter/services.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/modules/login/login_helper.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:netware/api/bloc/connection_manager2.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginInit();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInitMobile) {
      yield* _mapInitMobileToState();
    } else if (event is LoginSubmit) {
      yield* _mapSubmitToState(event.loginName, event.password, event.rememberMe);
    } else if (event is LoginCheckBiometrics) {
      yield* _mapCheckBiometricsToState();
    }
  }

  Stream<LoginState> _mapInitMobileToState() async* {
    connectionManager = ConnectionManager();
//    connectionManager2 = ConnectionManager2();

    try {
      if (globals.sharedPref != null && globals.sharedPref.containsKey(SharedPrefKey.RememberMe)) {
        if (globals.sharedPref.getBool(SharedPrefKey.RememberMe)) {
          /// Init remember me
          yield LoginSetRememberMe(rememberMe: true);

          if (globals.sharedPref.containsKey(SharedPrefKey.LoginName)) {
            /// Init mobile
            yield LoginSetMobile(mobile: globals.sharedPref.getString(SharedPrefKey.LoginName));
          }
        }
      }
    } catch (e) {
      print(e);
    }

    /// Biometrics
    try {
      BiometricHelper biometricHelper = new BiometricHelper();
      await biometricHelper.initBiometric();

      yield LoginSetBiometric(
        canCheckBiometrics: biometricHelper.canCheckBiometrics,
        hasAvailableBiometrics: biometricHelper.hasAvailableBiometrics,
      );
    } on PlatformException catch (e) {
      print(e);
      yield LoginSetBiometric(
        canCheckBiometrics: false,
        hasAvailableBiometrics: true,
      );
    }
  }

  Stream<LoginState> _mapSubmitToState(String mobile, String password, bool rememberMe) async* {
    try {
      yield LoginLoading();
//        yield LoginSuccess(msg: mobile);
//        return;

      if (globals.isTest) {
//        yield LoginSuccess(msg: mobile);
//        return;
      }

      // test
//      yield LoginFailed(
//        resultCode: LoginHelper.CODE_PERMANENT_DEVICE,
//        resultDesc: 'Тогтмол хандах',
//        loginName: mobile,
//      );
//      return;

      // test
//      yield LoginFailed(
//        resultCode: LoginHelper.CODE_CHANGE_PASSWORD,
//        resultDesc: 'Нууц үгээ солино уу',
//        loginName: mobile,
//      );
//      return;

      connectionManager = new ConnectionManager();
//      connectionManager2 = ConnectionManager2();

      LoginRepository repository = new LoginRepository();

      // Request
      LoginRequest request = new LoginRequest(
        loginName: mobile,
        password: password,
        deviceCode: globals.deviceCode,
        deviceName: globals.deviceName,
      );
      // Response
      LoginResponse response = await repository.signIn(request);
      if (response.resultCode == 0) {
        // Parse user data
        globals.user = response.userInfo;
        globals.biometricAuth = response.biometricAuth;

        // Check remember me
        if (rememberMe) {
          globals.sharedPref?.setBool(SharedPrefKey.RememberMe, true);
          globals.sharedPref?.setString(SharedPrefKey.LoginName, mobile);
        }

        // test
//        response.userInfo.hadAdditionInfo = 0;

        // Check new user
        if (response.userInfo.hadAdditionInfo == 0) {
          yield LoginProfileAdditional();
        } else {
          yield LoginSuccess(msg: 'success', firstName: globals.user?.firstName ?? '');
        }
      } else {
        print('Login failed: ${Func.toStr(response.resultDesc)}');
        yield LoginFailed(
          resultCode: response.resultCode,
          resultDesc: Func.isEmpty(response.resultDesc) ? 'failed' : response.resultDesc,
          loginName: mobile,
          password: password,
        );
      }

      yield LoginSetMobile(mobile: mobile);
    } catch (e) {
      print(e);
      yield LoginFailed(
        resultCode: ResponseCode.Failed,
        resultDesc: 'Амжилтгүй',
        loginName: mobile,
        password: password,
      );
    }
  }

  Stream<LoginState> _mapCheckBiometricsToState() async* {
    try {
      /// Biometric
      BiometricHelper biometricHelper = new BiometricHelper();
      await biometricHelper.initBiometric();

      if (await biometricHelper.checkBiometrics()) {
        yield LoginBiometricResult(
          didAuthenticate: true,
          msg: 'success',
        );
      } else {
        yield LoginBiometricResult(
          didAuthenticate: false,
          msg: 'failed',
        );
      }
    } on PlatformException catch (e) {
      print(e);
      yield LoginSetBiometric(
        canCheckBiometrics: false,
        hasAvailableBiometrics: true,
      );
    }
  }
}
