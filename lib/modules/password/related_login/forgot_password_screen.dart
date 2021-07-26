import 'package:flutter/material.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/password/reset_password_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/api/models/password/reset_password_request.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';

/// Нэвтрэх > Нууц үг мартсан
class ForgotPasswordRoute extends StatefulWidget {
  @override
  _ForgotPasswordRouteState createState() => _ForgotPasswordRouteState();
}

class _ForgotPasswordRouteState extends State<ForgotPasswordRoute> {
  var _scaffoldKeyFP = GlobalKey<ScaffoldState>();
  double _paddingHorizontal = 20.0;
  double _maxHeight = 0.0;
  bool _isLoading = false;

  /// Mobile
  TextEditingController _controllerM = TextEditingController();
  bool _isMobileValid = false;

  @override
  void initState() {
    super.initState();

    _controllerM.addListener(() {
      if (_controllerM.text.length == 8) {
        setState(() {
          _isMobileValid = true;
        });
      } else {
        setState(() {
          _isMobileValid = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controllerM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlurLoadingContainer(
          loading: _isLoading,
          child: Scaffold(
            key: _scaffoldKeyFP,
            appBar: AppBarSimple(
              context: context,
              brightness: Brightness.light,
              backgroundColor: AppColors.bgGrey,
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: AppColors.bgGrey,
            body: LayoutBuilder(builder: (context, constraints) {
              if (_maxHeight < constraints.maxHeight) _maxHeight = constraints.maxHeight;
              if (_maxHeight < AppHelper.minHeightScreen) _maxHeight = AppHelper.minHeightScreen;

              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  height: _maxHeight,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            /// Нууц үг сэргээх
                            lbl(globals.text.forgotPassword(), style: lblStyle.Headline4, padding: EdgeInsets.only(left: _paddingHorizontal)),

                            SizedBox(height: 10.0),

                            /// Та өөрийн бүртгэлтэй утасны дугаар эсвэл мэйл хаягаа оруулна уу.
                            lbl(globals.text.msgInsertMobileEmail(), padding: EdgeInsets.symmetric(horizontal: _paddingHorizontal), maxLines: 10),

                            SizedBox(height: 10.0),

                            /// Утасны дугаар
                            _txtMobile(),
                          ],
                        ),
                      ),

                      Expanded(child: Container()),

                      /// Button - Нууц үг шинэчлэх
                      _btnResetPass(),

                      SizedBox(height: 40.0),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  _txtMobile() {
    return txt(
      labelText: globals.text.mobile(),
      context: context,
      margin: EdgeInsets.only(top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      controller: _controllerM,
      maxLength: 8,
      textInputType: TextInputType.number,
//      textColor: _isMobileValid ? AppColors.jungleGreen : AppColors.lblDark,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGrey,
    );
  }

  _btnResetPass() {
    return CustomButton(
      text: globals.text.contin(),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
      color: AppColors.btnBlue,
      disabledColor: AppColors.btnDisabled,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: _isMobileValid
          ? () {
              _getTanCodeRequest();
            }
          : null,
    );
  }

  _getTanCodeRequest() async {
    FocusScope.of(context).requestFocus(new FocusNode());

    // Validation
    if (_isLoading) return;

    if (!_isMobileValid) {
      showSnackBar(key: _scaffoldKeyFP, text: globals.text.invalidMobile());
      return;
    }

    setState(() => _isLoading = true);

    try {
      FocusScope.of(this.context).requestFocus(new FocusNode());

      ResetPasswordRequest request = new ResetPasswordRequest(mobileNo: _controllerM.text);
      ResetPasswordResponse response = await ApiManager.resetPassword(request);

      if (response.resultCode == 0) {
        _showSuccessDialog();
      } else {
        showSnackBar(key: _scaffoldKeyFP, text: response.resultDesc ?? globals.text.requestFailed());
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  _showSuccessDialog() {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () {
//          Navigator.pop(context);
          return Future.value(false);
        },
        child: ScaleDialog(
          margin: EdgeInsets.all(AppHelper.margin),
          padding: EdgeInsets.all(AppHelper.margin),
          child: Container(
            height: 400.0,
            width: MediaQuery.of(this.context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20.0),

                Image.asset(
                  AssetName.success_green,
                  height: 74.0,
                  colorBlendMode: BlendMode.modulate,
                ),

                SizedBox(height: 30.0),

                lbl(
                  globals.text.success().toUpperCase(),
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                  color: AppColors.jungleGreen,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                  fontSize: 16.0,
                ),

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

                lbl(
                  globals.text.goToLogin(),
                  margin: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  textAlign: TextAlign.end,
                  color: AppColors.lblDark,
                  fontWeight: FontWeight.normal,
                  maxLines: 3,
                  fontSize: 16.0,
                ),

                SizedBox(height: 10.0),

                Expanded(
                  child: Container(),
                ),

                /// BUTTONS
                CustomButton(
                  text: globals.text.loginScreen(),
                  context: this.context,
                  margin: EdgeInsets.only(left: 5.0),
                  color: AppColors.bgBlue,
                  disabledColor: AppColors.btnBlue,
                  textColor: AppColors.lblWhite,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  onPressed: () {
                    Navigator.pop(this.context); //dlg
                    Navigator.pop(this.context); //this
                  },
                ),

                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
