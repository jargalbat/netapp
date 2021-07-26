import 'package:netware/api/models/base_response.dart';
import 'package:netware/app/globals.dart';

class RelativeListResponse extends BaseResponse {
  List<Relative> relativeList;

  RelativeListResponse({this.relativeList});

  RelativeListResponse.fromJson(List<dynamic> json) {
    try {
      var list = json ?? new List<Relative>();
      relativeList = list.map((i) => Relative.fromJson(i)).toList();
      resultCode = 0;
      resultDesc = '';
    } catch (e) {
      resultCode = 99;
      resultDesc = globals.text.errorOccurred();
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Relative {
  String regNo;
  String firstName;
  String lastName;
  int relId;
  String relName;
  int liveWith;
  int relativeId;
  String mobileNo;
  String custCode;

  Relative({this.regNo, this.firstName, this.lastName, this.relId, this.relName, this.liveWith, this.relativeId, this.mobileNo, this.custCode});

  Relative.fromJson(Map<String, dynamic> json) {
    regNo = json['regNo'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    relId = json['relId'];
    relName = json['relName'];
    liveWith = json['liveWith'];
    relativeId = json['relativeId'];
    mobileNo = json['mobileNo'];
    custCode = json['custCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regNo'] = this.regNo;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['relId'] = this.relId;
    data['relName'] = this.relName;
    data['liveWith'] = this.liveWith;
    data['relativeId'] = this.relativeId;
    data['mobileNo'] = this.mobileNo;
    data['custCode'] = this.custCode;
    return data;
  }
}
