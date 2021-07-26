import 'package:netware/api/models/base_response.dart';

class SettingsLinkResponse extends BaseResponse {
  String web;
  String faq;
  String contact;
  String userGuide;

  //Note: faq, userGuide-ыг main url дээр залгаж дуудна
//    {
//      "web": "http://www.netcapital.mn/",
//      "faq": "mn/mobile/faq.html",
//      "contact": "99073149",
//      "userGuide": "mn/mobile/guide.html"
//    }

  SettingsLinkResponse({this.web, this.faq, this.contact, this.userGuide});

  SettingsLinkResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    web = json['web'];
    faq = json['faq'];
    contact = json['contact'];
    userGuide = json['userGuide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['web'] = this.web;
    data['faq'] = this.faq;
    data['contact'] = this.contact;
    data['userGuide'] = this.userGuide;
    return data;
  }
}
