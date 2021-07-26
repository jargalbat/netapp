import 'package:netware/api/models/base_response.dart';

class IdFrontResponse {
  String regNo;
  int isRegnoEdited;
  String lastName;
  int isLastnameEdited;
  int resultCode;
  int isFirstnameEdited;
  int isSexEdited;
  String resultDesc;
  String userKey;
  int reqId;
  String idStatus;
  String firstName;
  String idFullText;
  String idImg;
  String sex;

  IdFrontResponse({
    this.regNo,
    this.isRegnoEdited,
    this.lastName,
    this.isLastnameEdited,
    this.resultCode,
    this.isFirstnameEdited,
    this.isSexEdited,
    this.resultDesc,
    this.userKey,
    this.reqId,
    this.idStatus,
    this.firstName,
    this.idFullText,
    this.idImg,
    this.sex,
  });

  IdFrontResponse.fromJson(Map<String, dynamic> json) {
    regNo = json['regNo'];
    isRegnoEdited = json['isRegnoEdited'];
    lastName = json['lastName'];
    isLastnameEdited = json['isLastnameEdited'];
    resultCode = json['resultCode'];
    isFirstnameEdited = json['isFirstnameEdited'];
    isSexEdited = json['isSexEdited'];
    resultDesc = json['resultDesc'];
    userKey = json['userKey'];
    reqId = json['reqId'];
    idStatus = json['idStatus'];
    firstName = json['firstName'];
    idFullText = json['idFullText'];
    idImg = json['idImg'];
    sex = json['sex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regNo'] = this.regNo;
    data['isRegnoEdited'] = this.isRegnoEdited;
    data['lastName'] = this.lastName;
    data['isLastnameEdited'] = this.isLastnameEdited;
    data['resultCode'] = this.resultCode;
    data['isFirstnameEdited'] = this.isFirstnameEdited;
    data['isSexEdited'] = this.isSexEdited;
    data['resultDesc'] = this.resultDesc;
    data['userKey'] = this.userKey;
    data['reqId'] = this.reqId;
    data['idStatus'] = this.idStatus;
    data['firstName'] = this.firstName;
    data['idFullText'] = this.idFullText;
    data['idImg'] = this.idImg;
    data['sex'] = this.sex;
    return data;
  }
}
