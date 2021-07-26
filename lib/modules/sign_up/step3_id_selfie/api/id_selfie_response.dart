class IdSelfieResponse {
  int isRegnoEdited;
  String selfieStatus;
  String selfieImg;
  String matchStatus;
  int matchResult;
  int isLastnameEdited;
  int resultCode;
  int isFirstnameEdited;
  int isSexEdited;
  String resultDesc;
  String userKey;
  int reqId;

  IdSelfieResponse(
      {this.isRegnoEdited,
      this.selfieStatus,
      this.selfieImg,
      this.matchStatus,
      this.matchResult,
      this.isLastnameEdited,
      this.resultCode,
      this.isFirstnameEdited,
      this.isSexEdited,
      this.resultDesc,
      this.userKey,
      this.reqId});

  IdSelfieResponse.fromJson(Map<String, dynamic> json) {
    isRegnoEdited = json['isRegnoEdited'];
    selfieStatus = json['selfieStatus'];
    selfieImg = json['selfieImg'];
    matchStatus = json['matchStatus'];
    matchResult = json['matchResult'];
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
    data['selfieStatus'] = this.selfieStatus;
    data['selfieImg'] = this.selfieImg;
    data['matchStatus'] = this.matchStatus;
    data['matchResult'] = this.matchResult;
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
