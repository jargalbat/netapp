import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class RemoveDeviceRequest extends BaseRequest {
  int deviceId;

  RemoveDeviceRequest({this.deviceId}) {
    this.func = Operation.deleteUserDevice;
  }

  RemoveDeviceRequest.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;

    base(data);

    return data;
  }
}
