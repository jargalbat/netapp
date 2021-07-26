import 'package:netware/api/bloc/operation.dart';
import 'package:netware/api/models/base_request.dart';

class CreateQpayQrCodeRequest extends BaseRequest {
  String acntCode;
  int termSize; // Зээл төлөх дээр 0, шимтгэл төлөх дээр утгатай байна
  String paymentCode; // Шимтгэл төлөх, үндсэн төлбөр төлөх эсэхийг шийднэ

  CreateQpayQrCodeRequest({this.acntCode, this.termSize, this.paymentCode}) {
    this.func = Operation.createQpayQrCode;
  }

  CreateQpayQrCodeRequest.fromJson(Map<String, dynamic> json) {
    acntCode = json['acntCode'];
    termSize = json['termSize'];
    paymentCode = json['paymentCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acntCode'] = this.acntCode;
    data['termSize'] = this.termSize;
    data['paymentCode'] = this.paymentCode;

    base(data);

    return data;
  }
}
