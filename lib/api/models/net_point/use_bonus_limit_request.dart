import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class UseBonusLimitRequest extends BaseRequest {
  UseBonusLimitRequest({
    this.score,
  }) {
    this.func = Operation.useBonusLimit;
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
