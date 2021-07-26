import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/combobox/combobox.dart';

class ProfileHelper {
  static List<String> getCyrillicList() {
    return <String>[
      'А',
      'Б',
      'В',
      'Г',
      'Д',
      'Е',
      'Ё',
      'Ж',
      'З',
      'И',
      'Й',
      'К',
      'Л',
      'М',
      'Н',
      'О',
      'Ө',
      'П',
      'Р',
      'С',
      'Т',
      'У',
      'Ү',
      'Ф',
      'Х',
      'Ц',
      'Ч',
      'Ш',
      'Щ',
      'Ъ',
      'Ы',
      'Ь',
      'Э',
      'Ю',
      'Я'
    ];
  }

  static String getRegNoNumbers(String regNo) {
    // Регистрийн дугаараас эхний 2 үсгийг хасаж, тоог буцаана
    // АБ99887766 => 99887766
    String regNoNumbers = '';
    if (Func.isNotEmpty(regNo) && regNo.length > 2) {
      regNoNumbers = regNo.substring(2);
    }

    return regNoNumbers;
  }

  static String getRegNoFirstChar(String regNo) {
    // Регистрийн дугаараас эхний тэмдэгтийг буцаана
    // АБ99887766 => А
    String firstChar = '';
    if (Func.isNotEmpty(regNo) && regNo.length > 2) {
      firstChar = regNo.substring(0, 1);
    }

    return firstChar;
  }

  static String getRegNoSecondChar(String regNo) {
    // Регистрийн дугаараас 2 дахь тэмдэгтийг буцаана
    // АБ99887766 => Б
    String secondChar = '';
    if (Func.isNotEmpty(regNo) && regNo.length > 2) {
      secondChar = regNo.substring(1, 2);
    }

    return secondChar;
  }

  static var genderComboItemList = <ComboItem>[
    ComboItem()
      ..txt = globals.text.male()
      ..val = 'M',
    ComboItem()
      ..txt = globals.text.female()
      ..val = 'F',
  ];
}
