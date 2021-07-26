import 'package:flutter/material.dart';
import 'package:netware/app/themes/app_colors.dart';

void showSnackBar({@required GlobalKey<ScaffoldState> key, @required String text, Duration duration}) {
  key.currentState
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: duration ?? Duration(milliseconds: 4000),
        content: SafeArea(
          child: Text(
            text,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.lblDark,
              fontSize: 13.0,
            ),
          ),
        ),
        backgroundColor: AppColors.bgWhite,
      ),
    );
}

void showGenericSnackBarByKey(GlobalKey<ScaffoldState> key, String text, {bool isError = false, bool isSuccess: false}) {
  key.currentState
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar(key.currentState.context, text, isError));
}

SnackBar snackBar(BuildContext context, String text, bool isError) => SnackBar(
      content: SafeArea(
        child: Text(
          text,
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.lblDark,
            fontSize: 13.0,
          ),
        ),
      ),
      backgroundColor: AppColors.bgWhite,
    );
