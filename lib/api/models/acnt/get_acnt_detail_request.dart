import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class GetAcntDetailRequest extends BaseRequest {
  GetAcntDetailRequest({
    this.acntNo,
  }) {
    this.func = Operation.getAcntDetail;
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

class GetOfflineAcntDetailRequest extends BaseRequest {
  GetOfflineAcntDetailRequest({
    this.acntNo,
  }) {
    this.func = Operation.getLoanAcntOfflineInfo;
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
