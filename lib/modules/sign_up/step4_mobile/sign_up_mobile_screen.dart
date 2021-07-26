import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/widgets/language_widget.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/widgets/animated_widget.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/modules/sign_up/api/sign_up_repository.dart';
import 'package:netware/modules/sign_up/step3_id_selfie/id_selfie_screen.dart';
import 'package:netware/modules/sign_up/step5_tan/sign_up_verify_tan_screen.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animated_widget.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';

import '../sign_up_helper.dart';
import 'api/send_tan_request.dart';
import 'api/send_tan_response.dart';

class SignUpMobileScreen extends StatefulWidget {
  SignUpMobileScreen();

  @override
  _SignUpMobileScreenState createState() => _SignUpMobileScreenState();
}

class _SignUpMobileScreenState extends State<SignUpMobileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Localization _loc;
  double _paddingHorizontal = 20.0;
  double _maxHeight = 0.0;

  /// Mobile
  bool _isMobileValid = false;
  TextEditingController _controllerMobile = TextEditingController();

  /// Response description
  int _resultCode;
  String _resultDesc;

  /// Button verify
  /// Button resend
  bool _isVisibleVerify = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controllerMobile.addListener(() {
      if (_controllerMobile.text.length == 8) {
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
  Widget build(BuildContext context) {
    _loc = globals.text;

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed(context);
        return Future.value(false);
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
              _onBackPressed(context);
            },
            hasBackArrow: true,
            actions: [
              Container(
                child: Container(),
//                btnLang(context: context, color: AppColors.lblDark),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: LayoutBuilder(builder: (context, constraints) {
              if (_maxHeight < constraints.maxHeight) _maxHeight = constraints.maxHeight;
              if (_maxHeight < AppHelper.minHeightScreen) _maxHeight = AppHelper.minHeightScreen;
//
              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
//                height: double.infinity,
                  height: _maxHeight,
//                padding: EdgeInsets.only(top: 20.0, right: 0.0, bottom: 0.0, left: 0.0),
                  child: Column(
                    children: <Widget>[
                      /// Бүртгүүлэх
                      _title(),

                      SizedBox(height: 10.0),

                      /// 4/5 Утасны дугаар оруулах
                      _stepNumber(),

                      /// Утасны дугаар
                      _txtMobile(),

                      Expanded(child: Func.isEmpty(_resultDesc) ? Container() : _responseMsg()),

                      /// Button get tan code
                      _isVisibleVerify ? Container() : _btnGetTanCode(),

                      /// Баталгаажуулах
                      _isVisibleVerify ? _btnVerify() : Container(),
                      _isVisibleVerify ? SizedBox(height: 30.0) : Container(),

                      /// Дахин илгээх
                      _isVisibleVerify ? _btnSendAgain() : Container(),

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
              AssetName.circle_step4,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                lbl(
                  globals.text.enterPhoneNumber().toUpperCase(),
                  style: lblStyle.Medium,
                  color: AppColors.lblBlue,
                ),
                lbl(
                  '${globals.text.nextt()}: ${globals.text.enterTanCode().toUpperCase()}',
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

  _title() {
    return lbl(
      _loc.signUp(),
      padding: EdgeInsets.only(right: _paddingHorizontal, left: _paddingHorizontal),
      style: lblStyle.Headline4,
      color: AppColors.lblBlue,
      fontWeight: FontWeight.w800,
    );
  }

  _txtMobile() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      labelText: _loc.mobile(),
      controller: _controllerMobile,
      maxLength: 8,
      textInputType: TextInputType.number,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGrey,
    );
  }

  _responseMsg() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20.0),
        ScaleWidget(
          child: Image.asset(
            _resultCode == 0 ? AssetName.success_blue : AssetName.warning_blue,
            height: 83.0,
            colorBlendMode: BlendMode.modulate,
          ),
        ),
        SizedBox(height: 30.0),
        lbl(
          _resultDesc,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          maxLines: 3,
          fontSize: 16.0,
          alignment: Alignment.center,
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  _btnVerify() {
    return CustomButton(
      text: _loc.verify(),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnGreyDisabled,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: () {
        if (_resultCode == 0) {
          Navigator.push(this.context, FadeRouteBuilder(route: VerifyTanScreen(userKey: SignUpHelper.userKey)));
        } else {
          setState(() {
            _isVisibleVerify = false;
            _resultDesc = globals.text.tanCodeHint();
          });
        }
      },
    );
  }

  _btnGetTanCode() {
    return CustomButton(
      text: globals.text.getPassword(),
      //_loc.getTanCode(),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnGreyDisabled,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: _isMobileValid
          ? () {
              _getTanCode();
            }
          : null,
    );
  }

  _btnSendAgain() {
    return TextButton(
      text: Func.toStr(_loc.sendAgain()),
      onPressed: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _getTanCode();
      },
      textColor: AppColors.lblBlue,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      enabledRippleEffect: false,
      alignment: Alignment.center,
    );
  }

  _getTanCode() async {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (_isMobileValid) {
      setState(() {
        _resultDesc = '';
        _isLoading = true;
      });

      SignUpRepository repository = new SignUpRepository();
      SendTanRequest request = new SendTanRequest(userKey: SignUpHelper.userKey, mobileNo: _controllerMobile.text);
      SendTanResponse response = await repository.stepSendTan(request);

      setState(() {
        _isLoading = false;
      });

      if (response.resultCode == 0) {
        setState(() {
          _isVisibleVerify = true;
          _resultCode = response.resultCode;
          _resultDesc = Func.isEmpty(response.resultDesc) ? globals.text.msgSentTan() : response.resultDesc;
        });
      } else {
        setState(() {
          _isVisibleVerify = false;
          _resultCode = response.resultCode;
          _resultDesc = Func.isEmpty(response.resultDesc) ? globals.text.requestFailed() : response.resultDesc;
        });
      }
    } else {
      setState(() {
        _resultCode = null;
        _resultDesc = globals.text.enterValidMobile();
      });
    }
  }

  _onBackPressed(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(this.context, FadeRouteBuilder(route: IdSelfieScreen()));
  }
}
