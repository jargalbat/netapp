import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/widgets/language_widget.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/modules/sign_up/step2_id_back/id_back_screen.dart';
import 'package:netware/modules/sign_up/step4_mobile/sign_up_mobile_screen.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../sign_up_helper.dart';
import 'bloc/id_selfie_bloc.dart';
import 'bloc/id_selfie_event.dart';
import 'bloc/id_selfie_state.dart';

class IdSelfieScreen extends StatefulWidget {
  IdSelfieScreen();

  @override
  _IdSelfieScreenState createState() => _IdSelfieScreenState();
}

class _IdSelfieScreenState extends State<IdSelfieScreen> with TickerProviderStateMixin {
//  final _scaffoldKey3 = new GlobalKey<ScaffoldState>();
  Localization _loc;
  double _paddingHorizontal = 20.0;
  IdSelfieBloc _bloc;

  /// Camera
  File _file;
  CameraController _controllerCamera3;
  List<CameraDescription> cameras;
  bool _isCameraReady = false;

  /// Loading dialog
  AnimationController _controllerLoading3;

  @override
  void initState() {
    super.initState();
    _bloc = new IdSelfieBloc();
    _initCamera();
  }

  @override
  void dispose() {
//    _controllerCamera3?.dispose();
    _controllerLoading3?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loc = globals.text;

    return BlocProvider<IdSelfieBloc>(
      create: (context) => _bloc,
      child: BlocListener<IdSelfieBloc, IdSelfieState>(
        listener: _blocListener,
        child: BlocBuilder<IdSelfieBloc, IdSelfieState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, IdSelfieState state) {
    if (state is IdSelfieLoading) {
      _showLoadingDlg();
    } else if (state is IdSelfieSuccess) {
      Navigator.pop(context); //dlg
      Navigator.pop(context); //this
      Navigator.push(context, FadeRouteBuilder(route: SignUpMobileScreen()));
    } else if (state is IdSelfieFailed) {
      Navigator.pop(context);
      SignUpHelper.showErrorDlg(
        context: context,
        titleText: '${globals.text.warning()}!',
        bodyText: !Func.isEmpty(state.resDesc) ? state.resDesc : globals.text.badPic(),
        btnText: globals.text.again(),
        onPressedBtn: () {
          Navigator.pop(context);
        },
      );
    }
  }

  Widget _blocBuilder(BuildContext context, IdSelfieState state) {
    _loc = globals.text;

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed(context);
        return Future.value(false);
      },
      child: Scaffold(
//        key: _scaffoldKey3,
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
        body: Container(
          child: Column(
            children: <Widget>[
              /// Бүртгүүлэх
              _title(),

              SizedBox(height: 10.0),

              /// 3/5 Иргэний үнэмлэх уншуулах
              _stepNumber(),

//              SizedBox(height: 10.0),
//
//              /// Иргэний үнэмлэхээ хажуудаа барьж байгаад сэлфи хийж оруулна уу.
//              _hint(),

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
      ),
    );
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
              AssetName.circle_step3,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                lbl(
                  globals.text.selfie().toUpperCase(),
                  style: lblStyle.Medium,
                  color: AppColors.lblBlue,
                ),
                lbl(
                  '${globals.text.nextt()}: ${globals.text.enterPhoneNumber().toUpperCase()}',
                  fontSize: 12.0,
                  color: AppColors.lblGrey,
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
      'Иргэний үнэмлэхээ хажуудаа барьж байгаад сэлфи хийж оруулна уу.',
      textAlign: TextAlign.center,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 0.0, right: 40.0, bottom: 0.0, left: 40.0),
      color: AppColors.lblDark,
      fontSize: 16.0,
      maxLines: 3,
    );
  }

  _camera(BuildContext context) {
    var heightCamera = MediaQuery.of(context).size.height;
    var widthCamera = MediaQuery.of(context).size.width - 40.0;

    return Expanded(
      child: (!_isCameraReady || _controllerCamera3 == null || !(_controllerCamera3.value?.isInitialized ?? false))
          ? Container(color: AppColors.bgGrey)
          : Stack(
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
//                  width: widthCamera,
//                  height: heightCamera,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                    child: AspectRatio(
                      aspectRatio: _controllerCamera3.value.aspectRatio,
                      child: CameraPreview(_controllerCamera3),
                    ),

//                    OverflowBox(
//                      alignment: Alignment.center,
//                      child: AspectRatio(
//                        aspectRatio: _controller.value.aspectRatio,
//                        child: CameraPreview(_controller),
//                      ),

//                      FittedBox(
//                        fit: BoxFit.fitHeight,
//                        child: Container(
//                          width: widthCamera,
//                          height: heightCamera / _controller.value.aspectRatio,
//                          child: CameraPreview(_controller), // this is my CameraPreview
//                        ),
//                      ),
//                    ),
                  ),
                ),

//                Container(
//                  alignment: Alignment.center,
//                  decoration: BoxDecoration(
//                    color: AppColors.bgGrey,
//                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                  ),
//                  child: AspectRatio(
//                    aspectRatio: _controller.value.aspectRatio,
//                    child: CameraPreview(_controller),
//                  ),
//                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /// ID card border
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 30.0,
                          left: 20.0,
                          bottom: 20.0,
                          right: 20.0,
                        ),
                        child: Image.asset(
                          AssetName.id_card_selfie,
                          width: MediaQuery.of(context).size.width / 2,
                          colorBlendMode: BlendMode.modulate,
                        ),
                      ),
                    ),

                    /// Capture button
                    IconButton(
                      padding: EdgeInsets.only(bottom: 50.0),
                      icon: Icon(
                        Icons.camera_enhance,
                        color: Colors.white,
                        size: 50.0,
                      ),
                      onPressed: () {
                        _capture();
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void _initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null) {
        var index = 0;

        for (var i = 0; i < cameras.length; i++) {
          if (cameras[i].lensDirection == CameraLensDirection.front) {
            index = i;
            break;
          }
        }

        _controllerCamera3 = new CameraController(cameras[index], ResolutionPreset.high, enableAudio: true);
        await _controllerCamera3.initialize();
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

  void _capture() async {
    try {
      if (!_controllerCamera3.value.isInitialized) {
        return;
      }

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.jpg',
      );
      await _controllerCamera3.takePicture(path);
      _file = File(path);

      _bloc.add(IdSelfieUploadImage(
        file: _file,
        userKey: SignUpHelper.userKey,
      ));
    } catch (e) {
      print(e);
    }
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

  _showLoadingDlg() {
    Animation<double> _animation;

    double _height = 0.0;

    _controllerLoading3 = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween(begin: 0.0, end: 70.0).animate(_controllerLoading3)
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

              lbl(globals.text.pleaseWait(),
                  alignment: Alignment.center, textAlign: TextAlign.center, color: AppColors.lblDark, fontWeight: FontWeight.w500, fontSize: 16.0),

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
//                        child: new CustomPaint(
//                          painter: new Sky(222.0, 128.0 * _animation.value),
//                        ),
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

              lbl(globals.text.loading(),
                  alignment: Alignment.center, textAlign: TextAlign.center, color: AppColors.lblGrey, fontWeight: FontWeight.normal, fontSize: 12.0),

              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );

    _controllerLoading3.repeat(reverse: true);
  }

  _onBackPressed(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(this.context, FadeRouteBuilder(route: IdBackScreen()));
  }
}
