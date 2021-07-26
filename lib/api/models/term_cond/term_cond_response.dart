import 'package:netware/api/models/base_response.dart';

class TermCondResponse extends BaseResponse {
  String termCond;

  TermCondResponse();

  TermCondResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    termCond = json['str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    return data;
  }
}
