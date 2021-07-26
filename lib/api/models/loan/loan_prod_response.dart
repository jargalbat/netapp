import 'package:netware/api/models/base_response.dart';

class LoanProdResponse extends BaseResponse {
  Prod prod;
  List<Terms> terms;

  LoanProdResponse({this.prod, this.terms});

  LoanProdResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    prod = json['prod'] != null ? new Prod.fromJson(json['prod']) : null;
    if (json['terms'] != null) {
      terms = new List<Terms>();
      json['terms'].forEach((v) {
        terms.add(new Terms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prod != null) {
      data['prod'] = this.prod.toJson();
    }
    if (this.terms != null) {
      data['terms'] = this.terms.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prod {
  int intVal;
  String endDate;
  String description;
  String modifiedDatetime;
  int extendMaxCount;
  int isOnline;
  int maxAmt;
  String intTermUnit;
  int modifiedBy;
  String curCode;
  String cashAcnt;
  String termUnit;
  int maxTerm;
  String companyCode;
  String coreProdCode;
  String intCalcMethod;
  int minAmt;
  String prodCode;
  int createdBy;
  int minTerm;
  String name;
  String intTermMethod;
  String createdDatetime;
  String name2;
  String startDate;
  String status;

  Prod(
      {this.intVal,
      this.endDate,
      this.description,
      this.modifiedDatetime,
      this.extendMaxCount,
      this.isOnline,
      this.maxAmt,
      this.intTermUnit,
      this.modifiedBy,
      this.curCode,
      this.cashAcnt,
      this.termUnit,
      this.maxTerm,
      this.companyCode,
      this.coreProdCode,
      this.intCalcMethod,
      this.minAmt,
      this.prodCode,
      this.createdBy,
      this.minTerm,
      this.name,
      this.intTermMethod,
      this.createdDatetime,
      this.name2,
      this.startDate,
      this.status});

  Prod.fromJson(Map<String, dynamic> json) {
    intVal = json['intVal'];
    endDate = json['endDate'];
    description = json['description'];
    modifiedDatetime = json['modifiedDatetime'];
    extendMaxCount = json['extendMaxCount'];
    isOnline = json['isOnline'];
    maxAmt = json['maxAmt'];
    intTermUnit = json['intTermUnit'];
    modifiedBy = json['modifiedBy'];
    curCode = json['curCode'];
    cashAcnt = json['cashAcnt'];
    termUnit = json['termUnit'];
    maxTerm = json['maxTerm'];
    companyCode = json['companyCode'];
    coreProdCode = json['coreProdCode'];
    intCalcMethod = json['intCalcMethod'];
    minAmt = json['minAmt'];
    prodCode = json['prodCode'];
    createdBy = json['createdBy'];
    minTerm = json['minTerm'];
    name = json['name'];
    intTermMethod = json['intTermMethod'];
    createdDatetime = json['createdDatetime'];
    name2 = json['name2'];
    startDate = json['startDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intVal'] = this.intVal;
    data['endDate'] = this.endDate;
    data['description'] = this.description;
    data['modifiedDatetime'] = this.modifiedDatetime;
    data['extendMaxCount'] = this.extendMaxCount;
    data['isOnline'] = this.isOnline;
    data['maxAmt'] = this.maxAmt;
    data['intTermUnit'] = this.intTermUnit;
    data['modifiedBy'] = this.modifiedBy;
    data['curCode'] = this.curCode;
    data['cashAcnt'] = this.cashAcnt;
    data['termUnit'] = this.termUnit;
    data['maxTerm'] = this.maxTerm;
    data['companyCode'] = this.companyCode;
    data['coreProdCode'] = this.coreProdCode;
    data['intCalcMethod'] = this.intCalcMethod;
    data['minAmt'] = this.minAmt;
    data['prodCode'] = this.prodCode;
    data['createdBy'] = this.createdBy;
    data['minTerm'] = this.minTerm;
    data['name'] = this.name;
    data['intTermMethod'] = this.intTermMethod;
    data['createdDatetime'] = this.createdDatetime;
    data['name2'] = this.name2;
    data['startDate'] = this.startDate;
    data['status'] = this.status;
    return data;
  }
}

class Terms {
  int termSize;
  String prodCode;
  int useExtend;
  int useAdv;

  Terms({this.termSize, this.prodCode, this.useExtend, this.useAdv});

  Terms.fromJson(Map<String, dynamic> json) {
    termSize = json['termSize'];
    prodCode = json['prodCode'];
    useExtend = json['useExtend'];
    useAdv = json['useAdv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['termSize'] = this.termSize;
    data['prodCode'] = this.prodCode;
    data['useExtend'] = this.useExtend;
    data['useAdv'] = this.useAdv;
    return data;
  }
}
