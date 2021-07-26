import 'package:netware/api/bloc/api_helper.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/api/models/base_response.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/utils/func.dart';

class BranchListResponse extends BaseResponse {
  List<Branch> branchList;

  BranchListResponse({this.branchList});

  BranchListResponse.fromJson(List<dynamic> json) {
    try {
      var list = json ?? new List<Branch>();
      branchList = list.map((i) => Branch.fromJson(i)).toList();

      if (branchList != null && branchList.isNotEmpty) {
        resultCode = ResponseCode.Success;
        resultDesc = 'Success';
      }
    } catch (e) {
      resultCode = ResponseCode.Failed;
      resultDesc = globals.text.errorOccurred();
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Branch {
  String companyCode;
  String coreLoanappNo;
  int branchId;
  int orderNo;
  int headEmpId;
  String latitude;
  String companyName;
  String modifiedDatetime;
  String addrName;
  String timetable;
  String coreBrchCode;
  String headEmpName;
  String phone;
  int createdBy;
  String name;
  int modifiedBy;
  int addrId;
  String createdDatetime;
  String name2;
  String fax;
  String email;
  int status;
  String longitude;

  Branch(
      {this.companyCode,
      this.coreLoanappNo,
      this.branchId,
      this.orderNo,
      this.headEmpId,
      this.latitude,
      this.companyName,
      this.modifiedDatetime,
      this.addrName,
      this.timetable,
      this.coreBrchCode,
      this.headEmpName,
      this.phone,
      this.createdBy,
      this.name,
      this.modifiedBy,
      this.addrId,
      this.createdDatetime,
      this.name2,
      this.fax,
      this.email,
      this.status,
      this.longitude});

  Branch.fromJson(Map<String, dynamic> json) {
    companyCode = json['companyCode'];
    coreLoanappNo = json['coreLoanappNo'];
    branchId = json['branchId'];
    orderNo = json['orderNo'];
    headEmpId = json['headEmpId'];
    latitude = json['latitude'];
    companyName = json['companyName'];
    modifiedDatetime = json['modifiedDatetime'];
    addrName = json['addrName'];
    timetable = json['timetable'];
    coreBrchCode = json['coreBrchCode'];
    headEmpName = json['headEmpName'];
    phone = json['phone'];
    createdBy = json['createdBy'];
    name = json['name'];
    modifiedBy = json['modifiedBy'];
    addrId = json['addrId'];
    createdDatetime = json['createdDatetime'];
    name2 = json['name2'];
    fax = json['fax'];
    email = json['email'];
    status = json['status'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyCode'] = this.companyCode;
    data['coreLoanappNo'] = this.coreLoanappNo;
    data['branchId'] = this.branchId;
    data['orderNo'] = this.orderNo;
    data['headEmpId'] = this.headEmpId;
    data['latitude'] = this.latitude;
    data['companyName'] = this.companyName;
    data['modifiedDatetime'] = this.modifiedDatetime;
    data['addrName'] = this.addrName;
    data['timetable'] = this.timetable;
    data['coreBrchCode'] = this.coreBrchCode;
    data['headEmpName'] = this.headEmpName;
    data['phone'] = this.phone;
    data['createdBy'] = this.createdBy;
    data['name'] = this.name;
    data['modifiedBy'] = this.modifiedBy;
    data['addrId'] = this.addrId;
    data['createdDatetime'] = this.createdDatetime;
    data['name2'] = this.name2;
    data['fax'] = this.fax;
    data['email'] = this.email;
    data['status'] = this.status;
    data['longitude'] = this.longitude;
    return data;
  }

  String getName() {
    return Func.toStr(globals.langCode == LangCode.en ? name2 : name);
  }
}
