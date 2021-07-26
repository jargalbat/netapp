import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class LoginInitMobile extends LoginEvent {}

class LoginCheckBiometrics extends LoginEvent {}

class LoginSubmit extends LoginEvent {
  final String loginName;
  final String password;
  final bool rememberMe;

  LoginSubmit({
    @required this.loginName,
    this.password,
    this.rememberMe,
  }) : super([loginName, password]);

  @override
  String toString() {
    return 'LoginSubmit { loginName: $loginName, password: $password, rememberMe: $rememberMe }';
  }
}
