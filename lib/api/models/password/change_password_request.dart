import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class ChangePasswordRequest extends BaseRequest {
  final String loginName;
  final String oldPass;
  final String password;
  final String passwordConfirm;

  ChangePasswordRequest({this.loginName, this.oldPass, this.password, this.passwordConfirm}) {
    this.func = Operation.changePassword;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['loginName'] = this.loginName;
    data['oldPass'] = this.oldPass;
    data['password'] = this.password;
    data['passwordConfirm'] = this.passwordConfirm;

    /// base data
    base(data);

    return data;
  }
}
