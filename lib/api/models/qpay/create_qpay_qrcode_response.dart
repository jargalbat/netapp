import 'package:netware/api/models/base_response.dart';

class CreateQpayQrCodeResponse extends BaseResponse {
  CreateQpayQrCodeResponse({this.qrData});

  String qrData;

  CreateQpayQrCodeResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    qrData = json["str"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultCode'] = this.resultCode;
    data['resultDesc'] = this.resultDesc;
    return data;
  }
}
