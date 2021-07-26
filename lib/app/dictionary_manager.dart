import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/dictionary/dictionary_request.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/combobox/combobox.dart';

class DictionaryManager {
  static Future<List<DictionaryData>> getDictionaryData(String dictionaryCode) async {
    var list = <DictionaryData>[];
    try {
      var request = DictionaryRequest(dictionaryCode: dictionaryCode);

      var dictionaryResponse = await ApiManager.getDictionaryData(request);
      if (dictionaryResponse.resultCode == 0) {
        list = dictionaryResponse.dictionaryList;
      }
    } catch (e) {
      print(e);
    }

    return list;
  }

  /// Банкны asset name авах
  static String getAssetNameByCode(String code) {
    String assetName;
    switch (code) {
      case BankCode.KHAN:
        assetName = AssetName.khanbank_logo;
        break;

      case BankCode.SB:
        assetName = AssetName.statebank_logo;
        break;

      case BankCode.CHKB:
        assetName = AssetName.ckbank_logo;
        break;

      case BankCode.NIB:
        assetName = AssetName.nibank_logo;
        break;

      case BankCode.TDB:
        assetName = AssetName.tdbank_logo;
        break;

      case BankCode.XAC:
        assetName = AssetName.xacbank_logo;
        break;

      case AppCode.MOST_MONEY:
        assetName = AssetName.mostmoney_logo;
        break;

      case BankCode.GLMT:
        assetName = AssetName.golomt_logo;
        break;

      case BankCode.BOGD:
        assetName = AssetName.bogdbank_logo;
        break;
      case BankCode.CAPT:
        assetName = AssetName.capitronbank_logo;
        break;
      case BankCode.CRED:
        assetName = AssetName.creditbank_logo;
        break;
      case BankCode.ARIG:
        assetName = AssetName.arigbank_logo;
        break;

      case BankCode.TRANS:
        assetName = AssetName.transbank_logo;
        break;

      default:
        assetName = AssetName.defaultbank_logo;
        break;
    }

    return assetName;
  }

  static List<ComboItem> getComboItemList(List<DictionaryData> list) {
    var comboItemList = <ComboItem>[];

    try {
      for (var el in list) {
        comboItemList.add(ComboItem()
          ..txt = el.txt
          ..val = el);
      }
    } catch (e) {
      print(e);
    }

    return comboItemList;
  }
}

class DictionaryCode {
  static const bankList = 'MW0012'; // Банкны жагсаалт
  static const martial = 'CUSTOMER005'; // Гэрлэлтийн байдал
  static const relative = 'CUSTOMER006'; // Таны хэн болох
  static const edu = 'CUSTOMER007'; // Боловсрол
  static const homeType = 'CUSTOMER008'; // Орон сууцны төрөл
  static const homeOwnership = 'CUSTOMER009'; // Хаягийн эзэмшлийн байдал
  static const employmentType = 'CUSTOMER011'; // Ажлын газар
  static const workPosition = 'CUSTOMER010'; // Албан тушаал
}

class BankCode {
  static const KHAN = 'KHAN';
  static const TDB = 'TDB';
  static const GLMT = 'GLMT';
  static const SB = 'SB';
  static const TRANS = 'TRANS';
  static const ARIG = 'ARIG';
  static const CRED = 'CRED';
  static const CAPT = 'CAPT';
  static const NIB = 'NIB';
  static const XAC = 'XAC';
  static const CHKB = 'CHKB';
  static const BOGD = 'BOGD';
}

class AppCode {
  static const MOST_MONEY = 'MOST_MONEY';
}
