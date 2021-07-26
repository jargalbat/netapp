import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class ResetPasswordRequest extends BaseRequest {
  final String mobileNo;

  ResetPasswordRequest({this.mobileNo}) {
    this.func = Operation.resetPassword;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['mobileNo'] = this.mobileNo;

    /// base data
    base(data);

    return data;
  }
}
