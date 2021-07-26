import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class UpdateProfileRequest extends BaseRequest {
  String regNo;
  String firstName;
  String lastName;
  int maritalId;
  String sex;
  String loginName;
  String mobileNo;
  int userId;
  String custCode;
  String addrDetail;
  String email;

  UpdateProfileRequest({
    this.regNo,
    this.firstName,
    this.lastName,
    this.maritalId,
    this.sex,
    this.loginName,
    this.mobileNo,
    this.userId,
    this.custCode,
    this.email,
    this.addrDetail,
  }) {
    this.func = Operation.updateProfile;
  }

  UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    regNo = json['regNo'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    maritalId = json['maritalId'];
    sex = json['sex'];
    loginName = json['loginName'];
    mobileNo = json['mobileNo'];
    userId = json['userId'];
    custCode = json['custCode'];
    addrDetail = json['addrDetail'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regNo'] = this.regNo;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['maritalId'] = this.maritalId;
    data['sex'] = this.sex;
    data['loginName'] = this.loginName;
    data['mobileNo'] = this.mobileNo;
    data['userId'] = this.userId;
    data['custCode'] = this.custCode;
    data['addrDetail'] = this.addrDetail;
    data['email'] = this.email;

    base(data);

    return data;
  }
}
