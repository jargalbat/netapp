import 'package:netware/api/bloc/operation.dart';
import 'package:netware/api/models/base_request.dart';

class RemoveRelativeRequest extends BaseRequest {
  int relativeId;

  RemoveRelativeRequest({this.relativeId}) {
    this.func = Operation.deleteRelative;
  }

  RemoveRelativeRequest.fromJson(Map<String, dynamic> json) {
    relativeId = json['relativeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relativeId'] = this.relativeId;

    base(data);

    return data;
  }
}
