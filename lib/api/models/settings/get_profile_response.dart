import 'package:netware/api/models/base_response.dart';

class GetProfileResponse extends BaseResponse {
  String regNo;
  String lastName;
  String sex;
  String mobileNo;
  int userId;
  String custCode;
  String firstName;
  String loginName;
  int maritalId;
  String fbId;
  String addrDetail;
  String email;
  String fbName;

  GetProfileResponse(
      {this.regNo,
      this.lastName,
      this.sex,
      this.mobileNo,
      this.userId,
      this.custCode,
      this.firstName,
      this.loginName,
      this.maritalId,
      this.fbId,
      this.addrDetail,
      this.email,
      this.fbName});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    regNo = json['regNo'];
    lastName = json['lastName'];
    sex = json['sex'];
    mobileNo = json['mobileNo'];
    userId = json['userId'];
    custCode = json['custCode'];
    firstName = json['firstName'];
    loginName = json['loginName'];
    maritalId = json['maritalId'];
    fbId = json['fbId'];
    addrDetail = json['addrDetail'];
    email = json['email'];
    fbName = json['fbName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regNo'] = this.regNo;
    data['lastName'] = this.lastName;
    data['sex'] = this.sex;
    data['mobileNo'] = this.mobileNo;
    data['userId'] = this.userId;
    data['custCode'] = this.custCode;
    data['firstName'] = this.firstName;
    data['loginName'] = this.loginName;
    data['maritalId'] = this.maritalId;
    data['fbId'] = this.fbId;
    data['addrDetail'] = this.addrDetail;
    data['email'] = this.email;
    data['fbName'] = this.fbName;
    return data;
  }
}
