// From profile

import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/password/password_helper.dart';

import 'change_password_new_screen.dart';

class ChangePasswordCurrentScreen extends StatefulWidget {
  @override
  _ChangePasswordCurrentScreenState createState() => _ChangePasswordCurrentScreenState();
}

class _ChangePasswordCurrentScreenState extends State<ChangePasswordCurrentScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double _paddingHorizontal = 20.0;
  bool _isLoading = false;

  /// Password
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode;
  bool _isPasswordValid = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      if (_passwordController.text.length >= PasswordHelper.minPasswordLength) {
        setState(() {
          _isPasswordValid = true;
        });
      } else {
        setState(() {
          _isPasswordValid = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: BlurLoadingContainer(
        loading: _isLoading,
        child: Scaffold(
          key: _scaffoldKey,
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
              _txtPassword(),

              Expanded(
                child: Container(),
              ),

              SizedBox(height: 30.0),

              /// Үргэлжлүүлэх
              _btnContinue(),

              SizedBox(height: AppHelper.marginBottom),
            ],
          ),
        ),
      ),
    );
  }

  _txtPassword() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      labelText: globals.text.currentPass(),
      controller: _passwordController,
//      hintText: _loc.password(),
      obscureText: _obscureText,
      textInputType: TextInputType.text,
      maxLength: PasswordHelper.maxPasswordLength,
      textColor: _obscureText ? AppColors.blue : AppColors.lblDark,
      bgColor: AppColors.txtBgGrey,
      suffixIcon: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Image.asset(
          _obscureText ? AssetName.eye_false : AssetName.eye_true,
          height: 20.0,
          colorBlendMode: BlendMode.modulate,
        ),
        onPressed: () async {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }

  _btnContinue() {
    return CustomButton(
      text: Func.toStr(globals.text.contin()),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: _isPasswordValid
          ? () {
              FocusScope.of(context).requestFocus(new FocusNode());

              Navigator.of(context).push(
                new PageRouteBuilder(
                  pageBuilder: (BuildContext context, _, __) {
                    return new ChangePasswordNewScreen(currentPass: _passwordController.text);
                  },
                  transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                    return new FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            }
          : null,
    );
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
