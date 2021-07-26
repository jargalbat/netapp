// From settings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/password/change_password_request.dart';
import 'package:netware/api/models/password/change_password_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/password/password_helper.dart';

class ChangePasswordNewScreen extends StatefulWidget {
  final String currentPass;

  const ChangePasswordNewScreen({Key key, this.currentPass}) : super(key: key);

  @override
  _ChangePasswordNewScreenState createState() => _ChangePasswordNewScreenState();
}

class _ChangePasswordNewScreenState extends State<ChangePasswordNewScreen> {
  final _changePasswordNewKey = GlobalKey<ScaffoldState>();
  Localization _loc;
  double _paddingHorizontal = 20.0;
  bool _isLoading = false;

  /// Password
  final TextEditingController _passwordNewController = TextEditingController();
  FocusNode _passwordNewFocusNode;
  bool _isPasswordNewValid = false;
  bool _obscureTextPassword = true;

  /// Password repeat
  final TextEditingController _passwordRepeatController = TextEditingController();
  FocusNode _passwordRepeatFocusNode;
  bool _isPasswordRepeatValid = false;
  bool _obscureTextPasswordRepeat = true;

  @override
  void initState() {
    super.initState();

    _passwordNewController.addListener(() {
      if (_passwordNewController.text.length >= PasswordHelper.minPasswordLength) {
        setState(() {
          _isPasswordNewValid = true;
        });
      } else {
        setState(() {
          _isPasswordNewValid = false;
        });
      }
    });

    _passwordRepeatController.addListener(() {
      if (_passwordRepeatController.text.length >= PasswordHelper.minPasswordLength) {
        setState(() {
          _isPasswordRepeatValid = true;
        });
      } else {
        setState(() {
          _isPasswordRepeatValid = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _loc = globals.text;

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: BlurLoadingContainer(
        loading: _isLoading,
        child: Scaffold(
          key: _changePasswordNewKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarSimple(
            context: context,
            onPressed: _onBackPressed,
            brightness: Brightness.light,
//            icon: Icon(Icons.close, color: AppColors.iconMirage),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  right: _paddingHorizontal,
                  left: _paddingHorizontal,
                ),
                child: lbl(
                  globals.text.changePassword(),
                  style: lblStyle.Headline4,
                  color: AppColors.lblDark,
                  fontWeight: FontWeight.normal,
                ),
              ),

              /// Password
              _txtPasswordNew(),

              /// Password
              _txtPasswordRepeat(),

              Expanded(
                child: Container(),
              ),

              SizedBox(height: 30.0),

              /// Нууц үг солих
              _btnChangePass(),

              SizedBox(height: AppHelper.marginBottom),
            ],
          ),
        ),
      ),
    );
  }

  _txtPasswordNew() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      labelText: globals.text.newPass(),
      controller: _passwordNewController,
//      hintText: _loc.password(),
      obscureText: _obscureTextPassword,
      textInputType: TextInputType.text,
      maxLength: PasswordHelper.maxPasswordLength,
      textColor: _obscureTextPassword ? AppColors.blue : AppColors.lblDark,
      bgColor: AppColors.txtBgGrey,
      suffixIcon: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Image.asset(
          _obscureTextPassword ? AssetName.eye_false : AssetName.eye_true,
          height: 20.0,
          colorBlendMode: BlendMode.modulate,
        ),
        onPressed: () {
          setState(() {
            _obscureTextPassword = !_obscureTextPassword;
          });
        },
      ),
    );
  }

  _txtPasswordRepeat() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      labelText: globals.text.newPassRepeat(),
      controller: _passwordRepeatController,
//      hintText: _loc.password(),
      obscureText: _obscureTextPasswordRepeat,
      textInputType: TextInputType.text,
      maxLength: PasswordHelper.maxPasswordLength,
      textColor: _obscureTextPasswordRepeat ? AppColors.blue : AppColors.lblDark,
      bgColor: AppColors.txtBgGrey,
      suffixIcon: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Image.asset(
          _obscureTextPasswordRepeat ? AssetName.eye_false : AssetName.eye_true,
          height: 20.0,
          colorBlendMode: BlendMode.modulate,
        ),
        onPressed: () {
          setState(() {
            _obscureTextPasswordRepeat = !_obscureTextPasswordRepeat;
          });
        },
      ),
    );
  }

  _btnChangePass() {
    return CustomButton(
      text: Func.toStr(_loc.changePass()),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: (_isPasswordNewValid && _isPasswordRepeatValid)
          ? () async {
              FocusScope.of(context).requestFocus(new FocusNode());

              // Validation
              if (_isLoading) return;
              setState(() => _isLoading = true);

              ChangePasswordRequest request = new ChangePasswordRequest(
                loginName: globals.user.loginName,
                oldPass: widget.currentPass,
                password: _passwordNewController.text,
                passwordConfirm: _passwordRepeatController.text,
              );

              ChangePasswordResponse response = await ApiManager.changePassword(request);

              setState(() => _isLoading = false);

              if (response.resultCode == 0) {
                showCustomDialog(
                  context: context,
                  img: Image.asset(
                    AssetName.success_blue,
                    height: 74.0,
                    colorBlendMode: BlendMode.modulate,
                  ),
                  title: globals.text.success(),
//                  body: globals.text.clickFinish(),
                  bodyHeight: 100.0,
                  btnText: 'Ok',
                  onPressedBtn: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard

                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                );
              } else {
                showSnackBar(
                  key: _changePasswordNewKey,
                  text: Func.isNotEmpty(response.resultDesc) ? response.resultDesc : globals.text.requestFailed(),
                );
              }
            }
          : null,
    );
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
