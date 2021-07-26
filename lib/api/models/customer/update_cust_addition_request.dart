import 'package:netware/api/bloc/operation.dart';
import 'package:netware/api/models/base_request.dart';

class UpdateCustAdditionRequest extends BaseRequest {
  String quarterEffectCode;
  int yearEarn;
  int carpenaltyCount;
  String positionCode;
  String mobileUsageCode;
  int repayRel;
  String bankappUsageCode;
  String educationLevel;
  String incValidType;
  String privInfoEnterContract;
  String wrokCompanyName;
  int earnFamilyMemberPercent;
  String addrType;
  int familyMemberCount;
  String existLoanHist;
  int carCount;
  String houseType;
  String howKnowBrchAddr;
  int loanCount;
  int earnFamMemberCount;
  String loanHistType;
  int totalInc;
  String custCode;
  String contractAspirCode;
  int realestateCount;
  int loanFamilyMemberRelId;
  String positionDegree;
  String behavCode;
  String civilType;
  int monthlyPayLoan;
  int businessExp;
  int avgSalary;
  int busLineId;
  String communCode;
  String readContractCode;
  String officeTypeCode;
  String officeType;
  String email;
  String employmentType;

  UpdateCustAdditionRequest(
      {this.quarterEffectCode,
      this.yearEarn,
      this.carpenaltyCount,
      this.positionCode,
      this.mobileUsageCode,
      this.repayRel,
      this.bankappUsageCode,
      this.educationLevel,
      this.incValidType,
      this.privInfoEnterContract,
      this.wrokCompanyName,
      this.earnFamilyMemberPercent,
      this.addrType,
      this.familyMemberCount,
      this.existLoanHist,
      this.carCount,
      this.houseType,
      this.howKnowBrchAddr,
      this.loanCount,
      this.earnFamMemberCount,
      this.loanHistType,
      this.totalInc,
      this.custCode,
      this.contractAspirCode,
      this.realestateCount,
      this.loanFamilyMemberRelId,
      this.positionDegree,
      this.behavCode,
      this.civilType,
      this.monthlyPayLoan,
      this.businessExp,
      this.avgSalary,
      this.busLineId,
      this.communCode,
      this.readContractCode,
      this.officeTypeCode,
      this.officeType,
      this.email,
      this.employmentType}) {
    this.func = Operation.updateCustAddition;
  }

  UpdateCustAdditionRequest.fromJson(Map<String, dynamic> json) {
    quarterEffectCode = json['quarterEffectCode'];
    yearEarn = json['yearEarn'];
    carpenaltyCount = json['carpenaltyCount'];
    positionCode = json['positionCode'];
    mobileUsageCode = json['mobileUsageCode'];
    repayRel = json['repayRel'];
    bankappUsageCode = json['bankappUsageCode'];
    educationLevel = json['educationLevel'];
    incValidType = json['incValidType'];
    privInfoEnterContract = json['privInfoEnterContract'];
    wrokCompanyName = json['wrokCompanyName'];
    earnFamilyMemberPercent = json['earnFamilyMemberPercent'];
    addrType = json['addrType'];
    familyMemberCount = json['familyMemberCount'];
    existLoanHist = json['existLoanHist'];
    carCount = json['carCount'];
    houseType = json['houseType'];
    howKnowBrchAddr = json['howKnowBrchAddr'];
    loanCount = json['loanCount'];
    earnFamMemberCount = json['earnFamMemberCount'];
    loanHistType = json['loanHistType'];
    totalInc = json['totalInc'];
    custCode = json['custCode'];
    contractAspirCode = json['contractAspirCode'];
    realestateCount = json['realestateCount'];
    loanFamilyMemberRelId = json['loanFamilyMemberRelId'];
    positionDegree = json['positionDegree'];
    behavCode = json['behavCode'];
    civilType = json['civilType'];
    monthlyPayLoan = json['monthlyPayLoan'];
    businessExp = json['businessExp'];
    avgSalary = json['avgSalary'];
    busLineId = json['busLineId'];
    communCode = json['communCode'];
    readContractCode = json['readContractCode'];
    officeTypeCode = json['officeTypeCode'];
    officeType = json['officeType'];
    email = json['email'];
    employmentType = json['employmentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quarterEffectCode'] = this.quarterEffectCode;
    data['yearEarn'] = this.yearEarn;
    data['carpenaltyCount'] = this.carpenaltyCount;
    data['positionCode'] = this.positionCode;
    data['mobileUsageCode'] = this.mobileUsageCode;
    data['repayRel'] = this.repayRel;
    data['bankappUsageCode'] = this.bankappUsageCode;
    data['educationLevel'] = this.educationLevel;
    data['incValidType'] = this.incValidType;
    data['privInfoEnterContract'] = this.privInfoEnterContract;
    data['wrokCompanyName'] = this.wrokCompanyName;
    data['earnFamilyMemberPercent'] = this.earnFamilyMemberPercent;
    data['addrType'] = this.addrType;
    data['familyMemberCount'] = this.familyMemberCount;
    data['existLoanHist'] = this.existLoanHist;
    data['carCount'] = this.carCount;
    data['houseType'] = this.houseType;
    data['howKnowBrchAddr'] = this.howKnowBrchAddr;
    data['loanCount'] = this.loanCount;
    data['earnFamMemberCount'] = this.earnFamMemberCount;
    data['loanHistType'] = this.loanHistType;
    data['totalInc'] = this.totalInc;
    data['custCode'] = this.custCode;
    data['contractAspirCode'] = this.contractAspirCode;
    data['realestateCount'] = this.realestateCount;
    data['loanFamilyMemberRelId'] = this.loanFamilyMemberRelId;
    data['positionDegree'] = this.positionDegree;
    data['behavCode'] = this.behavCode;
    data['civilType'] = this.civilType;
    data['monthlyPayLoan'] = this.monthlyPayLoan;
    data['businessExp'] = this.businessExp;
    data['avgSalary'] = this.avgSalary;
    data['busLineId'] = this.busLineId;
    data['communCode'] = this.communCode;
    data['readContractCode'] = this.readContractCode;
    data['officeTypeCode'] = this.officeTypeCode;
    data['officeType'] = this.officeType;
    data['email'] = this.email;
    data['employmentType'] = this.employmentType;

    base(data);

    return data;
  }
}
