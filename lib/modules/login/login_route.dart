import 'dart:io';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/shared_pref_key.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/widgets/code_input.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/home/ui/home_route.dart';
import 'package:netware/modules/login/bloc/login_bloc.dart';
import 'package:netware/modules/login/bloc/login_event.dart';
import 'package:netware/modules/login/bloc/login_state.dart';
import 'package:netware/modules/login/welcome_screen.dart';
import 'package:netware/modules/password/password_helper.dart';
import 'package:netware/modules/password/related_login/change_password_screen.dart';
import 'package:netware/modules/password/related_login/forgot_password_screen.dart';
import 'package:netware/modules/settings/ui/additional_profile_route.dart';
import 'package:netware/modules/sign_up/sign_up_helper.dart';
import 'package:netware/modules/sign_up/step1_id_front/id_front_screen.dart';
import 'package:netware/modules/sign_up/step2_id_back/id_back_screen.dart';
import 'package:netware/modules/sign_up/step3_id_selfie/id_selfie_screen.dart';
import 'package:netware/modules/sign_up/step4_mobile/sign_up_mobile_screen.dart';
import 'package:netware/app/utils/biometric_helper.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:permission_handler/permission_handler.dart';
import 'api/login_repository.dart';
import 'api/verify_user_device_request.dart';
import 'api/verify_user_device_response.dart';
import 'login_helper.dart';
import 'package:netware/app/bloc/app_bloc.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> with TickerProviderStateMixin {
  final _scaffoldKeyLogin = GlobalKey<ScaffoldState>();
  LoginBloc _loginBloc;
  double _paddingHorizontal = 20.0;
  double _maxHeight = 0.0;

  /// Mobile
  TextEditingController _controllerMobileNo = TextEditingController();
  FocusNode _focusNodeMobileNo;
  String _prefixText = '+976';
  bool _isMobileNoValid = false;

  /// Password
  TextEditingController _controllerPass = TextEditingController();
  FocusNode _focusNodePass;
  bool _isPassValid = false;

  /// Biometric
  bool _canCheckBiometrics = false;
  bool _hasBiometricsAvailable = false;

  /// Remember me
  bool _chkRememberMeVal = false;

  /// Test base url - Зөвхөн test хийхэд зориулж connection url өөрчлөх боломж нэмэв
  TextEditingController _controllerBaseUrl = TextEditingController();
  FocusNode _focusNodeBaseUrl;
  bool _isBaseUrlValid = false;

  /// Button login
  bool _enabledBtnLogin = true;

  /// Permanent device dialog
  bool _enabledBtnConfirm = true;
  bool _hasTanWritten = false;
  String _tanCode = '';
  bool _isValidTan = false;

  @override
  void initState() {
    super.initState();

    // Mobile no
    _controllerMobileNo.addListener(() {
      if (_controllerMobileNo.text.length == 8) {
        setState(() {
          _isMobileNoValid = true;
        });
      } else {
        setState(() {
          _isMobileNoValid = false;
        });
      }
    });

    // Password
    _focusNodeMobileNo = FocusNode();

    _controllerPass.addListener(() {
      if (_controllerPass.text.length >= PasswordHelper.minPasswordLength) {
        setState(() => _isPassValid = true);
      } else {
        setState(() => _isPassValid = false);
      }
    });

    _focusNodePass = FocusNode();

    // Test base url
//    _controllerBaseUrl.addListener(() {
//      // Check is valid url
//      if (_controllerBaseUrl.text.isNotEmpty && _controllerBaseUrl.text.contains(':') && Uri.parse(_controllerBaseUrl.text).isAbsolute) {
//        globals.sharedPref?.setString(SharedPrefKey.TestBaseUrl, _controllerBaseUrl.text);
//        connectionManager.init(url: _controllerBaseUrl.text, isInit: true);
//      }
//    });
//    _focusNodeBaseUrl = FocusNode();
//    _controllerBaseUrl.text = globals.sharedPref?.getString(SharedPrefKey.TestBaseUrl) ?? ApiHelper.baseUrl;

    // Bloc
    _loginBloc = new LoginBloc()..add(LoginInitMobile());

//    _controllerPass.text = '111qqq'; //todo test

//    _controllerMobileNo.text = '95688910';
//    _controllerPass.text = '123qwe'; //todo test

//    _controllerMobileNo.text = '99073149';
//    _controllerPass.text = '12345a'; //todo test 99073149
  }

  @override
  void dispose() {
    _loginBloc.close();
    _focusNodeMobileNo.dispose();
    _focusNodePass.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => _loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: _blocListener,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      _controllerPass.text = '';
      showRevealDialog();
      _enabledBtnLogin = true;
    } else if (state is LoginProfileAdditional) {
      /// Харилцагчийн нэмэлт мэдээлэл оруулах
      setState(() => _controllerPass.text = '');
      Navigator.push(this.context, FadeRouteBuilder(route: AdditionalProfileRoute()));
      _enabledBtnLogin = true;
    } else if (state is LoginSetMobile) {
      _controllerMobileNo.text = state.mobile;
    } else if (state is LoginSetRememberMe) {
      _chkRememberMeVal = state.rememberMe;
    } else if (state is LoginFailed) {
      _enabledBtnLogin = true;
      switch (state.resultCode) {

        /// Бүртгэлгүй төхөөрөмжөөс хандсан байна. Таны утасны дугаар луу илгээсэн ТАН кодоор баталгаажуулна уу
        case LoginHelper.CODE_PERMANENT_DEVICE:
          _hint = state.resultDesc;
          _showVerifyTanDialog(state.loginName, state.password);
          break;

        /// Таны одоогийн нууц үгийг системээс автоматаар үүсгэсэн учир өөр нууц үгээр солино уу.
        case LoginHelper.CODE_CHANGE_PASSWORD:
          Navigator.push(
            this.context,
            FadeRouteBuilder(
                route: ChangePasswordRoute(
              loginName: state.loginName,
              hintText: Func.isEmpty(state.resultDesc) ? globals.text.msgChangePass() : state.resultDesc,
            )),
          );
          break;

        /// Нууц үгийн хүчинтэй хугацаа дууссан. Солино уу.
        case LoginHelper.CODE_PASSWORD_EXPIRED:
          Navigator.push(
            this.context,
            FadeRouteBuilder(
                route: ChangePasswordRoute(
              loginName: state.loginName,
              hintText: Func.isEmpty(state.resultDesc) ? globals.text.msgExpiredPass() : state.resultDesc,
            )),
          );
          break;

        default:
          showSnackBar(key: _scaffoldKeyLogin, text: state.resultDesc ?? globals.text.errorOccurred());
          break;
      }
    } else if (state is LoginClear) {
      _controllerMobileNo.clear();
      _controllerPass.clear();
    } else if (state is LoginSetBiometric) {
      _canCheckBiometrics = state.canCheckBiometrics;
      _hasBiometricsAvailable = state.hasAvailableBiometrics;
    }
  }

  Widget _blocBuilder(BuildContext context, LoginState state) {
    return WillPopScope(
//      onWillPop: () => dlgExitApp(context),
      onWillPop: () {
//        exit(0);
        return Future.value(false);
      },
      child: Scaffold(
//        appBar: AppBarEmpty(context: context, brightness: Brightness.light),
        backgroundColor: AppColors.bgWhite,
        key: _scaffoldKeyLogin,
//        resizeToAvoidBottomInset: false,

//        appBar: AppBarSimple(
//          context: context,
//          onPressed: null,
//          brightness: Brightness.light,
//        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode()); // Keyboard хаах
          },
          child: BlurLoadingContainer(
            loading: state is LoginLoading,
            child: LayoutBuilder(builder: (context, constraints) {
              // Keyboard гарч ирэхэд дэлгэцний хэмжээ багасахаас сэргийлж, хамгийн дээд утгыг хадгалж авна
              if (_maxHeight < constraints.maxHeight) _maxHeight = constraints.maxHeight;

              // Дэлгэцний хэмжээ, нягтаршил багатай төхөөрөмжид хамгийн доод утгыг хатуугаар оноож өгнө
              if (_maxHeight < AppHelper.minHeightScreen) _maxHeight = AppHelper.minHeightScreen;
//
              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(36.0),
                  height: _maxHeight,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child: Image.asset(AssetName.net_icon, alignment: Alignment.centerLeft, height: 23.0)),

                          /// Language
                          btnLang(color: AppColors.lblGrey),

                          SizedBox(width: 5.0),

                          /// Globe
                          Image.asset(AssetName.globe, color: AppColors.iconRegentGrey, height: 14.0, alignment: Alignment.centerRight)
                        ],
                      ),

                      Expanded(child: Container(), flex: 1),

                      /// Title
                      _title(),

                      SizedBox(height: 20.0),

                      /// Утасны дугаар
                      _txtMobile(),

                      /// Нууц үг
                      _txtPassword(),

                      SizedBox(height: 20.0),

                      /// Сануулах
                      _chkRememberMe(),

                      /// Test base url
//                      _txtBaseUrl(),

                      SizedBox(height: 38.0),

                      /// Button login
                      Row(
                        children: <Widget>[
                          Expanded(child: _btnLogin(state)),
                          _canCheckBiometrics ? _btnBiometric(state) : Container(),
//                          _canCheckBiometrics ? _btnBiometric(state) : Container(),
                        ],
                      ),

//                      Row(
//                        children: <Widget>[
//                          _btnLogin(state),
//                          _btnBiometric(state)
////                          _canCheckBiometrics ? _btnBiometric(state) : Container(),
//                        ],
//                      ),

//                      Expanded(
//                        child: Align(
//                          alignment: FractionalOffset.bottomCenter,
//                          child: Padding(padding: EdgeInsets.only(bottom: 10.0), child: _btnLogin(state) //Your widget here,
//                              ),
//                        ),
//                      ),

                      Expanded(child: Container(), flex: 1),

                      SizedBox(height: 10.0),

                      /// Бүртгүүлэх
                      _btnSignUp(),

                      SizedBox(height: 10.0),

                      /// Button forgot password
                      _btnForgotPassword(),

                      SizedBox(height: AppHelper.marginBottom),
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
      globals.text.login(),
      style: lblStyle.Headline4,
      fontSize: AppHelper.fontSizeHeadline4,
      color: AppColors.lblBlue,
      fontWeight: FontWeight.w800,
    );
  }

  _btnSignUp() {
    return Container(
      child: TextButton(
//        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        text: globals.text.signUp(),
        onPressed: () {
          _onPressedBtnSignUp();
        },
        textColor: AppColors.lblGrey,
        fontSize: 13.0,
        enabledRippleEffect: false,
      ),
    );
  }

  _onPressedBtnSignUp() async {
    FocusScope.of(context).requestFocus(new FocusNode());

    try {
      if (Platform.isIOS) {
        PermissionHandler().checkPermissionStatus(PermissionGroup.camera).then((cameraStatus) async {
          if (cameraStatus == PermissionStatus.granted) {
            _navigateSignUp();
          } else {
            Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
            print(permissions);
            if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
              _navigateSignUp();
            } else {
              //todo
              print('Permission failed');
              PermissionHandler().openAppSettings();
//              errorDialog(
//                  context: context,
//                  text: app.localization.requirePermission() + "\n - Camera",
//                  onPressed: () {
//                    Navigator.pop(context);
//                    PermissionHandl
//                        .openAppSettings();
//                  });
            }
          }
        });
      } else {
        PermissionHandler().checkPermissionStatus(PermissionGroup.camera).then((cameraStatus) async {
          if (cameraStatus == PermissionStatus.granted) {
            _navigateSignUp();
          } else {
            Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([
              PermissionGroup.camera,
              PermissionGroup.microphone,
            ]);
            print(permissions);
            if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
              _navigateSignUp();
            } else {
              String p = cameraStatus != PermissionStatus.granted ? "\n - Camera" : "";
              //todo
//                errorDialog(
//                    context: context,
//                    text: app.localization.requirePermission() + p,
//                    onPressed: () {
//                      Navigator.pop(context);
//                      PermissionHandler().openAppSettings();
//                    });
            }
          }
        });

//        PermissionHandler().checkPermissionStatus(PermissionGroup.camera).then((cameraStatus) async {
//          PermissionHandler().checkPermissionStatus(PermissionGroup.microphone).then((micStatus) async {
//            if (cameraStatus == PermissionStatus.granted && micStatus == PermissionStatus.granted) {
//              _navigateSignUp();
//            } else {
//              Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([
//                PermissionGroup.camera,
//                PermissionGroup.microphone,
//              ]);
//              print(permissions);
//              if (permissions[PermissionGroup.camera] == PermissionStatus.granted && permissions[PermissionGroup.microphone] == PermissionStatus.granted) {
//                _navigateSignUp();
//              } else {
//                String p = cameraStatus != PermissionStatus.granted ? "\n - Camera" : "";
//                p += micStatus != PermissionStatus.granted ? "\n - Microphone" : "";
//                //todo
////                errorDialog(
////                    context: context,
////                    text: app.localization.requirePermission() + p,
////                    onPressed: () {
////                      Navigator.pop(context);
////                      PermissionHandler().openAppSettings();
////                    });
//              }
//            }
//          });
//        });
      }
    } catch (e) {
      print(e);
    }

//    Map<PermissionGroup, PermissionStatus> permissions =
//        await PermissionHandler().requestPermissions([
//      PermissionGroup.camera,
//      PermissionGroup.mediaLibrary,
//      PermissionGroup.access_mediaglobals.textation,
//    ]);
//    print(permissions);
//    if (permissions[PermissionGroup.camera] == PermissionStatus.granted &&
//        permissions[PermissionGroup.mediaLibrary] == PermissionStatus.granted &&
//        permissions[PermissionGroup.access_mediaglobals.textation] ==
//            PermissionStatus.granted) {
//      FocusScope.of(context).requestFocus(new FocusNode());
//    }
  }

  _navigateSignUp() {
//    SignUpHelper.clear();

    if (!Func.isEmpty(SignUpHelper.userKey)) {
      switch (SignUpHelper.stepNo) {
        case 1:
          Navigator.push(this.context, FadeRouteBuilder(route: IdBackScreen()));
          break;
        case 2:
          Navigator.push(this.context, FadeRouteBuilder(route: IdSelfieScreen()));
          break;
        case 3:
          Navigator.push(this.context, FadeRouteBuilder(route: SignUpMobileScreen()));
          break;
        case 0:
        default:
          SignUpHelper.clear();
          Navigator.push(this.context, FadeRouteBuilder(route: IdFrontRoute(fromRoute: 'login_route')));
          break;
      }
    } else {
      SignUpHelper.clear();
      Navigator.push(this.context, FadeRouteBuilder(route: IdFrontRoute(fromRoute: 'login_route')));
    }
  }

  _txtMobile() {
    return txt(
      context: context,
//      margin: EdgeInsets.only(top: 38.0),
      labelText: globals.text.mobile(),
      labelColor: AppColors.lblWhite,
      controller: _controllerMobileNo,
      focusNode: _focusNodeMobileNo,
      hintText: globals.text.mobile(),
      maxLength: 8,
      textInputType: TextInputType.number,
//      prefixText: (_prefixText),
      textColor: _isMobileNoValid ? AppColors.lblDark : AppColors.lblDark,
    );
  }

  _txtPassword() {
    return txt(
      context: context,
//      margin: EdgeInsets.only(top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      labelText: globals.text.password(),
      labelColor: AppColors.lblWhite,
      controller: _controllerPass,
      focusNode: _focusNodePass,
      hintText: globals.text.password(),
      obscureText: true,
      textInputType: TextInputType.text,
      maxLength: PasswordHelper.maxPasswordLength,
      textColor: AppColors.lblDark,
    );
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

  _chkRememberMe() {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: AppColors.chkUnselectedGrey,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
//        padding: EdgeInsets.only(left: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                value: _chkRememberMeVal,
                activeColor: AppColors.blue,
                onChanged: (bool newValue) {
                  setState(() {
                    _chkRememberMeVal = newValue;
                  });
                },
              ),
            ),
            SizedBox(width: 5.0),
            InkWell(
              child: lbl(
                globals.text.rememberMe(),
                fontSize: 13.0,
                color: AppColors.lblGrey,
              ),
              onTap: () {
                setState(() {
                  _chkRememberMeVal = !_chkRememberMeVal;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _btnForgotPassword() {
    return TextButton(
      padding: EdgeInsets.only(right: _paddingHorizontal),
      text: globals.text.forgotPasswordQuestion(),
      onPressed: () {
        FocusScope.of(context).requestFocus(new FocusNode());

        Navigator.of(context).push(
          new PageRouteBuilder(
            pageBuilder: (BuildContext context, _, __) {
              return new ForgotPasswordRoute();
            },
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return new FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      textColor: AppColors.lblGrey,
      fontSize: 13.0,
      enabledRippleEffect: false,
    );
  }

  _txtBaseUrl() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      hintText: 'http://34.70.15.87:9099',
      controller: _controllerBaseUrl,
      focusNode: _focusNodeBaseUrl,
      maxLength: 30,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
    );
  }

  _btnLogin(LoginState state) {
    return CustomButton(
      text: globals.text.login(),
      context: context,
      color: AppColors.btnBlue,
      disabledColor: AppColors.btnGrey,
      textColor: AppColors.lblWhite,
      disabledTextColor: AppColors.btnBlue,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
//      margin: EdgeInsets.only(top: 0.0, right: _paddingHorizontal + 10.0, bottom: 0.0, left: _paddingHorizontal + 10.0),
      onPressed: _enabledBtnLogin
          ? () {
              FocusScope.of(context).requestFocus(new FocusNode());

              // Validation
              if (!_isMobileNoValid) {
                /// Утасны дугаараа зөв оруулна уу
                showSnackBar(key: _scaffoldKeyLogin, text: globals.text.validMobile());
                return;
              }

              if (!_isPassValid) {
                /// Нууц үг 6-20 тэмдэгт байх ёстой
                showSnackBar(
                  key: _scaffoldKeyLogin,
                  text: globals.text
                      .validPassword()
                      .replaceAll('[TEXT1]', '${PasswordHelper.minPasswordLength}')
                      .replaceAll('[TEXT2]', '${PasswordHelper.maxPasswordLength}'),
                );
                return;
              }

              setState(() => _enabledBtnLogin = false);

              // Login
              _loginBloc.add(LoginSubmit(
                loginName: _controllerMobileNo.text,
                password: _controllerPass.text, //_passwordController.text,
                rememberMe: _chkRememberMeVal,
              ));
            }
          : null,
    );
  }

  _btnBiometric(LoginState state) {
    return SizedBox(
//      width: 70.0,
      child: CustomButton2(
        icon: Icon(Icons.fingerprint, size: 24.0, color: AppColors.iconWhite),
        //Image.asset(AssetName.biometric, height: 24.0),
        context: context,
        width: 30.0,
        color: AppColors.btnBlue,
        disabledColor: AppColors.btnGrey,
        textColor: AppColors.lblWhite,
        disabledTextColor: AppColors.btnBlue,
        margin: EdgeInsets.only(left: 10.0),
        onPressed: _canCheckBiometrics
            ? () async {
                FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard

                if (await _checkBiometrics()) {
                  _controllerPass.text = '';

                  setState(() => _enabledBtnLogin = false);

                  _loginBloc.add(LoginSubmit(
                    loginName: _controllerMobileNo.text,
                    password: '', //_passwordController.text,
                    rememberMe: _chkRememberMeVal,
                  ));
                } else {
                  print('failed');
                }
              }
            : null,
      ),
    );
  }

  /// Welcome dialog
  Future<void> showRevealDialog() async {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        Future.delayed(Duration(milliseconds: 1000), () {
          Navigator.of(context).pop(true);
          setState(() => _controllerPass.text = '');
          Navigator.push(this.context, FadeRouteBuilder(route: HomeRoute()));
        });

        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: WelcomeScreen(),
            ),
            margin: EdgeInsets.all(0.0),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return CircularRevealAnimation(
          child: child,
          animation: anim1,
          centerAlignment: Alignment.bottomCenter,
        );
      },
    );
  }

  String _hint = '';

  /// Тогтмол хандах төхөөрөмж
  _showVerifyTanDialog(String loginName, String password) {
    showDialog(
      context: this.context,
      child: ResponsiveDialog(
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20.0),

                  Image.asset(
                    AssetName.warning_blue,
                    height: 74.0,
                    colorBlendMode: BlendMode.modulate,
                  ),

                  SizedBox(height: 30.0),

                  lbl(
                    'Баталгаажуулалт'.toUpperCase(),
                    alignment: Alignment.center,
                    textAlign: TextAlign.center,
                    color: AppColors.lblDark,
                    fontWeight: FontWeight.w500,
                    maxLines: 2,
                    fontSize: 16.0,
                  ),

                  /// Хөндлөн зураас
                  Container(
                    height: 0.5,
                    color: AppColors.athensGray,
                    margin: EdgeInsets.only(top: 20.0, right: 30.0, bottom: 20.0, left: 30.0),
                  ),

                  lbl(
                    Func.isEmpty(_hint) ? globals.text.deviceHint() : _hint,
                    margin: EdgeInsets.only(top: 0.0, right: 20.0, bottom: 0.0, left: 20.0),
                    alignment: Alignment.center,
                    textAlign: TextAlign.end,
                    color: AppColors.lblDark,
                    fontWeight: FontWeight.normal,
                    maxLines: 5,
                    fontSize: 16.0,
                  ),

                  SizedBox(height: 20.0),

                  SizedBox(
                    height: 40.0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          codeInput2(
                            hasTanWritten: _hasTanWritten,
                            inputLength: 4,
                            onFilled: (value) {
                              setState(() {
                                _tanCode = value;
                                if ((_tanCode ?? '').length == 4) {
                                  _isValidTan = true;
                                  FocusScope.of(context).requestFocus(new FocusNode()); // Hide keyboard
                                  _onPressedBtnConfirm(loginName, password);
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
                      ),
                    ),
                  ),

//                  SizedBox(height: 20.0),
//
//                  /// BUTTONS
//                  CustomButton(
//                    text: 'БАТАЛГААЖУУЛАХ',
//                    context: this.context,
//                    color: AppColors.bgBlue,
//                    disabledColor: AppColors.btnGreyDisabled,
//                    textColor: AppColors.lblWhite,
//                    fontSize: 16.0,
//                    fontWeight: FontWeight.w500,
//                    onPressed: _enabledBtnConfirm
//                        ? () async {
//                      _onPressedBtnConfirm(loginName, password);
//                    }
//                        : null,
//                  ),

                  SizedBox(height: 20.0),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onPressedBtnConfirm(String loginName, String password) async {
    try {
      FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard

      if (_isValidTan) {}

      setState(() {
        _hint = '';
        _enabledBtnConfirm = false;
      });

      /// Request
      LoginRepository repository = new LoginRepository();
      VerifyUserDeviceRequest request = new VerifyUserDeviceRequest(
        deviceCode: globals.deviceCode,
        pushNotifToken: globals.pushNotifToken,
        tan: _tanCode,
        mobileNo: loginName,
        rememberMe: _chkRememberMeVal ? '1' : '0',
      );

      /// Response
      VerifyUserDeviceResponse response = await repository.verifyUserDevice(request);

      setState(() {
        _enabledBtnConfirm = true;
      });

      if (response.resultCode == 0) {
        Navigator.pop(context);

        Future.delayed(const Duration(milliseconds: 300), () {
          _loginBloc.add(LoginSubmit(
            loginName: loginName,
            password: password, //_passwordController.text,
            rememberMe: _chkRememberMeVal,
          ));
        });
      } else {
        setState(() {
          _hint = !Func.isEmpty(response.resultDesc) ? response.resultDesc : 'Баталгаажуулалт амжилтгүй.';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _hint = globals.text.requestFailed();
      });
    }
  }

  Widget btnLang({Color color, EdgeInsets padding}) {
    return Container(
//      padding: padding ?? EdgeInsets.all(0.0),
      alignment: Alignment.centerRight,
      child: TextButton(
        text: globals.locale.languageCode == LangCode.mn ? 'EN' : 'MN',
        onPressed: () {
//        BlocProvider.of<AppBloc>(context)..add(ChangeLang(locale: newLocale(globals.langCode)));

//        const String MN = "mn";
//        const String EN = "en";
//globals.langCode == "mn"

          if (globals.locale.languageCode == LangCode.mn) {
            BlocProvider.of<AppBloc>(context)..add(ChangeLangEN(locale: Locale(LangCode.en)));
          } else {
            BlocProvider.of<AppBloc>(context)..add(ChangeLangMN(locale: Locale(LangCode.mn)));
          }
        },
//        padding: EdgeInsets.only(top: 20.0, right: 20.0, bottom: 15.0, left: 20.0),
        textColor: color ?? AppColors.lblDark,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        enabledRippleEffect: false,
      ),
    );
  }
}
