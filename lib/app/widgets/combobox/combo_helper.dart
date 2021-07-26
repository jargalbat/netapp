import 'package:netware/api/models/dictionary/dictionary_response.dart';

class ComboItem {
  String imageAssetName; // Icon asset name
  String txt;
  dynamic val;
}

class ComboHelper {
  static String getComboTextByValue(List<ComboItem> list, String value) {
    String text = '';

    for (var el in list) {
      if (el.val is DictionaryData) {
        /// Dictionary
        if ((el.val as DictionaryData).val == value) {
          text = (el.val as DictionaryData).txt;
          break;
        }
      } else if (el.val == value) {
        /// String
        text = el.txt;
        break;
      }
    }

    return text;
  }
}
