import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class IdFrontConfirmRequest extends BaseRequest {
  final String userKey;
  final String regNo;
  final String lastName;
  final String firstName;
  final String sex;

  IdFrontConfirmRequest({this.userKey, this.regNo, this.lastName, this.firstName, this.sex}) {
    this.func = Operation.stepConfirmID;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userKey'] = this.userKey;
    data['regNo'] = this.regNo;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['sex'] = this.sex;

    /// base data
    base(data);

    return data;
  }
}
