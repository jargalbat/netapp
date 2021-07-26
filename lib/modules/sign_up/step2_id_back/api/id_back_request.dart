import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class IdBackRequest extends BaseRequest {
  String userKey;
  String idbackImg;

  IdBackRequest({this.userKey, this.idbackImg}) {
    this.func = Operation.stepAddress;
    this.userKey = userKey;
    this.idbackImg = idbackImg;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userKey'] = this.userKey;
    data['idbackImg'] = this.idbackImg;

    /// base data
    base(data);

    return data;
  }
}
