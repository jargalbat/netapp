import 'package:netware/api/models/base_response.dart';

class SendTanResponse {
  int isRegnoEdited;
  String tanStatus;
  int isLastnameEdited;
  int resultCode;
  int isFirstnameEdited;
  String mobileNo;
  int isSexEdited;
  String resultDesc;
  String userKey;
  String tanExpireDatetime;
  int reqId;
  String tanNo;
  String tanSentDatetime;

  SendTanResponse(
      {this.isRegnoEdited,
      this.tanStatus,
      this.isLastnameEdited,
      this.resultCode,
      this.isFirstnameEdited,
      this.mobileNo,
      this.isSexEdited,
      this.resultDesc,
      this.userKey,
      this.tanExpireDatetime,
      this.reqId,
      this.tanNo,
      this.tanSentDatetime});

  SendTanResponse.fromJson(Map<String, dynamic> json) {
    isRegnoEdited = json['isRegnoEdited'];
    tanStatus = json['tanStatus'];
    isLastnameEdited = json['isLastnameEdited'];
    resultCode = json['resultCode'];
    isFirstnameEdited = json['isFirstnameEdited'];
    mobileNo = json['mobileNo'];
    isSexEdited = json['isSexEdited'];
    resultDesc = json['resultDesc'];
    userKey = json['userKey'];
    tanExpireDatetime = json['tanExpireDatetime'];
    reqId = json['reqId'];
    tanNo = json['tanNo'];
    tanSentDatetime = json['tanSentDatetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRegnoEdited'] = this.isRegnoEdited;
    data['tanStatus'] = this.tanStatus;
    data['isLastnameEdited'] = this.isLastnameEdited;
    data['resultCode'] = this.resultCode;
    data['isFirstnameEdited'] = this.isFirstnameEdited;
    data['mobileNo'] = this.mobileNo;
    data['isSexEdited'] = this.isSexEdited;
    data['resultDesc'] = this.resultDesc;
    data['userKey'] = this.userKey;
    data['tanExpireDatetime'] = this.tanExpireDatetime;
    data['reqId'] = this.reqId;
    data['tanNo'] = this.tanNo;
    data['tanSentDatetime'] = this.tanSentDatetime;
    return data;
  }
}
