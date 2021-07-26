import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInit extends LoginState {}

class LoginSetMobile extends LoginState {
  final String mobile;

  LoginSetMobile({@required this.mobile});

  @override
  List<Object> get props => [mobile];

  @override
  String toString() => 'LoginSetMobile { mobile: $mobile }';
}

class LoginSetRememberMe extends LoginState {
  final bool rememberMe;

  LoginSetRememberMe({@required this.rememberMe});

  @override
  List<Object> get props => [rememberMe];

  @override
  String toString() => 'LoginSetRememberMe { rememberMe: $rememberMe }';
}

class LoginSetBiometric extends LoginState {
  final bool canCheckBiometrics;
  final bool hasAvailableBiometrics;

  LoginSetBiometric({
    @required this.canCheckBiometrics,
    @required this.hasAvailableBiometrics,
  });

  @override
  List<Object> get props => [canCheckBiometrics, hasAvailableBiometrics];

  @override
  String toString() => 'LoginSetBiometric { canCheckBiometrics: $canCheckBiometrics, hasAvailableBiometrics: $hasAvailableBiometrics }';
}

class LoginBiometricResult extends LoginState {
  final bool didAuthenticate;
  final String msg;

  LoginBiometricResult({
    @required this.didAuthenticate,
    @required this.msg,
  });

  @override
  List<Object> get props => [didAuthenticate, msg];

  @override
  String toString() => 'LoginSetBiometric { didAuthenticate: $didAuthenticate, msg: $msg }';
}

class LoginLoading extends LoginState {}

class LoginClear extends LoginState {}

class LoginProfileAdditional extends LoginState {}

class LoginSuccess extends LoginState {
  final String msg;
  final String firstName;

  LoginSuccess({@required this.msg, @required this.firstName});

  @override
  List<Object> get props => [msg, firstName];

  @override
  String toString() => 'LoginSuccess { msg: $msg, firstName: $firstName }';
}

class LoginFailed extends LoginState {
  final int resultCode;
  final String resultDesc;
  final String loginName;
  final String password;

  LoginFailed({
    @required this.resultCode,
    @required this.resultDesc,
    @required this.loginName,
    @required this.password,
  });

  @override
  List<Object> get props => [resultCode, resultDesc, loginName, password];

  @override
  String toString() => 'LoginFailed { resultCode: $resultCode, resultDesc: $resultDesc, loginName: $loginName, password: $password }';
}
