import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/app_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/switch.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/list_item.dart';
import 'package:netware/modules/bank_acnt/ui/bank_acnt_list_route.dart';
import 'package:netware/modules/login/login_helper.dart';
import 'package:netware/modules/settings/bloc/settings_bloc.dart';
import 'package:netware/modules/settings/ui/branch_route.dart';
import 'package:netware/modules/settings/ui/help_route.dart';
import 'package:netware/modules/settings/ui/history/history_route.dart';
import 'package:netware/modules/settings/ui/location_screen.dart';
import 'package:netware/modules/settings/ui/settings_header.dart';
import 'profile_route.dart';
import 'relative/relative_route.dart';
import 'settings_route.dart';
import 'package:http/http.dart' as http;

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  /// UI
  final _settingsKey = GlobalKey<ScaffoldState>();
  final double _cardMargin = 15.0;

  /// Data
  SettingsBloc _settingsBloc;

  /// Facebook
  bool _switchFbValue = false;
  FacebookLogin _facebookLogin;

  @override
  void initState() {
    _settingsBloc = SettingsBloc();
    _switchFbValue = Func.isNotEmpty(globals.user.fbId);
    super.initState();
  }

  @override
  void dispose() {
    _settingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => _settingsBloc,
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: _blocListener,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, SettingsState state) {
    if (state is BindFbSuccess) {
      _switchFbValue = true;
    } else if (state is BindFbFailed) {
      _switchFbValue = false;
      showSnackBar(key: _settingsKey, text: state.text);
    } else if (state is ShowSnackBar) {
      showSnackBar(key: _settingsKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, SettingsState state) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          key: _settingsKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarEmpty(
            context: context,
            brightness: Brightness.light,
            backgroundColor: AppColors.bgGreyLight,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /// Тохиргоо
                SettingsHeader(title: globals.text.settings(), margin: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0)),

                CustomCard(
                  margin: EdgeInsets.only(right: _cardMargin, left: _cardMargin),
                  child: Column(
                    children: <Widget>[
                      /// Хувийн мэдээлэл
                      MenuListItem(
                        leadingImg: AssetName.user,
                        text: globals.text.privateInfo(),
                        onPressed: () => Navigator.push(context, FadeRouteBuilder(route: ProfileRoute())),
                      ),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Миний данс
                      MenuListItem(
                        leadingImg: AssetName.credit_card,
                        text: globals.text.myAcnt(),
                        onPressed: () => Navigator.push(context, FadeRouteBuilder(route: BankAcntListRoute())),
                      ),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Холбоотой хүмүүс
                      MenuListItem(
                        leadingImg: AssetName.users,
                        text: globals.text.relative(),
                        onPressed: () => Navigator.push(context, FadeRouteBuilder(route: RelativeRoute())),
                      ),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Түүх
                      MenuListItem(
                        leadingImg: AssetName.file,
                        text: globals.text.history(),
                        onPressed: () => Navigator.push(context, FadeRouteBuilder(route: HistoryRoute())),
                      ),

                      Divider(height: 2.0, color: AppColors.bgGrey),

//                      /// Facebook холбох
//                      _linkFbWidget(),
//
//                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Тохиргоо
                      MenuListItem(
                        leadingImg: AssetName.settings2,
                        text: globals.text.settings(),
                        onPressed: () => Navigator.push(context, FadeRouteBuilder(route: SettingsRoute())),
                      ),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Тусламж
                      MenuListItem(
                        leadingImg: AssetName.help_circle,
                        text: globals.text.help(),
                        onPressed: () => Navigator.push(context, FadeRouteBuilder(route: HelpRoute())),
                      ),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Салбар нэгж
                      MenuListItem(
                        leadingImg: AssetName.navigation,
                        text: globals.text.branch(),
                        onPressed: () => Navigator.push(context, FadeRouteBuilder(route: BranchRoute())),
                      ),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Системээс гарах
                      _logoutWidget(),
                    ],
                  ),
                ),

                SizedBox(height: AppHelper.marginBottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _linkFbWidget() {
    return MenuListItem(
      leadingImg: AssetName.facebook,
      text: globals.text.linkFb(),
      followingIcon: CustomSwitch(
        value: _switchFbValue,
        onChanged: (val) {
          _switchFbValue = val;
          if (_switchFbValue) {
            _loginFb();
          } else {
            _logoutFb();
          }
        },
      ),
      onPressed: () {},
    );
  }

  void _loginFb() async {
    var facebookLoginResult = await (_facebookLogin ?? FacebookLogin()).logIn(['public_profile']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        _fbLoginStatusChanged(false, '', '');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        _fbLoginStatusChanged(false, '', '');
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http
            .get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        _fbLoginStatusChanged(true, profile["name"], profile["id"]);
        break;
    }
  }

  void _logoutFb() async {
    await (_facebookLogin ?? FacebookLogin()).logOut();
    print("LoggedOut");
    _fbLoginStatusChanged(false, '', '');
  }

  void _fbLoginStatusChanged(bool isLoggedIn, String profileName, String profileId) {
    _switchFbValue = isLoggedIn;
    print(profileName);

    if (isLoggedIn) {
      _settingsBloc.add(BindFb(fbId: profileId, fbName: profileName));
    } else {
      setState(() {
        _switchFbValue = false;
      });
      _settingsBloc.add(UnbindFb());
    }
  }

  Widget _logoutWidget() {
    return MenuListItem(
      text: globals.text.logout(),
      padding: EdgeInsets.only(top: 15.0, right: 10.0, bottom: 15.0, left: 15.0),
      textColor: AppColors.iconRed,
      followingIcon: Icon(
        Icons.power_settings_new,
        color: AppColors.iconRed,
      ),
      onPressed: () {
        LoginHelper.showLogoutDialog(context);
      },
    );
  }
}
