import 'package:code_input/code_input.dart';
import 'package:flutter/material.dart';
import 'package:netware/app/themes/app_colors.dart';

Widget codeInput({
  @required BuildContext context,
  @required int inputLength,
  @required Function onFilled,
  Function onChanged,
  bool isDone = false,
  Color textColor,
}) {
  if (isDone) {
    FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard
  }

  return CodeInput(
    length: inputLength,
    keyboardType: TextInputType.number,
    builder: CodeInputBuilders.containerized(
      totalSize: Size(70.0, 60.0),
      emptySize: Size(50.0, 60.0),
      filledSize: Size(50.0, 60.0),
      emptyDecoration: new BoxDecoration(
        color: AppColors.athensGray,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      filledDecoration: new BoxDecoration(
        color: AppColors.athensGray,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      emptyTextStyle: null,
      filledTextStyle: TextStyle(color: textColor ?? AppColors.lblDark, fontWeight: FontWeight.w500, fontSize: 20.0),
    ),
    onFilled: (value) => onFilled(value),
    onChanged: (value) => onChanged(value),
  );
}

Widget codeInput2({
  @required BuildContext context,
  @required int inputLength,
  @required Function onFilled,
  Function onChanged,
  bool hasTanWritten = false,
  Color textColor,
}) {
  if (hasTanWritten) {
    FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard
  }

  return CodeInput(
    length: inputLength,
    keyboardType: TextInputType.number,
    builder: CodeInputBuilders.containerized(
      totalSize: Size(45.0, 30.0),
      emptySize: Size(35.0, 30.0),
      filledSize: Size(35.0, 30.0),
      emptyDecoration: new BoxDecoration(
        border: Border.all(
          color: AppColors.regentGray,
          width: 1,
        ),
        color: AppColors.bgGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      emptyTextStyle: null,
      filledDecoration: new BoxDecoration(
        border: Border.all(
          color: AppColors.regentGray,
          width: 1,
        ),
        color: AppColors.bgGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      filledTextStyle: TextStyle(color: textColor ?? AppColors.lblDark, fontWeight: FontWeight.w500, fontSize: 20.0),
    ),
    onFilled: (value) => onFilled(value),
    onChanged: (value) => onChanged(value),
  );
}
