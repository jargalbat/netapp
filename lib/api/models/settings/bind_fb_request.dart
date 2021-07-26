import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class BindFbRequest extends BaseRequest {
  String fbId;
  String fbName;

  BindFbRequest({this.fbId, this.fbName}) {
    this.func = Operation.bindFb;
  }

  BindFbRequest.fromJson(Map<String, dynamic> json) {
    fbId = json['fbId'];
    fbName = json['fbName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fbId'] = this.fbId;
    data['fbName'] = this.fbName;

    base(data);

    return data;
  }
}
