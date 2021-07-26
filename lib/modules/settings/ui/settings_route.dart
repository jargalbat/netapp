import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/settings/update_biometric_request.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/biometric_helper.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/switch.dart';
import 'package:netware/modules/password/related_settings/change_password_current_screen.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/list_item.dart';
import 'package:netware/modules/settings/ui/settings_header.dart';
import 'device_list_screen.dart';

class SettingsRoute extends StatefulWidget {
  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  final _setKey = GlobalKey<ScaffoldState>();
  bool _switchValueBiometric;
  bool _isLoading = false;

  @override
  void initState() {
    _switchValueBiometric = (globals.biometricAuth == 1);
    super.initState();
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
          key: _setKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarSimple(
            context: context,
            brightness: Brightness.light,
            onPressed: _onBackPressed,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /// Header
                SettingsHeader(title: globals.text.settings()),

                CustomCard(
                  margin: EdgeInsets.only(
                    right: AppHelper.margin,
                    left: AppHelper.margin,
                  ),
                  child: Column(
                    children: <Widget>[
                      /// Төхөөрөмжийн жагсаалт
                      MenuListItem(
                        text: globals.text.deviceList(),
                        onPressed: () => Navigator.push(context, FadeRouteBuilder(route: DeviceListRoute())),
                      ),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Нууц үг солих
                      MenuListItem(
                        text: globals.text.changePassword(),
                        onPressed: () => Navigator.push(context, FadeRouteBuilder(route: ChangePasswordCurrentScreen())),
                      ),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Биометр
                      MenuListItem(
                        padding: EdgeInsets.only(top: 8.0, right: 5.0, bottom: 8.0, left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            /// Text
                            lbl(globals.text.biometric(), fontSize: 16.0, color: AppColors.lblDark),

                            /// Switch
                            CustomSwitch(
                              value: _switchValueBiometric,
                              onChanged: (val) {
                                _switchValueBiometric = val;
                                _onChangedBiometric();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onChangedBiometric() async {
    try {
      if (_isLoading) return;

      if (_switchValueBiometric) {
        bool auth = await _checkBiometrics();
        if (!auth) {
          setState(() {
            _switchValueBiometric = !_switchValueBiometric;
          });
          return;
        }
      }

      setState(() {
        _isLoading = true;
      });

      UpdateBiometricRequest request = UpdateBiometricRequest()
        ..deviceCode = globals.deviceCode ?? ''
        ..biometricAuth = _switchValueBiometric ? 1 : 0;

      var res = await ApiManager.updateBiometric(request);

      setState(() {
        _isLoading = false;
      });

      if (res?.resultCode == 0) {
        globals.biometricAuth = _switchValueBiometric ? 1 : 0;
      } else {
        setState(() {
          _switchValueBiometric = !_switchValueBiometric;
        });

        showSnackBar(key: _setKey, text: res.resultDesc);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _checkBiometrics() async {
    bool didAuthenticate = false;
    try {
      /// Biometric
      BiometricHelper biometricHelper = new BiometricHelper();
      await biometricHelper.initBiometric();

      if (await biometricHelper.checkBiometrics()) {
        didAuthenticate = true;
      } else {
        didAuthenticate = false;
      }
    } on PlatformException catch (e) {
      print(e);
      didAuthenticate = false;
    }

    return didAuthenticate;
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}

//                      /// Хэл солих
//                      listItemMenu(
//                        onPressed: () {
//                          Navigator.of(context).push(
//                            new PageRouteBuilder(
//                              pageBuilder: (BuildContext context, _, __) {
//                                return new LanguageScreen();
//                              },
//                              transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//                                return new FadeTransition(opacity: animation, child: child);
//                              },
//                            ),
//                          );
//                        },
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            /// Text
//                            lbl('Хэл солих', fontSize: 16.0, color: AppColors.lblDark),
//
//                            /// Icon
//                            Row(
//                              children: <Widget>[
//                                lbl('MN', fontSize: 16.0, color: AppColors.lblDark.withOpacity(0.5)),
//                                SizedBox(width: 3.0),
//                                Icon(
//                                  Icons.arrow_forward_ios,
//                                  color: AppColors.iconMirage,
//                                ),
//                              ],
//                            ),
//                          ],
//                        ),
//                      ),
//
//                      Divider(height: 2.0, color: AppColors.bgGrey),
