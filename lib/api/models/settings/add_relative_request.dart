import 'package:netware/api/bloc/operation.dart';
import 'package:netware/api/models/base_request.dart';

class AddRelativeRequest extends BaseRequest {
  int relId;
  String firstName;
  String lastName;
  String regNo;
  String mobileNo;
  int liveWith;

  AddRelativeRequest({this.relId, this.firstName, this.lastName, this.regNo, this.mobileNo, this.liveWith}) {
    this.func = Operation.insertRelative;
  }

  AddRelativeRequest.fromJson(Map<String, dynamic> json) {
    relId = json['relId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    regNo = json['regNo'];
    mobileNo = json['mobileNo'];
    liveWith = json['liveWith'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relId'] = this.relId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['regNo'] = this.regNo;
    data['mobileNo'] = this.mobileNo;
    data['liveWith'] = this.liveWith;

    base(data);

    return data;
  }
}
