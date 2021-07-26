import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/modules/login/login_route.dart';
import 'package:netware/modules/sign_up/api/sign_up_repository.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/code_input.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';

import '../sign_up_helper.dart';
import 'api/verify_tan_request.dart';
import 'api/verify_tan_response.dart';

class VerifyTanScreen extends StatefulWidget {
  final String userKey;

  VerifyTanScreen({this.userKey});

  @override
  _VerifyTanScreenState createState() => _VerifyTanScreenState();
}

class _VerifyTanScreenState extends State<VerifyTanScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Localization _loc;
  double _paddingHorizontal = 20.0;
  double _maxHeight = 0.0;

  bool _isInit = true;
  bool _isValidTan = false;
  String _tanCode = '';
  bool _hasTanWritten = false;
  String _hint = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loc = globals.text;
    _initParams();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard
        },
        child: BlurLoadingContainer(
          loading: _isLoading,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.bgGrey,
            appBar: AppBarSimple(
              context: context,
              brightness: Brightness.light,
              onPressed: () {
                Navigator.pop(context);
              },
              hasBackArrow: true,
              actions: [
                Container(
                  child: Container(),
//                btnLang(context: context, color: AppColors.lblDark),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (_maxHeight < constraints.maxHeight) _maxHeight = constraints.maxHeight;
                if (_maxHeight < AppHelper.minHeightScreen) _maxHeight = AppHelper.minHeightScreen;

                return SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
//                height: double.infinity,
                    height: _maxHeight,
//              padding: EdgeInsets.only(top: 20.0, right: 0.0, bottom: 0.0, left: 0.0),
                    child: Column(
                      children: <Widget>[
                        /// Бүртгүүлэх
                        _title(),

                        SizedBox(height: 10.0),

                        /// 5/5 Тан код оруулах
                        _stepNumber(),

                        SizedBox(height: 10.0),

                        Expanded(
                          child: Center(
                            child: _tanCodeWidget(),
                          ),
                        ),

                        SizedBox(height: 10.0),

                        /// Дуусгах
                        _btnFinish(),

                        SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _initParams() {
    if (_isInit) {
      _hint = globals.text.enterTanCodeMobile();
      _isInit = false;
    }
  }

  _title() {
    return lbl(
      _loc.signUp(),
      style: lblStyle.Headline4,
      padding: EdgeInsets.only(right: _paddingHorizontal, left: _paddingHorizontal),
      color: AppColors.lblBlue,
      fontWeight: FontWeight.w800,
    );
  }

  _stepNumber() {
    return Container(
      padding: EdgeInsets.only(
        right: _paddingHorizontal,
        left: 30.0,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40.0,
            child: Image.asset(
              AssetName.circle_step5,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                lbl(
                  globals.text.enterTanCode().toUpperCase(),
                  style: lblStyle.Medium,
                  color: AppColors.lblBlue,
                ),
                lbl(
                  '${globals.text.nextt()}: ${globals.text.login().toUpperCase()}',
                  fontSize: 12.0,
                  color: AppColors.lblGrey,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _tanCodeWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// Утсанд ирсэн тан кодыг оруулна уу.
        lbl(
          _hint,
          fontSize: 16.0,
          alignment: Alignment.center,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.normal,
          color: AppColors.lblDark,
          maxLines: 3,
        ),

        SizedBox(height: 30.0),

        codeInput2(
          hasTanWritten: _hasTanWritten,
          inputLength: 4,
          onFilled: (value) {
            setState(() {
              _tanCode = value;
              if ((_tanCode ?? '').length == 4) {
                _isValidTan = true;
              } else {
                _isValidTan = false;
              }
            });
          },
          onChanged: (value) {
            setState(() {
              _tanCode = value;
              if ((_tanCode ?? '').length == 4) {
                _isValidTan = true;
              } else {
                _isValidTan = false;
              }
            });
          },
          textColor: _isValidTan ? AppColors.lblDark : AppColors.lblDark,
          context: context,
        ),
      ],
    );
  }

  _btnFinish() {
    return CustomButton(
      text: globals.text.finish(),
      //_loc.verify(),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnGreyDisabled,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: _isValidTan
          ? () {
              _onPressedBtnVerify();
            }
          : null,
    );
  }

  _onPressedBtnVerify() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard
//    FocusScope.of(context).unfocus();

//    _showSuccessDialog();
//
//    return;

    SignUpRepository repository = new SignUpRepository();
    VerifyTanRequest request = new VerifyTanRequest(
      userKey: widget.userKey,
      tanNo: _tanCode,
      deviceCode: globals.deviceCode,
      deviceName: globals.deviceName,
      pushNotifToken: globals.pushNotifToken,
    );
    VerifyTanResponse response = await repository.stepVerifyTan(request);

    setState(() {
      _isLoading = false;
    });

    if (response.resultCode == 0) {
      SignUpHelper.clear();
      _showSuccessDialog();
    } else {
//      _hint = Func.isEmpty(response.resultDesc) ? 'Баталгаажуулах код буруу байна.' : response.resultDesc;
      _showErrorDialog(Func.isEmpty(response.resultDesc) ? globals.text.invalidTanCode() : response.resultDesc);
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
                  globals.text.msgSentPass(),
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
                  text: globals.text.login(),
                  context: this.context,
                  margin: EdgeInsets.only(left: 5.0),
                  color: AppColors.bgBlue,
                  disabledColor: AppColors.btnBlue,
                  textColor: AppColors.lblWhite,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  onPressed: () {
                    if (SignUpHelper.isLoginRouteExists) {
                      /// Login-оос дамжиж орж ирсэн
                      Navigator.pop(this.context); //dlg
                      Navigator.pop(this.context); //this
                      Navigator.pop(this.context); //SignUpMobileScreen

//                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else {
                      /// TermCondRoute-ээс дамжиж орж ирсэн
                      SignUpHelper.isLoginRouteExists = true;
                      Navigator.pop(this.context); //dlg
                      Navigator.pushReplacement(context, FadeRouteBuilder(route: LoginRoute()));
                    }
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

  _showErrorDialog(String text) {
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
                  AssetName.warning_blue,
                  height: 74.0,
                  colorBlendMode: BlendMode.modulate,
                ),

                SizedBox(height: 30.0),

                lbl(
                  globals.text.requestFailed().toUpperCase(),
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                  color: AppColors.lblDark,
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
                  Func.toStr(text),
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
                  text: 'OK',
                  context: this.context,
                  margin: EdgeInsets.only(left: 5.0),
                  color: AppColors.bgBlue,
                  disabledColor: AppColors.btnBlue,
                  textColor: AppColors.lblWhite,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  onPressed: () {
                    Navigator.pop(this.context); //dlg
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
