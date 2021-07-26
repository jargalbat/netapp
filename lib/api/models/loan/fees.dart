
import 'fee_terms.dart';

class Fees {
  int orderNo;
  int isMain;
  List<FeeTerms> feeTerms;
  String calcType;
  String description;
  int feeId;

  Fees({this.orderNo, this.isMain, this.feeTerms, this.calcType, this.description, this.feeId});

  Fees.fromJson(Map<String, dynamic> json) {
    orderNo = json['orderNo'];
    isMain = json['isMain'];
    if (json['feeTerms'] != null) {
      feeTerms = new List<FeeTerms>();
      json['feeTerms'].forEach((v) {
        feeTerms.add(new FeeTerms.fromJson(v));
      });
    }
    calcType = json['calcType'];
    description = json['description'];
    feeId = json['feeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNo'] = this.orderNo;
    data['isMain'] = this.isMain;
    if (this.feeTerms != null) {
      data['feeTerms'] = this.feeTerms.map((v) => v.toJson()).toList();
    }
    data['calcType'] = this.calcType;
    data['description'] = this.description;
    data['feeId'] = this.feeId;
    return data;
  }
}
