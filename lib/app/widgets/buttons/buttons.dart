import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/labels.dart';

//Widget TextButton({
//  @required BuildContext context,
//  @required Function onPressed,
//  @required String text,
//  Color textColor,
//  double fontSize,
//  EdgeInsets padding,
//  bool enabledRippleEffect = true,
//  FontWeight fontWeight,
//  Alignment alignment,
//}) {
//  /// onClick event агуулсан текст
//  return InkWell(
//    onTap: onPressed,
//    highlightColor: enabledRippleEffect ? null : Colors.transparent,
//    splashColor: enabledRippleEffect ? null : Colors.transparent,
//    child: Container(
//      alignment: alignment ?? Alignment.center,
//      padding: padding ?? EdgeInsets.all(0.0),
//      child: lbl(
//        text,
//        color: textColor,
//        fontSize: fontSize,
//        fontWeight: fontWeight,
//        alignment: alignment,
//      ),
//    ),
//  );
//}

// ignore: non_constant_identifier_names
Widget CustomButton({
  BuildContext context,
  GlobalKey key,
  double width,
  double height,
  EdgeInsets margin,
  MainAxisAlignment alignment,
  Image image,
  Icon icon,
  String text,
  Function onPressed,
  Color color,
  Color disabledColor,
  Color textColor,
  Color disabledTextColor,
  double fontSize,
  FontWeight fontWeight,
  double borderRadius,
  double elevation,
  bool isUppercase = false,
}) {
  return Container(
    width: width ?? double.infinity,
    height: height ?? AppHelper.heightBtn,
    margin: margin ?? EdgeInsets.zero,
    child: RaisedButton(
//      key: key,
      elevation: elevation ?? 0.0,
      color: color ?? AppColors.btnBlue,
      disabledColor: disabledColor ?? AppColors.btnDisabled,
      padding: EdgeInsets.all(0),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.center,
        children: <Widget>[
          /// Asset Image
          image ?? Container(),
          image != null ? SizedBox(width: 5.0) : Container(),

          /// Icon
          icon ?? Container(),
          icon != null ? SizedBox(width: 5.0) : Container(),

          /// tText
          text != null
              ? lbl(
                  isUppercase ? text.toUpperCase() : text,
                  color: onPressed != null ? (textColor ?? AppColors.lblWhite) : (disabledTextColor ?? AppColors.lblWhite),
                  fontSize: fontSize ?? AppHelper.fontSizeMedium,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                )
              : Container(),

          image != null ? SizedBox(width: 10.0) : Container(),
          icon != null ? SizedBox(width: 10.0) : Container(),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? AppHelper.borderRadiusBtn),
      ),
    ),
  );
}

Widget CustomButton2({
  BuildContext context,
  GlobalKey key,
  double width,
  double height,
  EdgeInsets margin,
  MainAxisAlignment alignment,
  Image image,
  Icon icon,
  String text,
  Function onPressed,
  Color color,
  Color disabledColor,
  Color textColor,
  Color disabledTextColor,
  double fontSize,
  FontWeight fontWeight,
  double borderRadius,
  double elevation,
  bool isUppercase = false,
}) {
  return ButtonTheme(
    minWidth: 70.0,
    height: height ?? AppHelper.heightBtn,
    child: Container(
      height: height ?? AppHelper.heightBtn,
      margin: margin ?? EdgeInsets.zero,
      child: RaisedButton(
//      key: key,
        elevation: elevation ?? 0.0,
        color: color ?? AppColors.btnBlue,
        disabledColor: disabledColor ?? AppColors.btnDisabled,
        padding: EdgeInsets.all(0),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: alignment ?? MainAxisAlignment.center,
          children: <Widget>[
            /// Asset Image

            icon,
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppHelper.borderRadiusBtn),
        ),
      ),
    ),
  );
}

/// onClick event агуулсан текст
class TextButton extends StatelessWidget {
  TextButton({
    @required this.onPressed,
    @required this.text,
    this.textColor,
    this.fontSize,
    this.padding,
    this.enabledRippleEffect = true,
    this.fontWeight,
    this.alignment,
  });

  final Function onPressed;
  final String text;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;
  final bool enabledRippleEffect;
  final FontWeight fontWeight;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      highlightColor: enabledRippleEffect ? null : Colors.transparent,
      splashColor: enabledRippleEffect ? null : Colors.transparent,
      child: Container(
        alignment: alignment ?? Alignment.center,
        padding: padding ?? EdgeInsets.all(0.0),
        child: lbl(
          text,
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          alignment: alignment,
        ),
      ),
    );
  }
}

Widget btnCircle({
  @required BuildContext context,
  @required Function onPressed,
  IconData icon,
  String img,
  String text,
  Color iconColor,
  Color buttonColor,
  Color disabledColor,
  double buttonPadding = 13.0,
  double iconSize = 22.0,
  double elevation = 0,
  EdgeInsets margin,
}) {
  return Container(
    margin: margin ?? EdgeInsets.all(0.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          minWidth: 40,
          onPressed: onPressed,
          child: icon != null
              ? Icon(
                  icon,
                  size: iconSize,
                  color: iconColor ?? Colors.white,
                )
              : Image.asset(
                  img,
                  color: Colors.white,
                  width: 20,
                ),
          shape: new CircleBorder(),
          elevation: elevation,
          color: buttonColor ?? Colors.white,
          disabledColor: disabledColor ?? Colors.white,
          padding: EdgeInsets.all(buttonPadding),
        ),
        SizedBox(height: 5),
        text != null
            ? lbl(
                text,
                fontSize: 13.0,
                textAlign: TextAlign.center,
                alignment: Alignment.center,
              )
            : Container(),
      ],
    ),
  );
}

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({
    Key key,
    this.icon,
    this.color,
    this.onPressed,
    this.padding,
  }) : super(key: key);

  final Icon icon;
  final Color color;
  final Function onPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(padding: padding ?? EdgeInsets.zero, child: icon),
    );
  }
}
