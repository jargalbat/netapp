import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class UseBonusFeeRequest extends BaseRequest {
  UseBonusFeeRequest({
    this.score,
  }) {
    this.func = Operation.useBonusFee;
  }

  int score;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;

    base(data);

    return data;
  }
}
