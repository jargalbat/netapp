import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/base_response.dart';

class OfflineLoanListResponse extends BaseResponse {
  int bonusScore;
  double curLoanTotalBal;
  List<Acnt> acnts;

  OfflineLoanListResponse({this.bonusScore, this.curLoanTotalBal, this.acnts});

  OfflineLoanListResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];

    bonusScore = json['bonusScore'];
    curLoanTotalBal = (json['curLoanTotalBal'] ?? 0).toDouble();
    if (json['acnts'] != null) {
      acnts = new List<Acnt>();
      json['acnts'].forEach((v) {
        acnts.add(new Acnt.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bonusScore'] = this.bonusScore;
    data['curLoanTotalBal'] = this.curLoanTotalBal;
    if (this.acnts != null) {
      data['acnts'] = this.acnts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
