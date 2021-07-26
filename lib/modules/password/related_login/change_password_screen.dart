import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/password/change_password_request.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/app_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/api/models/password/change_password_response.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/login/bloc/login_bloc.dart';
import 'package:netware/modules/password/password_helper.dart';

/// Login > Нууц үг солих
class ChangePasswordRoute extends StatefulWidget {
  final String loginName;
  final String hintText;

//  final LoginBloc loginBloc(),

  ChangePasswordRoute({@required this.loginName, this.hintText});

  @override
  _ChangePasswordRouteState createState() => _ChangePasswordRouteState();
}

class _ChangePasswordRouteState extends State<ChangePasswordRoute> with TickerProviderStateMixin {
  var _scaffoldKeyCP = GlobalKey<ScaffoldState>();
  Localization _loc;
  double _paddingHorizontal = 20.0;
  double _maxHeight = 0.0;
  bool _isLoading = false;

  /// Current password
  TextEditingController _controllerCurrentPass = TextEditingController();
  FocusNode _focusNodeCurrentPass;
  bool _isCurrentPassValid = false;
  bool _obscureCurrentPass = true;

  /// New password
  final TextEditingController _controllerNewPass = TextEditingController();
  FocusNode _focusNodeNewPass;
  bool _isNewPassValid = false;
  bool _obscureNewPass = true;

  /// Repeat new password
  final TextEditingController _controllerRepeatNewPass = TextEditingController();
  FocusNode _focusNodeRepeatNewPass;
  bool _isRepeatNewPassValid = false;
  bool _obscureRepeatNewPass = true;

  @override
  void initState() {
    super.initState();

    _controllerCurrentPass.addListener(() {
      if (_controllerCurrentPass.text.length >= PasswordHelper.minPasswordLength) {
        setState(() {
          _isCurrentPassValid = true;
        });
      } else {
        setState(() {
          _isCurrentPassValid = false;
        });
      }
    });

    _controllerNewPass.addListener(() {
      if (_controllerNewPass.text.length >= PasswordHelper.minPasswordLength) {
        setState(() {
          _isNewPassValid = true;
        });
      } else {
        setState(() {
          _isNewPassValid = false;
        });
      }
    });

    _controllerRepeatNewPass.addListener(() {
      if (_controllerRepeatNewPass.text.length >= PasswordHelper.minPasswordLength) {
        setState(() {
          _isRepeatNewPassValid = true;
        });
      } else {
        setState(() {
          _isRepeatNewPassValid = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loc = globals.text;

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed(context);
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlurLoadingContainer(
          loading: _isLoading,
          child: Scaffold(
            key: _scaffoldKeyCP,
            backgroundColor: AppColors.bgGrey,
            appBar: AppBarSimple(
              context: context,
              brightness: Brightness.light,
              onPressed: () {
                _onBackPressed(context);
              },
              hasBackArrow: true,
              actions: [
//              btnLang(context: context, color: AppColors.lblDark),
                Container(
                  padding: EdgeInsets.all(0.0),
                  alignment: Alignment.topRight,
                  child: TextButton(
                    text: globals.locale.languageCode == "mn" ? 'EN' : 'MN',
                    onPressed: () {
//        BlocProvider.of<AppBloc>(context)..add(ChangeLang(locale: newLocale(globals.langCode)));

//        const String MN = "mn";
//        const String EN = "en";

                      if (globals.locale.languageCode == "mn") {
                        BlocProvider.of<AppBloc>(context)..add(ChangeLangEN(locale: Locale("en")));
                      } else {
                        BlocProvider.of<AppBloc>(context)..add(ChangeLangMN(locale: Locale("mn")));
                      }
                    },
                    padding: EdgeInsets.only(top: 20.0, right: 20.0, bottom: 15.0, left: 20.0),
                    textColor: AppColors.lblDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    enabledRippleEffect: false,
                  ),
                ),
              ],
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              if (_maxHeight < constraints.maxHeight) _maxHeight = constraints.maxHeight;
              if (_maxHeight < AppHelper.minHeightScreen) _maxHeight = AppHelper.minHeightScreen;

              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  height: _maxHeight,
                  child: Column(
                    children: <Widget>[
                      /// Нууц үг солих
                      _title(),

                      SizedBox(height: 10.0),

                      /// Нууц үгээ үүсгэнэ үү. Таны нууц үг 4 оронтой тооноос бүрдэнэ.
                      _hint(),

                      /// Хуучин нууц үг
                      _txtCurrentPassword(),

                      /// Шинэ нууц үг
                      _txtNewPassword(),

                      /// Шинэ нууц үг давтах
                      _txtRepeatNewPassword(),

                      Expanded(
                        child: Container(),
                      ),

                      SizedBox(height: 30.0),

                      /// Хадгалах
                      _btnSave(),

                      SizedBox(height: 30.0),
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

  _title() {
    return lbl(
      globals.text.changePassword(),
      style: lblStyle.Headline4,
      padding: EdgeInsets.only(right: _paddingHorizontal, left: _paddingHorizontal),
      color: AppColors.lblBlue,
      fontWeight: FontWeight.w800,
    );
  }

  _hint() {
    return !Func.isEmpty(widget.hintText)
        ? lbl(
            widget.hintText ?? '',
            margin: EdgeInsets.only(top: 0.0, right: 20.0, bottom: 0.0, left: 20.0),
            alignment: Alignment.centerLeft,
            textAlign: TextAlign.left,
            fontSize: 16.0,
            maxLines: 3,
          )
        : Container();
  }

  _txtCurrentPassword() {
    return txt(
      context: this.context,
      margin: EdgeInsets.only(top: 23.0, right: _paddingHorizontal, left: _paddingHorizontal),
      labelText: globals.text.currentPass(),
      controller: _controllerCurrentPass,
//      hintText: _loc.password(),
      obscureText: _obscureCurrentPass,
      textInputType: TextInputType.text,
      maxLength: PasswordHelper.maxPasswordLength,
//      textColor: _obscureCurrentPass ? AppColors.scienceBlue : AppColors.lblDark,
      textColor: _isCurrentPassValid ? AppColors.jungleGreen : AppColors.lblBlue,
      bgColor: AppColors.txtBgGrey,
//      suffixIcon: IconButton(
//        splashColor: Colors.transparent,
//        highlightColor: Colors.transparent,
//        icon: Image.asset(
//          _obscureCurrentPass ? Img.eye_false : Img.eye_true,
//          height: 20.0,
//          colorBlendMode: BlendMode.modulate,
//        ),
//        onPressed: () async {
//          setState(() {
//            _obscureCurrentPass = !_obscureCurrentPass;
//          });
//        },
//      ),
    );
  }

  _txtNewPassword() {
    return txt(
      context: this.context,
      margin: EdgeInsets.only(top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      labelText: globals.text.newPass(),
      controller: _controllerNewPass,
//      hintText: _loc.password(),
      obscureText: _obscureNewPass,
      textInputType: TextInputType.text,
      maxLength: PasswordHelper.maxPasswordLength,
//      textColor: _obscureNewPass ? AppColors.scienceBlue : AppColors.lblDark,
      textColor: _isNewPassValid ? AppColors.jungleGreen : AppColors.lblBlue,
      bgColor: AppColors.txtBgGrey,
//      suffixIcon: IconButton(
//        splashColor: Colors.transparent,
//        highlightColor: Colors.transparent,
//        icon: Image.asset(
//          _obscureNewPass ? Img.eye_false : Img.eye_true,
//          height: 20.0,
//          colorBlendMode: BlendMode.modulate,
//        ),
//        onPressed: () {
//          setState(() {
//            _obscureNewPass = !_obscureNewPass;
//          });
//        },
//      ),
    );
  }

  _txtRepeatNewPassword() {
    return txt(
      context: this.context,
      margin: EdgeInsets.only(top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      labelText: globals.text.newPassRepeat(),
      controller: _controllerRepeatNewPass,
//      hintText: _loc.password(),
      obscureText: _obscureRepeatNewPass,
      textInputType: TextInputType.text,
      maxLength: PasswordHelper.maxPasswordLength,
//      textColor: _obscureRepeatNewPass ? AppColors.scienceBlue : AppColors.lblDark,
      textColor: _isRepeatNewPassValid ? AppColors.jungleGreen : AppColors.lblBlue,
      bgColor: AppColors.txtBgGrey,
//      suffixIcon: IconButton(
//        splashColor: Colors.transparent,
//        highlightColor: Colors.transparent,
//        icon: Image.asset(
//          _obscureRepeatNewPass ? Img.eye_false : Img.eye_true,
//          height: 20.0,
//          colorBlendMode: BlendMode.modulate,
//        ),
//        onPressed: () {
////          setState(() {
////            _obscureTextPasswordRepeat = !_obscureTextPasswordRepeat;
////          });
//        },
//      ),
    );
  }

  _btnSave() {
    return CustomButton(
      text: Func.toStr(_loc.save()),
      context: this.context,
      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: () {
        if (_isValidated()) _changePassword();
      },
    );
  }

  bool _isValidated() {
    bool isValidated = true;
    String message = '';

    try {
      if (!_isCurrentPassValid) {
        if (globals.langCode == LangCode.mn) {
          message = '${globals.text.currentPass()} ${PasswordHelper.minPasswordLength}-${PasswordHelper.maxPasswordLength} тэмдэгт байх ёстой.';
        } else {
          message = '${globals.text.currentPass()} must contains ${PasswordHelper.minPasswordLength}-${PasswordHelper.maxPasswordLength} characters.';
        }

        isValidated = false;
      } else if (!_isNewPassValid) {
        if (globals.langCode == LangCode.mn) {
          message = '${globals.text.newPass()} ${PasswordHelper.minPasswordLength}-${PasswordHelper.maxPasswordLength} тэмдэгт байх ёстой.';
        } else {
          message = '${globals.text.newPass()} must contains ${PasswordHelper.minPasswordLength}-${PasswordHelper.maxPasswordLength} characters.';
        }

        isValidated = false;
      } else if (!_isRepeatNewPassValid) {
        if (globals.langCode == LangCode.mn) {
          message = '${globals.text.newPassRepeat()} ${PasswordHelper.minPasswordLength}-${PasswordHelper.maxPasswordLength} тэмдэгт байх ёстой.';
        } else {
          message = '${globals.text.newPassRepeat()} must contains ${PasswordHelper.minPasswordLength}-${PasswordHelper.maxPasswordLength} characters.';
        }

        isValidated = false;
      } else if (_controllerNewPass.text != _controllerRepeatNewPass.text) {
        message = globals.text.incorrectNewPassRepeat();
        isValidated = false;
      }
    } catch (e) {
      message = globals.text.errorOccurred();
      isValidated = false;
    }

    if (!isValidated) showSnackBar(key: _scaffoldKeyCP, text: message);

    return isValidated;
  }

  _changePassword() async {
    try {
      // Validation
      if (_isLoading) return;
      setState(() => _isLoading = true);

      FocusScope.of(this.context).requestFocus(new FocusNode());

      ChangePasswordRequest request = new ChangePasswordRequest(
        loginName: widget.loginName,
        oldPass: _controllerCurrentPass.text,
        password: _controllerNewPass.text,
        passwordConfirm: _controllerRepeatNewPass.text,
      );

      ChangePasswordResponse response = await ApiManager.changePassword(request);

      _showResponseDialog(response.resultCode == 0, response.resultDesc);

//      _controllerCurrentPass.clear();
//      _controllerNewPass.clear();
//      _controllerRepeatNewPass.clear();
    } catch (e) {
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  _showResponseDialog(bool isSuccess, String msg) {
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
                SizedBox(height: 25.0),

                Image.asset(
                  isSuccess ? AssetName.success_blue : AssetName.warning_blue,
                  height: 74.0,
                  colorBlendMode: BlendMode.modulate,
                ),

                SizedBox(height: 27.0),

                lbl(
                  isSuccess ? globals.text.success().toUpperCase() : globals.text.requestFailed(),
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
                    bottom: 13.0,
                    left: 30.0,
                  ),
                ),

                lbl(
                  Func.isEmpty(msg) ? (isSuccess ? globals.text.successChangePass() : globals.text.requestFailed()) : msg,
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
                  text: isSuccess ? globals.text.finish() : globals.text.close(),
                  context: this.context,
                  margin: EdgeInsets.only(left: 5.0),
                  color: AppColors.bgBlue,
                  disabledColor: AppColors.btnBlue,
                  textColor: AppColors.lblWhite,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  onPressed: () {
                    Navigator.pop(this.context); //dlg
                    if (isSuccess) {
                      // todo go to Dashboard
                      Navigator.pop(this.context);
                    } //this
                  },
                ),

                SizedBox(height: 25.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
