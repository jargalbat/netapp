import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:path/path.dart' as package_path;
import 'package:path_provider/path_provider.dart' as path_provider;

class CameraRoute extends StatefulWidget {
  const CameraRoute({Key key, this.callBack}) : super(key: key);

  final Function(File) callBack;

  @override
  _CameraRouteState createState() => _CameraRouteState();
}

class _CameraRouteState extends State<CameraRoute> {
  /// Camera
  File _profilePicFile;
  CameraController _cameraController;
  List<CameraDescription> _cameraList;
  bool _isCameraReady = false;
  bool _isFront = true; // Front, back camera

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          child: (!_isCameraReady || _cameraController == null || !(_cameraController?.value?.isInitialized ?? false))
              ? Container(color: AppColors.bgGrey)
              : Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    /// Camera
                    Transform.scale(
                      scale: _cameraController.value.aspectRatio / deviceRatio,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _cameraController.value.aspectRatio,
                          child: CameraPreview(_cameraController),
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

                    /// Switch camera button
                    Positioned(
                      right: 20.0,
                      bottom: 20.0,
                      width: 70.0,
                      height: 60.0,
                      child: IconButton(
                        icon: Icon(
                          Icons.switch_camera,
                          color: Colors.white,
                          size: 45.0,
                        ),
                        onPressed: () {
                          _onPressedSwitchCamera();
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _initCamera() async {
    try {
      _cameraList = await availableCameras();
      if (_cameraList != null) {
        var index = 0;

        for (var i = 0; i < _cameraList.length; i++) {
          if (_isFront) {
            if (_cameraList[i].lensDirection == CameraLensDirection.front) {
              index = i;
              break;
            }
          } else {
            if (_cameraList[i].lensDirection == CameraLensDirection.back) {
              index = i;
              break;
            }
          }
        }

        _cameraController = new CameraController(_cameraList[index], ResolutionPreset.high, enableAudio: true);
        await _cameraController?.initialize();
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

  void _onPressedCapture() async {
    try {
      if (!_cameraController.value.isInitialized) {
        return;
      }

      final filePath = package_path.join(
        (await path_provider.getTemporaryDirectory()).path,
        '${DateTime.now()}.jpg',
      );
      await _cameraController.takePicture(filePath);
      _profilePicFile = File(filePath);
      widget.callBack(_profilePicFile);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  void _onPressedSwitchCamera() async {
    _isFront = !_isFront;
    _initCamera();
  }

  _onBackPressed() {
//    _cameraController?.dispose();
    Navigator.pop(context);
  }
}
