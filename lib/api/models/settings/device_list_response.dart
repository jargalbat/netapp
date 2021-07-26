import 'package:netware/api/models/base_response.dart';
import 'package:netware/app/globals.dart';

class DeviceListResponse extends BaseResponse {
  List<UserDevice> deviceList;

  DeviceListResponse({this.deviceList});

  DeviceListResponse.fromJson(List<dynamic> json) {
    try {
      var list = json ?? new List<UserDevice>();
      deviceList = list.map((i) => UserDevice.fromJson(i)).toList();

      if (deviceList != null && deviceList.isNotEmpty) {
        resultCode = 0;
        resultDesc = 'Success';
      }
    } catch (e) {
      resultCode = 99;
      resultDesc = globals.text.errorOccurred();
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class UserDevice {
  int biometricAuth;
  String name;
  String createdDatetime;
  String deviceCode;
  int rememberMe;
  int userId;
  int deviceId;
  String status;

  UserDevice({this.biometricAuth, this.name, this.createdDatetime, this.deviceCode, this.rememberMe, this.userId, this.deviceId, this.status});

  UserDevice.fromJson(Map<String, dynamic> json) {
    biometricAuth = json['biometricAuth'];
    name = json['name'];
    createdDatetime = json['createdDatetime'];
    deviceCode = json['deviceCode'];
    rememberMe = json['rememberMe'];
    userId = json['userId'];
    deviceId = json['deviceId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['biometricAuth'] = this.biometricAuth;
    data['name'] = this.name;
    data['createdDatetime'] = this.createdDatetime;
    data['deviceCode'] = this.deviceCode;
    data['rememberMe'] = this.rememberMe;
    data['userId'] = this.userId;
    data['deviceId'] = this.deviceId;
    data['status'] = this.status;
    return data;
  }
}
