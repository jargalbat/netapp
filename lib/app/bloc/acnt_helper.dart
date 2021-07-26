import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';

class AcntHelper {
  static getStatusName(String status) {
    switch (status) {
      case AcntStatus.Active:
        return (globals.langCode == LangCode.mn) ? 'Идэвхтэй' : 'Active';
        break;
      case AcntStatus.Active:
        return (globals.langCode == LangCode.mn) ? 'Шинэ' : 'New';
        break;
      case AcntStatus.Active:
        return (globals.langCode == LangCode.mn) ? 'Хаагдсан' : 'Closed';
        break;
      default:
        return '';
        break;
    }
  }

  static getClassName(int value) {
    if (value == AcntClass.Expired) {
      return (globals.langCode == LangCode.mn) ? 'Хугацаа хэтэрсэн' : 'Expired';
    } else {
      return (globals.langCode == LangCode.mn) ? 'Хэвийн' : 'Normal';
    }
  }
}

class AcntStatus {
  static const Active = "O";
  static const Closed = "C";
  static const New = "N";
}

class AcntClass {
  static const Normal = 0;
  static const Expired = 1;
}
