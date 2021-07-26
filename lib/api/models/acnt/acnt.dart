import 'package:netware/api/models/acnt/sched.dart';

class Acnt {
  int termSize;
  int openBy;
  String acntName;
  int dayOfYear;
  String endDate;
  String coreAcntNo;
  String intIncAcnt;
  double payConstAmount;
  int repayType;
  String intRecAcnt;
  int payMonth;
  String begDate;
  String lastTxnDatetime;
  String termBasis;
  String termUnit;
  String purpCode;
  String companyCode;
  int branchId;
  String endDateGb;
  String coreProdCode;
  String acntName2;
  double advAmt;
  int termLen;
  String capFreq;
  String approvDate;
  double paidInt;
  int tellerNo;
  String createdDatetime;
  String startDate;
  String status;
  double intVal;
  double intRate;
  String modifiedDatetime;
  double approvAmount;
  int extendMaxCount;
  String payFreq;
  int levelNo;
  int chkHoliday;
  int shiftLastDay;
  int requestId;
  String lastTxnDate;
  int payDay2;
  List<Sched> schedules;
  String intTermUnit;
  int modifiedBy;
  String curCode;
  String openDatetime;
  int extendCount;
  int chkSkipPartialPay;
  String acntNo;
  String intCalcMethod;
  String advDatetime;
  int intDayOption;
  String custCode;
  String prodCode;
  double capfint;
  String catCode;
  int chkUseDateAmountReCalc;
  int createdBy;
  String intTermMethod;
  int payDay;
  String brchNo;
  double termFree;
  double basePaidAmt; // Үндсэн зээлийн нийт төлсөн дүн
  double feePaidAmt; // Нийт төлсөн шимтгэл
  double advFeeBal; // Зээл олголтын шимтгэл (Үндсэн зээлийн шимтгэл)
  double fineintDebtBal; // Алданги
  double princBal; // Зээлийн үлдэгдэл
  String nextPayDay; // Дараагийн төлөх огноо
  int expiredDay; // Хугацаа хэтэрсэн хоног
  double totalCurPayAmt; // Нийт төлөх дүн (Balance)
  int nextPayAsDay; // Үлдсэн хоног
  String prodName; // Бүтээгдэхүүний нэр
  int isExpired; // Хугацаа хэтэрсэн эсэх

  Acnt({
    this.termSize,
    this.openBy,
    this.acntName,
    this.dayOfYear,
    this.endDate,
    this.coreAcntNo,
    this.intIncAcnt,
    this.payConstAmount,
    this.repayType,
    this.intRecAcnt,
    this.payMonth,
    this.begDate,
    this.lastTxnDatetime,
    this.termBasis,
    this.termUnit,
    this.purpCode,
    this.companyCode,
    this.branchId,
    this.endDateGb,
    this.coreProdCode,
    this.acntName2,
    this.advAmt,
    this.termLen,
    this.capFreq,
    this.approvDate,
    this.paidInt,
    this.tellerNo,
    this.createdDatetime,
    this.startDate,
    this.status,
    this.intVal,
    this.intRate,
    this.modifiedDatetime,
    this.approvAmount,
    this.extendMaxCount,
    this.payFreq,
    this.levelNo,
    this.chkHoliday,
    this.shiftLastDay,
    this.requestId,
    this.lastTxnDate,
    this.payDay2,
    this.schedules,
    this.intTermUnit,
    this.modifiedBy,
    this.curCode,
    this.openDatetime,
    this.extendCount,
    this.chkSkipPartialPay,
    this.acntNo,
    this.intCalcMethod,
    this.advDatetime,
    this.intDayOption,
    this.custCode,
    this.prodCode,
    this.capfint,
    this.catCode,
    this.chkUseDateAmountReCalc,
    this.createdBy,
    this.intTermMethod,
    this.payDay,
    this.brchNo,
    this.termFree,
    this.basePaidAmt,
    this.feePaidAmt,
    this.advFeeBal,
    this.fineintDebtBal,
    this.princBal,
    this.nextPayDay,
    this.expiredDay,
    this.totalCurPayAmt,
    this.nextPayAsDay,
    this.prodName,
    this.isExpired,
  });

  Acnt.fromJson(Map<String, dynamic> json) {
    termSize = json['termSize'];
    openBy = json['openBy'];
    acntName = json['acntName'];
    dayOfYear = json['dayOfYear'];
    endDate = json['endDate'];
    coreAcntNo = json['coreAcntNo'];
    intIncAcnt = json['intIncAcnt'];
    payConstAmount = (json['payConstAmount'] ?? 0).toDouble();
    repayType = json['repayType'];
    intRecAcnt = json['intRecAcnt'];
    payMonth = json['payMonth'];
    begDate = json['begDate'];
    lastTxnDatetime = json['lastTxnDatetime'];
    termBasis = json['termBasis'];
    termUnit = json['termUnit'];
    purpCode = json['purpCode'];
    companyCode = json['companyCode'];
    branchId = json['branchId'];
    endDateGb = json['endDateGb'];
    coreProdCode = json['coreProdCode'];
    acntName2 = json['acntName2'];
    advAmt = (json['advAmt'] ?? 0).toDouble();
    termLen = json['termLen'];
    capFreq = json['capFreq'];
    approvDate = json['approvDate'];
    paidInt = (json['paidInt'] ?? 0).toDouble();
    tellerNo = json['tellerNo'];
    createdDatetime = json['createdDatetime'];
    startDate = json['startDate'];
    status = json['status'];
    intVal = (json['intVal'] ?? 0).toDouble();
    intRate = (json['intRate'] ?? 0).toDouble();
    modifiedDatetime = json['modifiedDatetime'];
    approvAmount = (json['approvAmount'] ?? 0).toDouble();
    extendMaxCount = json['extendMaxCount'];
    payFreq = json['payFreq'];
    levelNo = json['levelNo'];
    chkHoliday = json['chkHoliday'];
    shiftLastDay = json['shiftLastDay'];
    requestId = json['requestId'];
    lastTxnDate = json['lastTxnDate'];
    payDay2 = json['payDay2'];
    if (json['schedules'] != null) {
      schedules = new List<Sched>();
      json['schedules'].forEach((v) {
        schedules.add(new Sched.fromJson(v));
      });
    }
    intTermUnit = json['intTermUnit'];
    modifiedBy = json['modifiedBy'];
    curCode = json['curCode'];
    openDatetime = json['openDatetime'];
    extendCount = json['extendCount'];
    chkSkipPartialPay = json['chkSkipPartialPay'];
    acntNo = json['acntNo'];
    intCalcMethod = json['intCalcMethod'];
    advDatetime = json['advDatetime'];
    intDayOption = json['intDayOption'];
    custCode = json['custCode'];
    prodCode = json['prodCode'];
    capfint = (json['capfint'] ?? 0).toDouble();
    catCode = json['catCode'];
    chkUseDateAmountReCalc = json['chkUseDateAmountReCalc'];
    createdBy = json['createdBy'];
    intTermMethod = json['intTermMethod'];
    payDay = json['payDay'];
    brchNo = json['brchNo'];
    termFree = (json['termFree'] ?? 0).toDouble();
    basePaidAmt = (json['basePaidAmt'] ?? 0).toDouble();
    feePaidAmt = (json['feePaidAmt'] ?? 0).toDouble();
    advFeeBal = (json['advFeeBal'] ?? 0).toDouble();
    fineintDebtBal = (json['fineintDebtBal'] ?? 0).toDouble();
    princBal = (json['princBal'] ?? 0).toDouble();
    nextPayDay = json['nextPayDay'];
    expiredDay = json['expiredDay'];
    totalCurPayAmt = (json['totalCurPayAmt'] ?? 0).toDouble();
    nextPayAsDay = json['nextPayAsDay'];
    prodName = json['prodName'];
    isExpired = json['isExpired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['termSize'] = this.termSize;
    data['openBy'] = this.openBy;
    data['acntName'] = this.acntName;
    data['dayOfYear'] = this.dayOfYear;
    data['endDate'] = this.endDate;
    data['coreAcntNo'] = this.coreAcntNo;
    data['intIncAcnt'] = this.intIncAcnt;
    data['payConstAmount'] = this.payConstAmount;
    data['repayType'] = this.repayType;
    data['intRecAcnt'] = this.intRecAcnt;
    data['payMonth'] = this.payMonth;
    data['begDate'] = this.begDate;
    data['lastTxnDatetime'] = this.lastTxnDatetime;
    data['termBasis'] = this.termBasis;
    data['termUnit'] = this.termUnit;
    data['purpCode'] = this.purpCode;
    data['companyCode'] = this.companyCode;
    data['branchId'] = this.branchId;
    data['endDateGb'] = this.endDateGb;
    data['coreProdCode'] = this.coreProdCode;
    data['acntName2'] = this.acntName2;
    data['advAmt'] = this.advAmt;
    data['termLen'] = this.termLen;
    data['capFreq'] = this.capFreq;
    data['approvDate'] = this.approvDate;
    data['paidInt'] = this.paidInt;
    data['tellerNo'] = this.tellerNo;
    data['createdDatetime'] = this.createdDatetime;
    data['startDate'] = this.startDate;
    data['status'] = this.status;
    data['intVal'] = this.intVal;
    data['intRate'] = this.intRate;
    data['modifiedDatetime'] = this.modifiedDatetime;
    data['approvAmount'] = this.approvAmount;
    data['extendMaxCount'] = this.extendMaxCount;
    data['payFreq'] = this.payFreq;
    data['levelNo'] = this.levelNo;
    data['chkHoliday'] = this.chkHoliday;
    data['shiftLastDay'] = this.shiftLastDay;
    data['requestId'] = this.requestId;
    data['lastTxnDate'] = this.lastTxnDate;
    data['payDay2'] = this.payDay2;
//    if (this.schedules != null) {
//      data['schedules'] = this.schedules.map((v) => v.toJson()).toList();
//    }
    data['intTermUnit'] = this.intTermUnit;
    data['modifiedBy'] = this.modifiedBy;
    data['curCode'] = this.curCode;
    data['openDatetime'] = this.openDatetime;
    data['extendCount'] = this.extendCount;
    data['chkSkipPartialPay'] = this.chkSkipPartialPay;
    data['acntNo'] = this.acntNo;
    data['intCalcMethod'] = this.intCalcMethod;
    data['advDatetime'] = this.advDatetime;
    data['intDayOption'] = this.intDayOption;
    data['custCode'] = this.custCode;
    data['prodCode'] = this.prodCode;
    data['capfint'] = this.capfint;
    data['catCode'] = this.catCode;
    data['chkUseDateAmountReCalc'] = this.chkUseDateAmountReCalc;
    data['createdBy'] = this.createdBy;
    data['intTermMethod'] = this.intTermMethod;
    data['payDay'] = this.payDay;
    data['brchNo'] = this.brchNo;
    data['termFree'] = this.termFree;
    data['basePaidAmt'] = this.basePaidAmt;
    data['feePaidAmt'] = this.feePaidAmt;
    data['advFeeBal'] = this.advFeeBal;
    data['fineintDebtBal'] = this.fineintDebtBal;
    data['princBal'] = this.princBal;
    data['totalCurPayAmt'] = this.totalCurPayAmt;
    data['nextPayAsDay'] = this.nextPayAsDay;
    data['prodName'] = this.prodName;
    data['isExpired'] = this.isExpired;

    return data;
  }
}
