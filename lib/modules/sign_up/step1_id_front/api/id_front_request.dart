import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class IdFrontRequest extends BaseRequest {
  String idImg; //filename

  IdFrontRequest({this.idImg}) {
    this.func = Operation.stepID;
    this.idImg = idImg;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['idImg'] = this.idImg;

    /// base data
    base(data);

    return data;
  }
}
