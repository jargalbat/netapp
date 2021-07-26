import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/modules/login/login_route.dart';
import 'package:netware/modules/sign_up/step2_id_back/id_back_screen.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../sign_up_helper.dart';
import 'api/id_front_response.dart';
import 'bloc/id_front_bloc.dart';
import 'bloc/id_front_event.dart';
import 'bloc/id_front_state.dart';

class IdFrontRoute extends StatefulWidget {
  final String fromRoute; // New user route, Login route

  IdFrontRoute({@required this.fromRoute});

  @override
  _IdFrontRouteState createState() => _IdFrontRouteState();
}

class _IdFrontRouteState extends State<IdFrontRoute> with TickerProviderStateMixin {
//  final _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  Localization _loc;
  double _paddingHorizontal = 20.0;
  IdFrontBloc _bloc;

  /// Camera
  File _file;
  CameraController _controllerCamera1;
  List<CameraDescription> _cameraList;
  bool _isCameraReady = false;

  /// Flashlight
  bool _isFlashlightOn = false;

  /// Loading dialog
  AnimationController _controllerLoading1;

  /// Last name
  TextEditingController _controllerLastName = TextEditingController();
  FocusNode _focusNodeLastName;
  bool _isLastNameValid = false;

  /// First name
  TextEditingController _controllerFirstName = TextEditingController();
  FocusNode _focusNodeFirstName;
  bool _isFirstNameValid = false;

  /// First name
  TextEditingController _controllerRegNo = TextEditingController();
  FocusNode _focusNodeRegNo;
  bool _isRegNoValid = false;

  @override
  void initState() {
    super.initState();

    _bloc = new IdFrontBloc();

    _initCamera();

    _controllerLastName?.addListener(() {
      if (_controllerLastName.text.length > 0) {
        setState(() {
          _isLastNameValid = true;
        });
      } else {
        setState(() {
          _isLastNameValid = false;
        });
      }
    });

    _controllerFirstName?.addListener(() {
      if (_controllerFirstName.text.length > 0) {
        setState(() {
          _isFirstNameValid = true;
        });
      } else {
        setState(() {
          _isFirstNameValid = false;
        });
      }
    });

    _controllerRegNo?.addListener(() {
      if (_controllerRegNo.text.length > 0) {
        setState(() {
          _isRegNoValid = true;
        });
      } else {
        setState(() {
          _isRegNoValid = false;
        });
      }
    });
  }

  @override
  void dispose() {
//    _controllerCamera1?.dispose();
    _controllerLastName?.dispose();
    _controllerFirstName?.dispose();
    _controllerRegNo?.dispose();
    _controllerLoading1?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loc = globals.text;

    return BlocProvider<IdFrontBloc>(
      create: (context) => _bloc,
      child: BlocListener<IdFrontBloc, IdFrontState>(
        listener: _blocListener,
        child: BlocBuilder<IdFrontBloc, IdFrontState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, IdFrontState state) {
    if (state is IdFrontLoading) {
      _showLoadingDlg();
    } else if (state is IdFrontSuccess) {
      Navigator.pop(context); // loading dialog
      _showConfirmDlg(state.idFrontResponse);
    } else if (state is IdFrontFailed) {
      Navigator.pop(context); // loading dialog
      SignUpHelper.showErrorDlg(
        context: context,
        titleText: '${globals.text.warning()}!',
        bodyText: !Func.isEmpty(state.resDesc) ? state.resDesc : globals.text.badPic(),
        btnText: globals.text.again(),
        onPressedBtn: () {
          Navigator.pop(context);
        },
      );
    } else if (state is IdFrontConfirmSuccess) {
      Navigator.pop(this.context); //this
      Navigator.push(this.context, FadeRouteBuilder(route: IdBackScreen()));
    } else if (state is IdFrontConfirmFailed) {
      SignUpHelper.showErrorDlg(
        context: context,
        titleText: '${globals.text.warning()}!',
        bodyText: !Func.isEmpty(state.resDesc) ? state.resDesc : globals.text.requestFailed(),
        btnText: globals.text.again(),
        onPressedBtn: () {
          Navigator.pop(context);
        },
      );
    }
  }

  Widget _blocBuilder(BuildContext context, IdFrontState state) {
    _loc = globals.text;

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed(context);
        return Future.value(false);
      },
      child: Scaffold(
//        key: _scaffoldKey1,
        backgroundColor: AppColors.bgGrey,
        appBar: AppBarSimple(
          context: context,
          brightness: Brightness.light,
          onPressed: () {
            _onBackPressed(context);
          },
          hasBackArrow: true,
          actions: [
            Container(),
//                btnLang(context: context, color: AppColors.lblDark),
          ],
        ),
        body: Column(
          children: <Widget>[
            /// Бүртгүүлэх
            _title(),

            SizedBox(height: 10.0),

            /// 1/5 Иргэний үнэмлэхийн урд тал
            _stepNumber(),

//            SizedBox(height: 10.0),
//
//            /// Иргэний үнэмлэхний урд талын зургыг дарж оруулна уу.
//            _hint(),

            SizedBox(height: 20.0),

            /// Camera
            _camera(context),

            SizedBox(height: 20.0),

            /// Гэрлийн тусгал жигд туссан газар зураг авах
            _hint2(),

            SizedBox(height: 5.0),

            /// Дэлгэцнээс зураг дарахгүй байх
            _hint3(),

            SizedBox(height: 30.0),
          ],
        ),
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
              AssetName.circle_step1,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                lbl(
                  globals.text.frontId().toUpperCase(),
                  style: lblStyle.Medium,
                  color: AppColors.lblBlue,
                  fontWeight: FontWeight.bold,
                ),
                lbl(
                  '${globals.text.nextt()}: ${globals.text.backId().toUpperCase()}',
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

  _hint() {
    return lbl(
      globals.text.hintFrontId(),
      textAlign: TextAlign.center,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 0.0, right: 40.0, bottom: 0.0, left: 40.0),
      color: AppColors.lblDark,
      fontSize: 16.0,
      maxLines: 3,
    );
  }

  _camera(BuildContext context) {
    return Expanded(
      child: (!_isCameraReady || _controllerCamera1 == null || !(_controllerCamera1?.value?.isInitialized ?? false))
          ? Container(color: AppColors.bgGrey)
          : Stack(
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: <Widget>[
                /// Camera
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  child: AspectRatio(
                    aspectRatio: _controllerCamera1?.value.aspectRatio,
                    child: CameraPreview(_controllerCamera1),
                  ),
                ),

                /// ID card border
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 30.0,
                          left: 20.0,
                          bottom: 20.0,
                          right: 20.0,
                        ),
                        child: Image.asset(
                          AssetName.id_card_front,
                          colorBlendMode: BlendMode.modulate,
                        ),
                      ),
                    ),
                    SizedBox(height: 100.0),
                  ],
                ),

                /// Flashlight
                Positioned(
                  bottom: 25.0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(right: 140.0),
                      child: IconButton(
                        icon: Image.asset(
                          _isFlashlightOn ? AssetName.flash_on : AssetName.flash_off,
                          height: 22.0,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _onPressedFlashlight();
                        },
                      ),
                    ),
                  ),
                ),

                /// Capture button
                Positioned(
                  bottom: 20.0,
                  width: 70.0,
                  height: 60.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_enhance,
                      color: Colors.white,
                      size: 45.0,
                    ),
                    onPressed: () {
                      _onPressedCapture();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  _hint2() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50),
      child: Row(
        children: <Widget>[
          Container(
            width: 22.0,
            child: Image.asset(
              AssetName.sun,
//                        height: 22.0,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          SizedBox(width: 10.0),
          Flexible(
            child: lbl(
              globals.text.hintCamera(),
              maxLines: 2,
              color: AppColors.lblGrey,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  _hint3() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50),
      child: Row(
        children: <Widget>[
          Container(
            width: 22.0,
            child: Image.asset(
              AssetName.monitor,
//                          height: 22.0,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          SizedBox(width: 10.0),
          Flexible(
            child: lbl(
              globals.text.hintCamera2(),
              maxLines: 2,
              color: AppColors.lblGrey,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  void _initCamera() async {
    try {
      _cameraList = await availableCameras();
      if (_cameraList != null) {
        var index = 0;

        for (var i = 0; i < _cameraList.length; i++) {
          if (_cameraList[i].lensDirection == CameraLensDirection.back) {
            index = i;
            break;
          }
        }

        _controllerCamera1 = new CameraController(_cameraList[index], ResolutionPreset.high, enableAudio: true);
        await _controllerCamera1?.initialize();
      }
    } on CameraException catch (_) {
      setState(() {
        _isCameraReady = false;
      });
    }
    setState(() {
      _isCameraReady = true;
    });
  }

  _onPressedFlashlight() {
    setState(() {
      _isFlashlightOn = !_isFlashlightOn;
      _controllerCamera1?.setFlash(_isFlashlightOn);
    });
  }

  void _onPressedCapture() async {
    try {
      if (!_controllerCamera1.value.isInitialized) {
        return;
      }

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.jpg',
      );
      await _controllerCamera1.takePicture(path);
      _file = File(path);

      _bloc.add(IdFrontUploadImage(file: _file));
    } catch (e) {
      print(e);
    }
  }

  _showLoadingDlg() {
    Animation<double> _animation;

    double _height = 0.0;

    _controllerLoading1 = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween(begin: 0.0, end: 70.0).animate(_controllerLoading1)
      ..addListener(() {
        setState(() {
          _height = 0.0 + _animation.value;
        });
      });

    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (_) => MainDialog(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        child: Container(
          height: 400,
          width: MediaQuery.of(this.context).size.width - 40.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: AppColors.bgBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.more_horiz, size: 55.0, color: AppColors.iconWhite),
              ),

              SizedBox(height: 30.0),

              lbl(globals.text.pleaseWait().toUpperCase(), alignment: Alignment.center, textAlign: TextAlign.center, color: AppColors.lblDark, fontWeight: FontWeight.w500, fontSize: 16.0),

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

              Container(
                height: 128.0,
                child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                  Container(
                    height: 128.0,
                    width: 222.0,
                    decoration: new BoxDecoration(
                      color: Color(0XFFC88A0B),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(8.0),
                        topRight: const Radius.circular(8.0),
                        bottomLeft: const Radius.circular(8.0),
                        bottomRight: const Radius.circular(8.0),
                      ),
                    ),
                    child: Container(),
                  ),
                  new Positioned(
                    bottom: 0.0,
                    child: new AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget child) {
                        return new Container(
                          height: _height,
                          width: 222.0,
                          decoration: new BoxDecoration(
                            color: Color(0XFFFFAB00),
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(8.0),
                              topRight: const Radius.circular(8.0),
                              bottomLeft: const Radius.circular(8.0),
                              bottomRight: const Radius.circular(8.0),
                            ),
                          ),
                          child: Container(),
                        );
                      },
                    ),
                  ),
                ]),
              ),

              SizedBox(height: 15.0),

              lbl(globals.text.loading(), alignment: Alignment.center, textAlign: TextAlign.center, color: AppColors.lblGrey, fontWeight: FontWeight.normal, fontSize: 12.0),

              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );

    _controllerLoading1.repeat(reverse: true);
  }

  _showConfirmDlg(IdFrontResponse idFrontResponse) {
    _controllerLastName?.text = idFrontResponse.lastName;
    _controllerFirstName?.text = idFrontResponse.firstName;
    _controllerRegNo?.text = idFrontResponse.regNo;

    showDialog(
      context: this.context,
      child: ResponsiveDialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),

              /// Success icon
              Image.asset(
                AssetName.success_blue,
                height: 74.0,
                colorBlendMode: BlendMode.modulate,
              ),

              SizedBox(height: 30.0),

              /// ТАНЫ МЭДЭЭЛЭЛ
              lbl(globals.text.yourInfo().toUpperCase(), alignment: Alignment.center, textAlign: TextAlign.center, color: AppColors.lblDark, fontWeight: FontWeight.w500, maxLines: 2, fontSize: 16.0),

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

              /// Овог
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  lbl('${globals.text.lastName()}: ', margin: EdgeInsets.only(right: 5.0), alignment: Alignment.centerLeft, textAlign: TextAlign.start, color: AppColors.lblDark, fontWeight: FontWeight.normal, fontSize: 16.0),
                  Flexible(
                    child: TextFormField(
                      controller: _controllerLastName,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.athensGray),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0),

              /// Нэр
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  lbl('${globals.text.firstName()}: ', margin: EdgeInsets.only(right: 5.0), alignment: Alignment.centerLeft, textAlign: TextAlign.start, color: AppColors.lblDark, fontWeight: FontWeight.normal, fontSize: 16.0),
                  Flexible(
                    child: TextFormField(
                      controller: _controllerFirstName,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.athensGray),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0),

              /// РДугаар
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  lbl('${globals.text.regNo()}: ', margin: EdgeInsets.only(right: 5.0), alignment: Alignment.centerLeft, textAlign: TextAlign.start, color: AppColors.lblDark, fontWeight: FontWeight.normal, fontSize: 16.0),
                  Flexible(
                    child: TextFormField(
                      controller: _controllerRegNo,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.athensGray),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /// ДАХИН АВАХ
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: globals.text.again(),
                      context: this.context,
                      margin: EdgeInsets.only(right: 5.0),
                      color: AppColors.bgBlue,
                      disabledColor: AppColors.btnBlue,
                      textColor: AppColors.lblWhite,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        Navigator.pop(this.context);
                      },
                    ),
                  ),

                  /// ҮРГЭЛЖЛҮҮЛЭХ
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: globals.text.contin(),
                      context: this.context,
                      margin: EdgeInsets.only(left: 5.0),
                      color: AppColors.bgBlue,
                      disabledColor: AppColors.btnBlue,
                      textColor: AppColors.lblWhite,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        // Validation
                        if (Func.isEmpty(_controllerLastName?.text) || Func.isEmpty(_controllerFirstName?.text) || Func.isEmpty(_controllerRegNo?.text)) {
                          return;
                        }

                        // Confirm
                        idFrontResponse.lastName = _controllerLastName?.text;
                        idFrontResponse.firstName = _controllerFirstName?.text;
                        idFrontResponse.regNo = _controllerRegNo?.text;
                        _bloc.add(IdFrontConfirm(idFrontResponse: idFrontResponse));

                        Navigator.pop(this.context); //dlg
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  _onBackPressed(BuildContext context) {
    _controllerCamera1?.dispose();

    if (widget.fromRoute == 'new_user_route') {
      Navigator.pushReplacement(context, FadeRouteBuilder(route: LoginRoute()));
    } else {
      Navigator.pop(context);
    }
  }
}
