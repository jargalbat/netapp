class RcvAcnts {
  String companyCode;
  String bankCode;
  String acntName;
  String acntNo;
  String bankName;
  String curCode;

  RcvAcnts({this.companyCode, this.bankCode, this.acntName, this.acntNo, this.bankName, this.curCode});

  RcvAcnts.fromJson(Map<String, dynamic> json) {
    companyCode = json['companyCode'];
    bankCode = json['bankCode'];
    acntName = json['acntName'];
    acntNo = json['acntNo'];
    bankName = json['bankName'];
    curCode = json['curCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyCode'] = this.companyCode;
    data['bankCode'] = this.bankCode;
    data['acntName'] = this.acntName;
    data['acntNo'] = this.acntNo;
    data['bankName'] = this.bankName;
    data['curCode'] = this.curCode;
    return data;
  }
}
