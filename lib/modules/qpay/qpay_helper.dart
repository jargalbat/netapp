import 'package:netware/app/assets/image_asset.dart';

class QPayHelper {
  static List<FintechApp> fintechAppList = [
    FintechApp(id: 'KHAN', name: 'Хаан банк', deepLink: "khanbank://", imageAssetName: AssetName.khanbank_logo),
    FintechApp(id: 'TDB', name: 'ХХБ', deepLink: "tdbbank://", imageAssetName: AssetName.tdbank_logo),
    FintechApp(id: 'SB', name: 'Төрийн банк', deepLink: "statebank://", imageAssetName: AssetName.statebank_logo),
    FintechApp(id: 'MM', name: 'Most Money', deepLink: "most://", imageAssetName: AssetName.mostmoney_logo),
    FintechApp(id: 'XAC', name: 'Хас банк', deepLink: "xacbank://", imageAssetName: AssetName.xacbank_logo),
    FintechApp(id: 'NIB', name: 'ҮХОБ', deepLink: "nibank://", imageAssetName: AssetName.nibank_logo),
    FintechApp(id: 'CKB', name: 'Чингис хаан банк', deepLink: "ckbank://", imageAssetName: AssetName.ckbank_logo),
  ];
}

class FintechApp {
  FintechApp({this.id, this.name, this.deepLink, this.imageAssetName});

  final String id;
  final String name;
  final String deepLink;
  final String imageAssetName;
}
