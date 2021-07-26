import 'package:intl/intl.dart';

class Func {
  static bool isEmpty(Object o) => o == null || o == '';

  static bool isNotEmpty(Object o) => o != null && o != '';

  static String toStr(Object o) => isEmpty(o) ? "" : o.toString();

  static String toMoneyStr(
    Object value, {
    bool secureMode, //Secure mode ашиглах эсэх
    NumberFormat numberFormat,
  }) {
    /// Format number with "Decimal Point" digit grouping.
    /// 10000 -> 10,000.00

    //Хоосон утгатай эсэх
    if (Func.toStr(value) == "") {
      return "0.00";
    }

    //Зөвхөн тоо агуулсан эсэх
    String tmpStr = Func.toStr(value).replaceAll(",", "").replaceAll(".", "");
    if (!isNumeric(tmpStr)) {
      return "0.00";
    }

    //Хэрэв ',' тэмдэгт агуулсан бол устгана
    double tmpDouble = double.parse(Func.toStr(value).replaceAll(",", ""));

    String result = "";
    try {
      //Format number
      NumberFormat formatter = numberFormat ?? NumberFormat("#,###.##");
      result = formatter.format(tmpDouble);
    } catch (e) {
      print(e);
      result = "0.00";
    }

    return result;
  }

  static String toStrFixed(double value, {int fractionDigits = 2}) {
    /// Format number with "Decimal Point" digit grouping. 1.567 -> 1.56
    if (value == null) return '0.00';
    return value.toStringAsFixed(fractionDigits);
  }

  static bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  static String toCurSymbol(String curCode) {
    String currencySymbol;

    switch (Func.toStr(curCode)) {
      case "MNT":
        currencySymbol = "₮";
        break;

      case "EUR":
        currencySymbol = "€";
        break;

      case "USD":
        currencySymbol = "\$";
        break;

      default:
        currencySymbol = "";
        break;
    }

    return currencySymbol;
  }

  static String toDateTimeStr(String str) {
    // Datetime string-ийг форматлаад буцаана '2019.01.01T15:13:00.000' to '2019.01.01 15:13:00'
    if (isEmpty(str)) return '';

    DateTime dateTime = DateTime.parse(str);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return formattedDate; //trim(str.split(" ")[0]);
  }

  static String toDateStr(String str) {
    // Datetime string-ийг форматлаад буцаана '2019.01.01T15:13:00.000' to '2019.01.01 15:13:00'
    if (isEmpty(str)) return '';

    DateTime dateTime = DateTime.parse(str);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate; //trim(str.split(" ")[0]);
  }

  static String addDaysOnDateStr(String dateStr, int dayCount) {
    // DateTime string дээр хоног нэмж, string утга буцаана
    if (isEmpty(dateStr)) return '';
    String formattedDate = '';

    try {
      DateTime dateTime = DateTime.parse(dateStr.replaceAll(".", "-"));
      dateTime = dateTime.add(Duration(days: dayCount));
      formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      print(e);
    }

    return formattedDate;
  }

  static bool validEmail(String value) {
    try {
      if (Func.isEmpty(value)) return false;
      return RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value);
    } catch (e) {
      print(e);
    }
    return false;
  }

  static double toDouble(String strDouble,
      {String thousandSeparator = ",",
      String rightSymbol = "",
      String leftSymbol = ""}) {
    double val = 0;

    strDouble = (strDouble == null || strDouble.isEmpty) ? '0' : strDouble;

    strDouble = strDouble
        .replaceAll(thousandSeparator, '')
        .replaceAll(rightSymbol, '')
        .replaceAll(leftSymbol, '');

    try {
      val = double.parse(strDouble);
    } catch (_) {
      val = 0;
    }
    return val;
  }

  static int toInt(String str) {
    int val = 0;

    str = isEmpty(str) ? '0' : str;

    str = str.replaceAll(',', '');

    try {
      val = int.parse(str);
    } catch (_) {
      val = 0;
    }
    return val;
  }
}
