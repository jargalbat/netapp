import 'package:netware/api/models/base_response.dart';
import 'package:netware/app/globals.dart';

class DictionaryResponse extends BaseResponse {
  List<DictionaryData> dictionaryList;

  DictionaryResponse({this.dictionaryList});

  DictionaryResponse.fromJson(List<dynamic> json) {
    try {
      var list = json ?? new List<DictionaryData>();

      if(list != null && list.isNotEmpty) {
        resultCode = 0;
        resultDesc = 'Success';
        dictionaryList = list.map((i) => DictionaryData.fromJson(i)).toList();
      }

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

class DictionaryData {
  String val;
  String txt;
  int orderNo;

  DictionaryData({this.val, this.txt, this.orderNo});

  DictionaryData.fromJson(Map<String, dynamic> json) {
    val = json['val'];
    txt = json['txt'];
    orderNo = json['orderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['val'] = this.val;
    data['txt'] = this.txt;
    data['orderNo'] = this.orderNo;
    return data;
  }
}
