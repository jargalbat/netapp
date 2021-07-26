import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';

// ignore: non_constant_identifier_names
//todo fix
Widget CustomCard({
  @required Widget child,
  EdgeInsets margin,
  EdgeInsets padding,
  Color color,
  Gradient gradient,
  double borderRadius = AppHelper.borderRadiusCard,
}) {
  return new Container(
    margin: margin ?? EdgeInsets.all(0.0),
    padding: padding ?? EdgeInsets.all(0.0),
    decoration: BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
//      border: Border.all(
//        color: Colors.white,
//      ),
      color: color ?? Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.1),
          blurRadius: 21.0,
          offset: Offset(0.0, 7.0),
        ),
      ],
    ),
    child: child,
  );
}
