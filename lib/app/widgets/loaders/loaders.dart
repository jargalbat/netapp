import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'color_loader_4.dart';
import 'dot_type.dart';

// ignore: non_constant_identifier_names
Widget BlurLoadingContainer({
  @required bool loading,
  Widget child,
}) {
  var widgetList = List<Widget>();
  if (child != null) widgetList.add(child);

  if (loading) {
    Widget loadingContainer = Container(
      color: Colors.black12.withOpacity(0.3),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 1.0,
          sigmaY: 1.0,
        ),
        child: Center(
          child: Container(
            child: Container(
              height: AppHelper.loaderSize,
              width: AppHelper.loaderSize,
              child: CircularProgressIndicator(),

//              ColorLoader4(
//                dotOneColor: Colors.lightBlueAccent,
//                dotTwoColor: Colors.lightBlue,
//                dotThreeColor: Colors.blue,
//                dotType: DotType.square,
//                duration: Duration(milliseconds: 1200),
//              ),
            ),
          ),
        ),
      ),
    );

    widgetList.add(loadingContainer);
  }

  return Stack(children: widgetList);
}

// ignore: non_constant_identifier_names
Widget LoadingContainer({
  @required bool loading,
  Widget child,
  double height,
}) {
  var widgetList = List<Widget>();
  if (child != null) widgetList.add(child);

  if (loading) {
    Widget loadingContainer = Center(
      child: Container(
//        color: Colors.black12.withOpacity(0.5),
        child: Container(
          height: AppHelper.loaderSize,
          width: AppHelper.loaderSize,
          child: CircularProgressIndicator(),

//          ColorLoader4(
//            dotOneColor: Colors.lightBlueAccent,
//            dotTwoColor: Colors.lightBlue,
//            dotThreeColor: Colors.blue,
//            dotType: DotType.square,
//            duration: Duration(milliseconds: 1200),
//          ),
        ),
      ),
    );

    // Height
    if (height != null) {
      loadingContainer = Container(height: height, child: loadingContainer);
    }

//    widgetList.add(Positioned.fill(child: loadingContainer));
    widgetList.add(loadingContainer);
  }

  return Stack(children: widgetList);
}
