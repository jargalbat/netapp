import 'package:netware/api/models/acnt/sched.dart';
import 'package:netware/api/models/base_response.dart';

class AcntDetailResponse extends BaseResponse {
  int termSize;
  String modifiedUserName;
  int openBy;
  String endDate;
  String coreAcntNo;
  int nextPayAsDay;
  String intIncAcnt;
  double fineintDebtBal;
  String intRecAcnt;
  String createdUserName;
  String openByName;
  String lastTxnDatetime;
  String prodName;
  String termUnit;
  String companyCode;
  double totalCurPayAmt;
  double baseintDebtBal;
  double princBal;
  String coreProdCode;
  double advAmt;
  double basePaidAmt;
  List<Sched> sched;
  String createdDatetime;
  double prepaidintBal;
  String startDate;
  String status;
  int intVal;
  String modifiedDatetime;
  int extendMaxCount;
  int levelNo;
  int requestId;
  double acrintBal;
  String intTermUnit;
  String statusName;
  int modifiedBy;
  String curCode;
  String openDatetime;
  int extendCount;
  double theorBal;
  String acntNo;
  String intCalcMethod;
  String advDatetime;
  String custName;
  String custCode;
  double advFee;
  String prodCode;
  int expiredDay; // Хэтэрсэн хоног
  int createdBy;
  String closedByName;
  String intTermMethod;
  double princDebtBal;
  int extendFee;
  int isExpired;
  double feePaidAmt;
  double feePayBal;
  String nextPayDay;
  double totalPayQpay;

  AcntDetailResponse({
    this.termSize,
    this.modifiedUserName,
    this.openBy,
    this.endDate,
    this.coreAcntNo,
    this.nextPayAsDay,
    this.intIncAcnt,
    this.fineintDebtBal,
    this.intRecAcnt,
    this.createdUserName,
    this.openByName,
    this.lastTxnDatetime,
    this.prodName,
    this.termUnit,
    this.companyCode,
    this.totalCurPayAmt,
    this.baseintDebtBal,
    this.princBal,
    this.coreProdCode,
    this.advAmt,
    this.basePaidAmt,
    this.sched,
    this.createdDatetime,
    this.prepaidintBal,
    this.startDate,
    this.status,
    this.intVal,
    this.modifiedDatetime,
    this.extendMaxCount,
    this.levelNo,
    this.requestId,
    this.acrintBal,
    this.intTermUnit,
    this.statusName,
    this.modifiedBy,
    this.curCode,
    this.openDatetime,
    this.extendCount,
    this.theorBal,
    this.acntNo,
    this.intCalcMethod,
    this.advDatetime,
    this.custName,
    this.custCode,
    this.advFee,
    this.prodCode,
    this.expiredDay,
    this.createdBy,
    this.closedByName,
    this.intTermMethod,
    this.princDebtBal,
    this.extendFee,
    this.isExpired,
    this.feePaidAmt,
    this.feePayBal,
    this.nextPayDay,
    this.totalPayQpay,
  });

  AcntDetailResponse.fromJson(Map<String, dynamic> json) {
    // Base response
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];

    termSize = json['termSize'];
    modifiedUserName = json['modifiedUserName'];
    openBy = json['openBy'];
    endDate = json['endDate'];
    coreAcntNo = json['coreAcntNo'];
    nextPayAsDay = json['nextPayAsDay'];
    intIncAcnt = json['intIncAcnt'];
    fineintDebtBal = (json['fineintDebtBal'] ?? 0).toDouble();
    intRecAcnt = json['intRecAcnt'];
    createdUserName = json['createdUserName'];
    openByName = json['openByName'];
    lastTxnDatetime = json['lastTxnDatetime'];
    prodName = json['prodName'];
    termUnit = json['termUnit'];
    companyCode = json['companyCode'];
    totalCurPayAmt = (json['totalCurPayAmt'] ?? 0).toDouble();
    baseintDebtBal = (json['baseintDebtBal'] ?? 0).toDouble();
    princBal = (json['princBal'] ?? 0).toDouble();
    coreProdCode = json['coreProdCode'];
    advAmt = (json['advAmt'] ?? 0).toDouble();
    basePaidAmt = (json['basePaidAmt'] ?? 0).toDouble();
    if (json['sched'] != null) {
      sched = new List<Sched>();
      json['sched'].forEach((v) {
        sched.add(new Sched.fromJson(v));
      });
    }
    createdDatetime = json['createdDatetime'];
    prepaidintBal = (json['prepaidintBal'] ?? 0).toDouble();
    startDate = json['startDate'];
    status = json['status'];
    intVal = json['intVal'];
    modifiedDatetime = json['modifiedDatetime'];
    extendMaxCount = json['extendMaxCount'];
    levelNo = json['levelNo'];
    requestId = json['requestId'];
    acrintBal = (json['acrintBal'] ?? 0).toDouble();
    intTermUnit = json['intTermUnit'];
    statusName = json['statusName'];
    modifiedBy = json['modifiedBy'];
    curCode = json['curCode'];
    openDatetime = json['openDatetime'];
    extendCount = json['extendCount'];
    theorBal = (json['theorBal'] ?? 0).toDouble();
    acntNo = json['acntNo'];
    intCalcMethod = json['intCalcMethod'];
    advDatetime = json['advDatetime'];
    custName = json['custName'];
    custCode = json['custCode'];
    advFee = (json['advFee'] ?? 0).toDouble();
    prodCode = json['prodCode'];
    expiredDay = json['expiredDay'];
    createdBy = json['createdBy'];
    closedByName = json['closedByName'];
    intTermMethod = json['intTermMethod'];
    princDebtBal = (json['princDebtBal'] ?? 0).toDouble();
    extendFee = json['extendFee'];
    isExpired = json['isExpired'];
    feePaidAmt = (json['feePaidAmt'] ?? 0).toDouble();
    feePayBal = (json['feePayBal'] ?? 0).toDouble();
    nextPayDay = json['nextPayDay'];
    totalPayQpay = (json['totalPayQpay'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['termSize'] = this.termSize;
    data['modifiedUserName'] = this.modifiedUserName;
    data['openBy'] = this.openBy;
    data['endDate'] = this.endDate;
    data['coreAcntNo'] = this.coreAcntNo;
    data['nextPayAsDay'] = this.nextPayAsDay;
    data['intIncAcnt'] = this.intIncAcnt;
    data['fineintDebtBal'] = this.fineintDebtBal;
    data['intRecAcnt'] = this.intRecAcnt;
    data['createdUserName'] = this.createdUserName;
    data['openByName'] = this.openByName;
    data['lastTxnDatetime'] = this.lastTxnDatetime;
    data['prodName'] = this.prodName;
    data['termUnit'] = this.termUnit;
    data['companyCode'] = this.companyCode;
    data['totalCurPayAmt'] = this.totalCurPayAmt;
    data['baseintDebtBal'] = this.baseintDebtBal;
    data['princBal'] = this.princBal;
    data['coreProdCode'] = this.coreProdCode;
    data['advAmt'] = this.advAmt;
    data['basePaidAmt'] = this.basePaidAmt;
    if (this.sched != null) {
      data['sched'] = this.sched.map((v) => v.toJson()).toList();
    }
    data['createdDatetime'] = this.createdDatetime;
    data['prepaidintBal'] = this.prepaidintBal;
    data['startDate'] = this.startDate;
    data['status'] = this.status;
    data['intVal'] = this.intVal;
    data['modifiedDatetime'] = this.modifiedDatetime;
    data['extendMaxCount'] = this.extendMaxCount;
    data['levelNo'] = this.levelNo;
    data['requestId'] = this.requestId;
    data['acrintBal'] = this.acrintBal;
    data['intTermUnit'] = this.intTermUnit;
    data['statusName'] = this.statusName;
    data['modifiedBy'] = this.modifiedBy;
    data['curCode'] = this.curCode;
    data['openDatetime'] = this.openDatetime;
    data['extendCount'] = this.extendCount;
    data['theorBal'] = this.theorBal;
    data['acntNo'] = this.acntNo;
    data['intCalcMethod'] = this.intCalcMethod;
    data['advDatetime'] = this.advDatetime;
    data['custName'] = this.custName;
    data['custCode'] = this.custCode;
    data['advFee'] = this.advFee;
    data['prodCode'] = this.prodCode;
    data['expiredDay'] = this.expiredDay;
    data['createdBy'] = this.createdBy;
    data['closedByName'] = this.closedByName;
    data['intTermMethod'] = this.intTermMethod;
    data['princDebtBal'] = this.princDebtBal;
    data['extendFee'] = this.extendFee;
    data['isExpired'] = this.isExpired;
    data['feePaidAmt'] = this.feePaidAmt;
    data['feePayBal'] = this.feePayBal;
    data['nextPayDay'] = this.nextPayDay;
    data['totalPayQpay'] = this.totalPayQpay;
    return data;
  }
}
