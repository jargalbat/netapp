import 'package:netware/api/models/base_response.dart';

class VerifyUserDeviceResponse extends BaseResponse {
  int resultCode;
  String resultDesc;

  VerifyUserDeviceResponse({this.resultCode, this.resultDesc});

  VerifyUserDeviceResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultCode'] = this.resultCode;
    data['resultDesc'] = this.resultDesc;
    return data;
  }
}
