import 'package:flutter/material.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/widgets/language_widget.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/labels.dart';

// ignore: non_constant_identifier_names
Widget AppBarEmpty({BuildContext context, Brightness brightness, Color backgroundColor}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(0.0), // here the desired height
    child: AppBar(
      backgroundColor: backgroundColor,
      brightness: brightness,
      leading: Container(),
      elevation: 0.0,
      actions: <Widget>[],
    ),
  );
}

// ignore: non_constant_identifier_names
Widget AppBarSimple({
  @required BuildContext context,
  Function onPressed,
  Icon icon,
  bool hasBackArrow = true,
  Color backgroundColor,
  Color iconColor,
  List<Widget> actions,
  Brightness brightness,
  PreferredSizeWidget bottom,
}) {
  return AppBar(
    brightness: brightness,
    backgroundColor: backgroundColor ?? AppColors.bgGrey,
    leading: hasBackArrow
        ? InkWell(
            child: Container(
              height: 20.0,
              padding: EdgeInsets.fromLTRB(5.0, 17.0, 17.0, 17.0),
              child: Image.asset(
                AssetName.back_arrow,
                height: 20.0,
                color: AppColors.iconMirage,
              ),
            ),
            onTap: onPressed,
          )
        : ButtonIcon(
            icon: icon ??
                Icon(
                  Icons.arrow_back_ios,
                  color: iconColor ?? AppColors.iconMirage,
                  size: 20.0,
                ),
            onPressed: onPressed,
          ),
    elevation: 0.0,
    actions: actions,
    bottom: bottom,
  );
}
//
//Widget appBar2(BuildContext context) {
//  return Stack(
//    children: <Widget>[
//      Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          IconButton(
//            icon: Icon(Icons.arrow_back, color: AppColors.iconWhite),
//            onPressed: () async {
//              Navigator.pop(context);
//            },
//          ),
//          btnLang(context: context, color: Colors.white),
//        ],
//      ),
//      Container(
//        padding: EdgeInsets.only(top: 10.0),
//        alignment: Alignment.topCenter,
//        child: Image.asset(
//          ImageAsset.net_capital,
//          height: 100.0,
//          colorBlendMode: BlendMode.modulate,
//        ),
//      ),
//    ],
//  );
//}
//
//Widget appBar3({
//  @required BuildContext context,
//  @required Function onPressed,
//  @required String backText,
//  @required String nextText,
//  @required String title,
//}) {
//  return Stack(
//    children: <Widget>[
//      Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          GestureDetector(
//            onTap: () async {
//              Navigator.pop(context);
//            },
//            child: Container(
//              padding: EdgeInsets.only(top: 10.0, right: 10.0),
//              child: Row(
//                children: <Widget>[
//                  Icon(Icons.arrow_back_ios, color: AppColors.iconWhite),
//                  lbl(
//                    backText,
//                    color: AppColors.txt2,
//                    fontSize: 17.0,
//                  ),
//                ],
//              ),
//            ),
//          ),
//          Container(
//            padding: EdgeInsets.only(top: 10.0, right: 10.0),
//            child: btnText(
//              context: context,
//              onPressed: onPressed,
//              text: nextText,
//              textColor: AppColors.txt2,
//              fontSize: 17.0,
//              padding: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 5.0, left: 5.0),
//            ),
//          ),
//        ],
//      ),
//      Container(
//        padding: EdgeInsets.only(top: 12.0),
//        alignment: Alignment.topCenter,
//        child: lbl(
//          title,
//          color: AppColors.lblBlack,
//          alignment: Alignment.center,
//          fontSize: 17.0,
//          fontWeight: FontWeight.w500,
//        ),
//      ),
//    ],
//  );
//}
