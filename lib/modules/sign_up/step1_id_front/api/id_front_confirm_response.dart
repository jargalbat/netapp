class IdFrontConfirmResponse {
  int isRegnoEdited;
  int isLastnameEdited;
  int resultCode;
  int isFirstnameEdited;
  int isSexEdited;
  String resultDesc;
  int reqId;

  IdFrontConfirmResponse(
      {this.isRegnoEdited,
        this.isLastnameEdited,
        this.resultCode,
        this.isFirstnameEdited,
        this.isSexEdited,
        this.resultDesc,
        this.reqId});

  IdFrontConfirmResponse.fromJson(Map<String, dynamic> json) {
    isRegnoEdited = json['isRegnoEdited'];
    isLastnameEdited = json['isLastnameEdited'];
    resultCode = json['resultCode'];
    isFirstnameEdited = json['isFirstnameEdited'];
    isSexEdited = json['isSexEdited'];
    resultDesc = json['resultDesc'];
    reqId = json['reqId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRegnoEdited'] = this.isRegnoEdited;
    data['isLastnameEdited'] = this.isLastnameEdited;
    data['resultCode'] = this.resultCode;
    data['isFirstnameEdited'] = this.isFirstnameEdited;
    data['isSexEdited'] = this.isSexEdited;
    data['resultDesc'] = this.resultDesc;
    data['reqId'] = this.reqId;
    return data;
  }
}