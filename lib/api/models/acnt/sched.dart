class Sched {
  String acntNo;
  double paidFeeAmt;
  double paidBaseAmt;
  String payDay;
  double intAmt;
  double paidIntAmt;
  double baseAmt;
  double paidFineIntAmt;
  double feeAmt;
  String status;
  double totalAmt; // Нийт төлөх
  double theorBal; // Эцсийн үлдэгдэл

  Sched({
    this.acntNo,
    this.paidFeeAmt,
    this.paidBaseAmt,
    this.payDay,
    this.intAmt,
    this.paidIntAmt,
    this.baseAmt,
    this.paidFineIntAmt,
    this.feeAmt,
    this.status,
    this.totalAmt,
    this.theorBal,
  });

  Sched.fromJson(Map<String, dynamic> json) {
    acntNo = json['acntNo'];
    paidFeeAmt = (json['paidFeeAmt'] ?? 0).toDouble();
    paidBaseAmt = (json['paidBaseAmt'] ?? 0).toDouble();
    payDay = json['payDay'];
    intAmt = (json['intAmt'] ?? 0).toDouble();
    paidIntAmt = (json['paidIntAmt'] ?? 0).toDouble();
    baseAmt = (json['baseAmt'] ?? 0).toDouble();
    paidFineIntAmt = (json['paidFineIntAmt'] ?? 0).toDouble();
    feeAmt = (json['feeAmt'] ?? 0).toDouble();
    status = json['status'];
    totalAmt = (json['totalAmt'] ?? 0).toDouble();
    theorBal = (json['theorBal'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acntNo'] = this.acntNo;
    data['paidFeeAmt'] = this.paidFeeAmt;
    data['paidBaseAmt'] = this.paidBaseAmt;
    data['payDay'] = this.payDay;
    data['intAmt'] = this.intAmt;
    data['paidIntAmt'] = this.paidIntAmt;
    data['baseAmt'] = this.baseAmt;
    data['paidFineIntAmt'] = this.paidFineIntAmt;
    data['feeAmt'] = this.feeAmt;
    data['status'] = this.status;
    data['totalAmt'] = this.totalAmt;
    data['theorBal'] = this.theorBal;
    return data;
  }
}
