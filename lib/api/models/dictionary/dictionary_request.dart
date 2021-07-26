import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/bloc/operation.dart';

class DictionaryRequest extends BaseRequest {
  DictionaryRequest({this.dictionaryCode}) {
    this.func = Operation.getDictionaryData;
  }

  final String dictionaryCode;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['dictionaryCode'] = this.dictionaryCode;

    /// base data
    base(data);

    return data;
  }

  String getString() {
    return dictionaryCode;
  }
}
