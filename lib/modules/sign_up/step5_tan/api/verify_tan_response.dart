class VerifyTanResponse {
  int isRegnoEdited;
  String tanStatus;
  int isLastnameEdited;
  int resultCode;
  int isFirstnameEdited;
  int isSexEdited;
  String resultDesc;
  String userKey;
  int reqId;

  VerifyTanResponse(
      {this.isRegnoEdited,
      this.tanStatus,
      this.isLastnameEdited,
      this.resultCode,
      this.isFirstnameEdited,
      this.isSexEdited,
      this.resultDesc,
      this.userKey,
      this.reqId});

  VerifyTanResponse.fromJson(Map<String, dynamic> json) {
    isRegnoEdited = json['isRegnoEdited'];
    tanStatus = json['tanStatus'];
    isLastnameEdited = json['isLastnameEdited'];
    resultCode = json['resultCode'];
    isFirstnameEdited = json['isFirstnameEdited'];
    isSexEdited = json['isSexEdited'];
    resultDesc = json['resultDesc'];
    userKey = json['userKey'];
    reqId = json['reqId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRegnoEdited'] = this.isRegnoEdited;
    data['tanStatus'] = this.tanStatus;
    data['isLastnameEdited'] = this.isLastnameEdited;
    data['resultCode'] = this.resultCode;
    data['isFirstnameEdited'] = this.isFirstnameEdited;
    data['isSexEdited'] = this.isSexEdited;
    data['resultDesc'] = this.resultDesc;
    data['userKey'] = this.userKey;
    data['reqId'] = this.reqId;
    return data;
  }
}
