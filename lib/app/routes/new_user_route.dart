import 'dart:io';

import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/modules/login/login_route.dart';
import 'package:netware/modules/sign_up/step1_id_front/id_front_screen.dart';
import 'package:netware/modules/sign_up/step2_id_back/id_back_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class NewUserRoute extends StatefulWidget {
  @override
  _NewUserRouteState createState() => _NewUserRouteState();
}

class _NewUserRouteState extends State<NewUserRoute> {
  /// UI
  final _newUserKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _newUserKey,
        appBar: AppBarEmpty(context: context, brightness: Brightness.light, backgroundColor: AppColors.bgGreyLight),
        backgroundColor: AppColors.bgGreyLight,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// Та шинэ хэрэглэгч үү?
                  lbl(
                    globals.text.areYouNewUser(),
                    style: lblStyle.Headline5,
                    color: AppColors.lblBlue,
                    padding: EdgeInsets.symmetric(horizontal: AppHelper.margin),
                    maxLines: 2,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 20.0),

                  /// Хэрэв та шинэ хэрэглэгч бол бүртгүүлэх шаардлагатай.
                  lbl(
                    globals.text.needSignUp(),
                    padding: EdgeInsets.symmetric(horizontal: AppHelper.margin),
                    maxLines: 3,
                    fontSize: 13.0,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.0),

            /// Button yes
            _btnYes(),

            SizedBox(height: 30.0),

            /// Button no
            _btnNo(),

            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _btnYes() {
    return CustomButton(
        text: Func.toStr(globals.text.yes()),
        isUppercase: false,
        context: context,
        margin: EdgeInsets.symmetric(horizontal: 25.0),
        color: AppColors.bgBlue,
        disabledColor: AppColors.btnGreyDisabled,
        textColor: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        onPressed: () {
          try {
            if (Platform.isIOS) {
              PermissionHandler().checkPermissionStatus(PermissionGroup.camera).then((cameraStatus) async {
                if (cameraStatus == PermissionStatus.granted) {
                  Navigator.pushReplacement(this.context, FadeRouteBuilder(route: IdFrontRoute(fromRoute: 'new_user_route')));
                } else {
                  Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
                  print(permissions);
                  if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
                    Navigator.pushReplacement(this.context, FadeRouteBuilder(route: IdFrontRoute(fromRoute: 'new_user_route')));
                  } else {
                    //todo
                    print('Permission failed');
                    PermissionHandler().openAppSettings();
                  }
                }
              });
            } else {
              PermissionHandler().checkPermissionStatus(PermissionGroup.camera).then((cameraStatus) async {
                if (cameraStatus == PermissionStatus.granted) {
                  Navigator.pushReplacement(this.context, FadeRouteBuilder(route: IdFrontRoute(fromRoute: 'new_user_route')));
                } else {
                  Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([
                    PermissionGroup.camera,
                    PermissionGroup.microphone,
                  ]);
                  print(permissions);
                  if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
                    Navigator.pushReplacement(this.context, FadeRouteBuilder(route: IdFrontRoute(fromRoute: 'new_user_route')));
                  } else {
                    String p = cameraStatus != PermissionStatus.granted ? "\n - Camera" : "";
                  }
                }
              });
            }
          } catch (e) {
            print(e);
          }
        });
  }

  Widget _btnNo() {
    return TextButton(
      text: globals.text.no(),
      alignment: Alignment.center,
      textColor: AppColors.lblBlue,
      fontSize: AppHelper.fontSizeMedium,
      fontWeight: FontWeight.w500,
      onPressed: () {
        Navigator.pushReplacement(context, FadeRouteBuilder(route: LoginRoute()));
      },
    );
  }
}
