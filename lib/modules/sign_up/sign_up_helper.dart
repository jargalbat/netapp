import 'package:flutter/material.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/shared_pref_key.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';

class SignUpHelper {
  static bool isLoginRouteExists = true; //todo

  /// User key
  static String get userKey {
    if (globals.sharedPref.containsKey(SharedPrefKey.SignUpUserKey)) {
      return globals.sharedPref.getString(SharedPrefKey.SignUpUserKey);
    } else {
      return '';
    }
  }

  static set userKey(String val) {
    globals.sharedPref?.setString(SharedPrefKey.SignUpUserKey, val);
  }

  /// Step no - Давсан алхмуудыг хадгална
  static int get stepNo {
    if (globals.sharedPref.containsKey(SharedPrefKey.SignUpStepNo)) {
      return globals.sharedPref.getInt(SharedPrefKey.SignUpStepNo);
    } else {
      return 0;
    }
  }

  static set stepNo(int val) {
    globals.sharedPref?.setInt(SharedPrefKey.SignUpStepNo, val);
  }

  /// Clear
  static clear() {
    globals.sharedPref?.setString(SharedPrefKey.SignUpUserKey, '');
    globals.sharedPref?.setInt(SharedPrefKey.SignUpStepNo, 0);
  }

  static showErrorDlg({
    @required BuildContext context,
    String titleText,
    String bodyText,
    String btnText,
    Function onPressedBtn,
  }) {
    showDialog(
      context: context,
      builder: (_) => MainDialog(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        child: Container(
          height: 400.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),

              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: AppColors.bgBlue,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  height: 39.0,
                  margin: EdgeInsets.all(20.0),
                  child: Image.asset(AssetName.exclamation_mark, height: 39.0, color: AppColors.iconWhite),
                ),
              ),

              SizedBox(height: 30.0),

              lbl(titleText ?? '',
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                  color: AppColors.lblDark,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                  fontSize: 16.0),

              SizedBox(height: 30.0),

              /// Хөндлөн зураас
              Container(
                height: 0.5,
                color: AppColors.athensGray,
                margin: EdgeInsets.only(
                  top: 10.0,
                  right: 30.0,
                  bottom: 15.0,
                  left: 30.0,
                ),
              ),

              SizedBox(height: 30.0),

              lbl(bodyText ?? '',
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                  color: AppColors.lblDark,
                  fontWeight: FontWeight.normal,
                  maxLines: 3,
                  fontSize: 16.0),

              Expanded(
                child: Container(),
              ),

              CustomButton(
                width: double.infinity,
                text: btnText ?? '',
                context: context,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                color: AppColors.bgBlue,
                disabledColor: AppColors.btnBlue,
                textColor: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                onPressed: () {
                  onPressedBtn();
                },
              ),

              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
