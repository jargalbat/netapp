
class FeeTerms {
  int termSize;
  String prodCode;
  String feeMethod;
  double feeSize;
  int feeId;
  int feeDecrDiff;

  FeeTerms({this.termSize, this.prodCode, this.feeMethod, this.feeSize, this.feeId, this.feeDecrDiff});

  FeeTerms.fromJson(Map<String, dynamic> json) {
    termSize = json['termSize'];
    prodCode = json['prodCode'];
    feeMethod = json['feeMethod'];
    feeSize = (json['feeSize'] ?? 0).toDouble();
    feeId = json['feeId'];
    feeDecrDiff = json['feeDecrDiff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['termSize'] = this.termSize;
    data['prodCode'] = this.prodCode;
    data['feeMethod'] = this.feeMethod;
    data['feeSize'] = this.feeSize;
    data['feeId'] = this.feeId;
    data['feeDecrDiff'] = this.feeDecrDiff;
    return data;
  }
}