import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class IdSelfieRequest extends BaseRequest {
  String userKey;
  String selfieImg;

  IdSelfieRequest({this.userKey, this.selfieImg}) {
    this.func = Operation.stepSelfie;
    this.userKey = userKey;
    this.selfieImg = selfieImg;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userKey'] = this.userKey;
    data['selfieImg'] = this.selfieImg;

    /// base data
    base(data);

    return data;
  }
}
