import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class GetPayInfoOnlineRequest extends BaseRequest {
  GetPayInfoOnlineRequest({
    this.acntNo,
  }) {
    this.func = Operation.getPayInfoOnline;
  }

  String acntNo;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['acntNo'] = this.acntNo;

    base(data);

    return data;
  }
}
