import 'package:netware/api/models/base_response.dart';
import 'package:netware/api/models/base_response.dart';

class LoginResponse extends BaseResponse {
  UserInfo userInfo;

//  List<Null> companies;
  String session;
  String loginName;
  int resultCode;
  String loginDate;
  String resultDesc;
  int userId;
  int biometricAuth;

  LoginResponse({
    this.userInfo,
//      this.companies,
    this.session,
    this.loginName,
    this.resultCode,
    this.loginDate,
    this.resultDesc,
    this.userId,
    this.biometricAuth,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    userInfo = json['userInfo'] != null ? new UserInfo.fromJson(json['userInfo']) : null;
    session = json['session'];
    loginName = json['loginName'];
    loginDate = json['loginDate'];
    userId = json['userId'];
    biometricAuth = json['biometricAuth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo.toJson();
    }
//    if (this.companies != null) {
//      data['companies'] = this.companies.map((v) => v.toJson()).toList();
//    }
    data['session'] = this.session;
    data['loginName'] = this.loginName;
    data['resultCode'] = this.resultCode;
    data['loginDate'] = this.loginDate;
    data['resultDesc'] = this.resultDesc;
    data['userId'] = this.userId;
    data['biometricAuth'] = this.biometricAuth;
    return data;
  }
}

class UserInfo {
  String regNo;
  String lastName;
  String modifiedDatetime;
  String mobileNo;
  int hadAdditionInfo; // // Нэмэлт мэдээллээ оруулсан эсэх
  String roleType;
  int userId;
  String custCode;
  int reqId;
  String firstName;
  String roleTypeName;
  int isValidated; // Баталгаажсан эсэх
  int userLevel;
  int createdBy;
  String loginName;
  String userTypeName;
  String statusName;
  int modifiedBy;
  String createdDatetime;
  String userType;
  String status;
  String fbId;
  String fbName;
  String email;
  String addrDetail;
  int maritalId;
  String sex; //gender
  String imgAsBase64;

  UserInfo({
    this.regNo,
    this.lastName,
    this.modifiedDatetime,
    this.mobileNo,
    this.hadAdditionInfo,
    this.roleType,
    this.userId,
    this.custCode,
    this.reqId,
    this.firstName,
    this.roleTypeName,
    this.userLevel,
    this.isValidated,
    this.createdBy,
    this.loginName,
    this.userTypeName,
    this.statusName,
    this.modifiedBy,
    this.createdDatetime,
    this.userType,
    this.status,
    this.fbId,
    this.fbName,
    this.email,
    this.addrDetail,
    this.maritalId,
    this.sex,
    this.imgAsBase64,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    regNo = json['regNo'];
    lastName = json['lastName'];
    modifiedDatetime = json['modifiedDatetime'];
    mobileNo = json['mobileNo'];
    hadAdditionInfo = json['hadAdditionInfo'];
    roleType = json['roleType'];
    userId = json['userId'];
    custCode = json['custCode'];
    reqId = json['reqId'];
    firstName = json['firstName'];
    roleTypeName = json['roleTypeName'];
    userLevel = json['userLevel'];
    isValidated = json['isValidated'];
    createdBy = json['createdBy'];
    loginName = json['loginName'];
    userTypeName = json['userTypeName'];
    statusName = json['statusName'];
    modifiedBy = json['modifiedBy'];
    createdDatetime = json['createdDatetime'];
    userType = json['userType'];
    status = json['status'];
    fbId = json['fbId'];
    fbName = json['fbName'];
    email = json['email'];
    addrDetail = json['addrDetail'];
    maritalId = json['maritalId'];
    sex = json['sex'];
    imgAsBase64 = json['imgAsBase64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regNo'] = this.regNo;
    data['lastName'] = this.lastName;
    data['modifiedDatetime'] = this.modifiedDatetime;
    data['mobileNo'] = this.mobileNo;
    data['hadAdditionInfo'] = this.hadAdditionInfo;
    data['roleType'] = this.roleType;
    data['userId'] = this.userId;
    data['custCode'] = this.custCode;
    data['reqId'] = this.reqId;
    data['firstName'] = this.firstName;
    data['roleTypeName'] = this.roleTypeName;
    data['userLevel'] = this.userLevel;
    data['isValidated'] = this.isValidated;
    data['createdBy'] = this.createdBy;
    data['loginName'] = this.loginName;
    data['userTypeName'] = this.userTypeName;
    data['statusName'] = this.statusName;
    data['modifiedBy'] = this.modifiedBy;
    data['createdDatetime'] = this.createdDatetime;
    data['userType'] = this.userType;
    data['status'] = this.status;
    data['fbId'] = this.fbId;
    data['fbName'] = this.fbName;
    data['email'] = this.email;
    data['addrDetail'] = this.addrDetail;
    data['maritalId'] = this.maritalId;
    data['sex'] = this.sex;
    data['imgAsBase64'] = this.imgAsBase64;

    return data;
  }
}
