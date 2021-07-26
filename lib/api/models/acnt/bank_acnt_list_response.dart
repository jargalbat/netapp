import 'package:netware/api/models/base_response.dart';
import 'package:netware/app/globals.dart';

class BankAcntListResponse extends BaseResponse {
  List<BankAcnt> bankAcntList;

  BankAcntListResponse({this.bankAcntList});

  BankAcntListResponse.fromJson(List<dynamic> json) {
    try {
      var list = json ?? new List<BankAcnt>();
      bankAcntList = list.map((i) => BankAcnt.fromJson(i)).toList();
      resultCode = 0;
      resultDesc = '';
    } catch (e) {
      resultCode = 99;
      resultDesc = globals.text.errorOccurred();
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class BankAcnt {
  String bankCode;
  String bankName;
  String acntName;
  String acntNo;
  int isMain;
  String curCode;

//  String curName;
  String custCode;

  BankAcnt({
    this.bankCode,
    this.bankName,
    this.acntName,
    this.acntNo,
    this.isMain,
    this.curCode,
//    this.curName,
    this.custCode,
  });

  BankAcnt.fromJson(Map<String, dynamic> json) {
    bankCode = json['bankCode'];
    bankName = json['bankName'];
    acntName = json['acntName'];
    acntNo = json['acntNo'];
    isMain = json['isMain'];
    curCode = json['curCode'];
    custCode = json['custCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankCode'] = this.bankCode;
    data['bankName'] = this.bankName;
    data['acntName'] = this.acntName;
    data['acntNo'] = this.acntNo;
    data['isMain'] = this.isMain;
    data['curCode'] = this.curCode;
    data['custCode'] = this.custCode;
    return data;
  }
}
