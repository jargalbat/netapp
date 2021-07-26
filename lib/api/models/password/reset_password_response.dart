import 'package:netware/api/models/base_response.dart';

class ResetPasswordResponse extends BaseResponse {
  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
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
