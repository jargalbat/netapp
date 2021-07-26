import 'package:netware/api/models/base_response.dart';

//int score; // Одоо байгаа бонус онооны хэмжээ
//int useFeeDecrease; // Оноогоо зээлийн лимитийг нэмэхэд ашиглаж болох эсэх
//int amtPerScore;
//int curLimit; //  Тухайн харилцагчийн авч болох зээлийн дээд утга
//int useLimitIncrease; // Оноогоо зээлийн шимтгэл/хүү бууруулахад ашиглаж болох эсэх
//int curLoanPrincBal; // Одоо байгаа үндсэн зээлийн нийлбэр дүн
//int curLoanTotalBal; // Одоо төлөгдөж дуусаагүй байгаа зээлүүдийн анх авсан нийлбэр дүн

class FeeScoreResponse extends BaseResponse {
  int useFeeDecrease;
  int bonusScore;
  List<Fees> fees;
  int useMinScore;
  double limitIncrDiff;
  String custCode;
  int usedScore;
  int useLimitIncrease; // 1, 0

  FeeScoreResponse(
      {this.useFeeDecrease, this.bonusScore, this.fees, this.useMinScore, this.limitIncrDiff, this.custCode, this.usedScore, this.useLimitIncrease});

  FeeScoreResponse.fromJson(Map<String, dynamic> json) {
    // Base response
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];

    //
    useFeeDecrease = json['useFeeDecrease'];
    bonusScore = json['bonusScore'];
    if (json['fees'] != null) {
      fees = new List<Fees>();
      json['fees'].forEach((v) {
        fees.add(new Fees.fromJson(v));
      });
    }
    useMinScore = json['useMinScore'];
//    curLoanTotalBal = json['curLoanTotalBal'].toDouble();
    limitIncrDiff = (json['limitIncrDiff'] ?? 0).toDouble();
    custCode = json['custCode'];
    usedScore = json['usedScore'];
//    curLimit = json['curLimit'];
//    curLoanPrincBal = json['curLoanPrincBal'].toDouble();
    useLimitIncrease = json['useLimitIncrease'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['useFeeDecrease'] = this.useFeeDecrease;
    data['bonusScore'] = this.bonusScore;
    if (this.fees != null) {
      data['fees'] = this.fees.map((v) => v.toJson()).toList();
    }
    data['useMinScore'] = this.useMinScore;
//    data['curLoanTotalBal'] = this.curLoanTotalBal;
    data['limitIncrDiff'] = this.limitIncrDiff;
    data['custCode'] = this.custCode;
    data['usedScore'] = this.usedScore;
//    data['curLimit'] = this.curLimit;
//    data['curLoanPrincBal'] = this.curLoanPrincBal;
    data['useLimitIncrease'] = this.useLimitIncrease;
    return data;
  }
}

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

class FeeTerms {
  int termSize;
  String prodCode;
  String feeMethod;
  double feeSize;
  int feeId;
  double feeDecrDiff;

  FeeTerms({this.termSize, this.prodCode, this.feeMethod, this.feeSize, this.feeId, this.feeDecrDiff});

  FeeTerms.fromJson(Map<String, dynamic> json) {
    termSize = json['termSize'];
    prodCode = json['prodCode'];
    feeMethod = json['feeMethod'];
    feeSize = (json['feeSize'] ?? 0).toDouble();
    feeId = json['feeId'];
    feeDecrDiff = (json['feeDecrDiff'] ?? 0).toDouble();
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
//
//class LimitFeeScoreResponse extends BaseResponse {
//  int useFeeDecrease;
//  int bonusScore;
//  List<Fees> fees;
////  double feeDecreasePercent;
//  int useMinScore;
//  int curLoanTotalBal;
//  int curLimit;
//  int usedScore;
//  int curLoanPrincBal;
//  int useLimitIncrease;
//
//  LimitFeeScoreResponse(
//      {this.useFeeDecrease,
//      this.bonusScore,
//      this.fees,
//      this.feeDecreasePercent,
//      this.useMinScore,
//      this.curLoanTotalBal,
//      this.curLimit,
//      this.usedScore,
//      this.curLoanPrincBal,
//      this.useLimitIncrease});
//
//  LimitFeeScoreResponse.fromJson(Map<String, dynamic> json) {
//    resultCode = json['resultCode'];
//    resultDesc = json['resultDesc'];
//
//    useFeeDecrease = json['useFeeDecrease'];
//    bonusScore = json['bonusScore'];
//    if (json['fees'] != null) {
//      fees = new List<Fees>();
//      json['fees'].forEach((v) {
//        fees.add(new Fees.fromJson(v));
//      });
//    }
////    feeDecreasePercent = json['feeDecreasePercent'].toDouble();
//    useMinScore = json['useMinScore'];
//    curLoanTotalBal = json['curLoanTotalBal'];
//    curLimit = json['curLimit'];
//    usedScore = json['usedScore'];
//    curLoanPrincBal = json['curLoanPrincBal'];
//    useLimitIncrease = json['useLimitIncrease'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['useFeeDecrease'] = this.useFeeDecrease;
//    data['bonusScore'] = this.bonusScore;
//    if (this.fees != null) {
//      data['fees'] = this.fees.map((v) => v.toJson()).toList();
//    }
////    data['feeDecreasePercent'] = this.feeDecreasePercent;
//    data['useMinScore'] = this.useMinScore;
//    data['curLoanTotalBal'] = this.curLoanTotalBal;
//    data['curLimit'] = this.curLimit;
//    data['usedScore'] = this.usedScore;
//    data['curLoanPrincBal'] = this.curLoanPrincBal;
//    data['useLimitIncrease'] = this.useLimitIncrease;
//    return data;
//  }
//}
//
//class Fees {
//  int orderNo;
//  int isMain;
//  List<FeeTerms> feeTerms;
//  String calcType;
//  String description;
//  int feeId;
//
//  Fees({this.orderNo, this.isMain, this.feeTerms, this.calcType, this.description, this.feeId});
//
//  Fees.fromJson(Map<String, dynamic> json) {
//    orderNo = json['orderNo'];
//    isMain = json['isMain'];
//    if (json['feeTerms'] != null) {
//      feeTerms = new List<FeeTerms>();
//      json['feeTerms'].forEach((v) {
//        feeTerms.add(new FeeTerms.fromJson(v));
//      });
//    }
//    calcType = json['calcType'];
//    description = json['description'];
//    feeId = json['feeId'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['orderNo'] = this.orderNo;
//    data['isMain'] = this.isMain;
//    if (this.feeTerms != null) {
//      data['feeTerms'] = this.feeTerms.map((v) => v.toJson()).toList();
//    }
//    data['calcType'] = this.calcType;
//    data['description'] = this.description;
//    data['feeId'] = this.feeId;
//    return data;
//  }
//}
//
//class FeeTerms {
//  int termSize;
//  String prodCode;
//  double feeSize;
//  String feeMethod;
//  int feeId;
//
//  FeeTerms({this.termSize, this.prodCode, this.feeSize, this.feeMethod, this.feeId});
//
//  FeeTerms.fromJson(Map<String, dynamic> json) {
//    termSize = json['termSize'];
//    prodCode = json['prodCode'];
//    feeSize = json['feeSize'].toDouble();
//    feeMethod = json['feeMethod'];
//    feeId = json['feeId'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['termSize'] = this.termSize;
//    data['prodCode'] = this.prodCode;
//    data['feeSize'] = this.feeSize;
//    data['feeMethod'] = this.feeMethod;
//    data['feeId'] = this.feeId;
//    return data;
//  }
//}

//class LoanInfoResponse extends BaseResponse {
//  int useFeeDecrease;
//  int bonusScore;
//  ScoreConfig scoreConfig;
//  int curLimit;
//  int useLimitIncrease;
//
//  LoanInfoResponse({this.useFeeDecrease, this.bonusScore, this.scoreConfig, this.curLimit, this.useLimitIncrease});
//
//  LoanInfoResponse.fromJson(Map<String, dynamic> json) {
//    resultCode = json['resultCode'];
//    resultDesc = json['resultDesc'];
//    useFeeDecrease = json['useFeeDecrease'];
//    bonusScore = json['bonusScore'];
//    scoreConfig = json['scoreConfig'] != null ? new ScoreConfig.fromJson(json['scoreConfig']) : null;
//    curLimit = json['curLimit'];
//    useLimitIncrease = json['useLimitIncrease'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['useFeeDecrease'] = this.useFeeDecrease;
//    data['bonusScore'] = this.bonusScore;
//    if (this.scoreConfig != null) {
//      data['scoreConfig'] = this.scoreConfig.toJson();
//    }
//    data['curLimit'] = this.curLimit;
//    data['useLimitIncrease'] = this.useLimitIncrease;
//    return data;
//  }
//}
//
//class ScoreConfig {
//  String companyCode;
//  int useMinBonus;
//  String useBonusLimitType;
//  double bonusToFee;
//  String initLimit;
//  String useBonusFeeType;
//  int bonusToLimit;
//  String bonusGive;
//
//  ScoreConfig(
//      {this.companyCode, this.useMinBonus, this.useBonusLimitType, this.bonusToFee, this.initLimit, this.useBonusFeeType, this.bonusToLimit, this.bonusGive});
//
//  ScoreConfig.fromJson(Map<String, dynamic> json) {
//    companyCode = json['companyCode'];
//    useMinBonus = json['useMinBonus'];
//    useBonusLimitType = json['useBonusLimitType'];
//    bonusToFee = json['bonusToFee'];
//    initLimit = json['initLimit'];
//    useBonusFeeType = json['useBonusFeeType'];
//    bonusToLimit = json['bonusToLimit'];
//    bonusGive = json['bonusGive'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['companyCode'] = this.companyCode;
//    data['useMinBonus'] = this.useMinBonus;
//    data['useBonusLimitType'] = this.useBonusLimitType;
//    data['bonusToFee'] = this.bonusToFee;
//    data['initLimit'] = this.initLimit;
//    data['useBonusFeeType'] = this.useBonusFeeType;
//    data['bonusToLimit'] = this.bonusToLimit;
//    data['bonusGive'] = this.bonusGive;
//    return data;
//  }
//}

//class LoanInfoResponse extends BaseResponse {
//  int score; // Одоо байгаа бонус онооны хэмжээ
//  int useFeeDecrease; // Оноогоо зээлийн лимитийг нэмэхэд ашиглаж болох эсэх
//  int amtPerScore;
//  int curLimit; //  Тухайн харилцагчийн авч болох зээлийн дээд утга
//  int useLimitIncrease; // Оноогоо зээлийн шимтгэл/хүү бууруулахад ашиглаж болох эсэх
//  int curLoanPrincBal; // Одоо байгаа үндсэн зээлийн нийлбэр дүн todo
//  int curLoanTotalBal; // Одоо төлөгдөж дуусаагүй байгаа зээлүүдийн анх авсан нийлбэр дүн todo
//
//  LoanInfoResponse({this.score, this.useFeeDecrease, this.amtPerScore, this.curLimit, this.useLimitIncrease});
//
//  LoanInfoResponse.fromJson(Map<String, dynamic> json) {
//    resultCode = json['resultCode'];
//    resultDesc = json['resultDesc'];
//    score = json['score'];
//    useFeeDecrease = json['useFeeDecrease'];
//    amtPerScore = json['amtPerScore'];
//    curLimit = json['curLimit'];
//    useLimitIncrease = json['useLimitIncrease'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['score'] = this.score;
//    data['useFeeDecrease'] = this.useFeeDecrease;
//    data['amtPerScore'] = this.amtPerScore;
//    data['curLimit'] = this.curLimit;
//    data['useLimitIncrease'] = this.useLimitIncrease;
//    return data;
//  }
//}

//Ok. Тхх, оноо ашиглах гэж нэмэгдэнэ гэсэн. Prototype дээр алга байна уу?
//3:57
//Оноогоо хоёр янзаар ашиглана
//3:57
//Зээлийн лимитийг нэмэх
//3:57
//2. Шимтгэл/хүүг бууруулах
//3:57
//Зээлийн лимитийг нэмж байгаа тохиолдолд серверээс хэдэн оноогоор хэдэн төг юм уу хувь нэмэх вэ гэдэг нь шууд ирнэ
//3:58
//Утсан дээр оноо ашиглах хэсэг дэх ашиглаж байгаа онооноос хамаарч зээлийн хэмжээг шууд нэмж харуулна
//3:58
//2 дахь тохиолдол буюу шимтгэл/хүү бууруулж байгаа үед шууд харуулж чадахгүй
//3:58
//Ашиглах оноогоо оруулаад серверийн функц дуудна
//3:58
//Тэгэхэд ийм хэмжээний шимтгэл авна эсвэл ийм хүүтэйгээр олгох боломжтой гэж буцаана гэсэн үг
