import 'package:netware/api/models/base_response.dart';
import 'package:netware/app/globals.dart';

class NotifListResponse extends BaseResponse {
  List<Notif> notifList;

  NotifListResponse({this.notifList});

  NotifListResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    notifList = <Notif>[];

    try {
      if (json.containsKey('data')) {
        var list = json['data'];
        var l = list.map((i) => Notif.fromJson(i)).toList();
//        notifList.addAll(l);
        notifList = List<Notif>.from(l);
        resultCode = 0;
        resultDesc = '';
      } else {
        resultCode = 99;
        resultDesc = globals.text.noData();
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

class Notif {
  int notifId;
  String companyCode;
  int configId;
  int fromFunc;
  int isRead;
  String title;
  String body;
  int userId;
  String status;
  String sentDatetime;
  String channelCode;

  Notif.fromJson(Map<String, dynamic> json) {
    notifId = json['notifId'];
    companyCode = json['companyCode'];
    configId = json['configId'];
    fromFunc = json['fromFunc'];
    isRead = json['isRead'];
    title = json['title'];
    body = json['body'];
    userId = json['userId'];
    status = json['status'];
    sentDatetime = json['sentDatetime'];
    channelCode = json['channelCode'];
  }
}

//List<Notif> _getTestData() {
//  var list = <Notif>[];
//  list.addAll([
//    Notif()
//      ..title = 'Тавтай морилно уу.'
//      ..body = 'Сайн байна уу. Б.Галмандах'
//      ..dateTime = DateTime.now(),
//    Notif()
//      ..title = 'Шинэ хэрэглэгч'
//      ..body = 'Зээл аваад бонус оноогоо цуглуулаарай...'
//      ..dateTime = DateTime.now(),
//  ]);
//}
