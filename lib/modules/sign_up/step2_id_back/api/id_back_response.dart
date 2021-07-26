import 'package:netware/api/models/base_response.dart';

class IdBackResponse extends BaseResponse {
  int isRegnoEdited;
  String addrFullText;
  String idbackImg;
  int isLastnameEdited;
  int resultCode;
  int isFirstnameEdited;
  int isSexEdited;
  String resultDesc;
  String userKey;
  String addrStatus;
  int reqId;

  IdBackResponse(
      {this.isRegnoEdited,
      this.addrFullText,
      this.idbackImg,
      this.isLastnameEdited,
      this.resultCode,
      this.isFirstnameEdited,
      this.isSexEdited,
      this.resultDesc,
      this.userKey,
      this.addrStatus,
      this.reqId});

  IdBackResponse.fromJson(Map<String, dynamic> json) {
    isRegnoEdited = json['isRegnoEdited'];
    addrFullText = json['addrFullText'];
    idbackImg = json['idbackImg'];
    isLastnameEdited = json['isLastnameEdited'];
    resultCode = json['resultCode'];
    isFirstnameEdited = json['isFirstnameEdited'];
    isSexEdited = json['isSexEdited'];
    resultDesc = json['resultDesc'];
    userKey = json['userKey'];
    addrStatus = json['addrStatus'];
    reqId = json['reqId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRegnoEdited'] = this.isRegnoEdited;
    data['addrFullText'] = this.addrFullText;
    data['idbackImg'] = this.idbackImg;
    data['isLastnameEdited'] = this.isLastnameEdited;
    data['resultCode'] = this.resultCode;
    data['isFirstnameEdited'] = this.isFirstnameEdited;
    data['isSexEdited'] = this.isSexEdited;
    data['resultDesc'] = this.resultDesc;
    data['userKey'] = this.userKey;
    data['addrStatus'] = this.addrStatus;
    data['reqId'] = this.reqId;
    return data;
  }
}
