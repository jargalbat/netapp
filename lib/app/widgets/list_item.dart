import 'package:flutter/material.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/labels.dart';

class MenuListItem extends StatelessWidget {
  const MenuListItem({
    Key key,
    this.text,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.leadingIcon,
    this.followingIcon,
    this.leadingImg,
    this.onPressed,
    this.child,
    this.decoration,
  }) : super(key: key);

  final String text;
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color textColor;
  final Icon leadingIcon;
  final Widget followingIcon;
  final String leadingImg;
  final Function onPressed;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      //highlightColor: null, //Colors.transparent,
      //splashColor: null, //Colors.transparent, //enabledRippleEffect ? null :
      child: Container(
        margin: margin ?? EdgeInsets.all(0.0),
        padding: padding ?? EdgeInsets.only(top: 15.0, right: 10.0, bottom: 15.0, left: 10.0),
        decoration: decoration,
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (Func.isNotEmpty(leadingImg))
                  Container(
                    height: 34.0,
                    width: 34.0,
                    padding: EdgeInsets.all(7.0),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.bgGrey),
                    child: Image.asset(
                      leadingImg,
                    ),
                  ),

                if (Func.isNotEmpty(leadingImg))
                  SizedBox(width: 10.0),

                /// Text
                lbl(
                  text ?? '',
                  fontSize: 16.0,
                  color: textColor ?? AppColors.lblDark,
                  alignment: Alignment.centerLeft,
                  textAlign: TextAlign.left,
                ),

                new Spacer(),

                /// Icon
                followingIcon ??
                    Image.asset(
                      AssetName.forward_arrow,
                      color: AppColors.iconMirage,
                      height: 20.0,
                      width: 20.0,
                    )
//                    Icon(
//                      Icons.arrow_forward_ios,
//                      color: AppColors.iconMirage,
//                      size: 20.0,
//                    )
              ],
            ),
      ),
    );
  }
}

Widget listItemUserGuide({
  EdgeInsets margin,
  EdgeInsets padding,
  Color backgroundColor,
  @required String text,
  Color textColor,
  @required Widget leadingIcon,
  Icon icon,
  Function onPressed,
  Widget child,
}) {
  return InkWell(
    onTap: onPressed,
    //highlightColor: null, //Colors.transparent,
    //splashColor: null, //Colors.transparent, //enabledRippleEffect ? null :
    child: Container(
      color: AppColors.bgGreyLight,
      margin: margin ?? EdgeInsets.all(0.0),
      padding: padding ??
          EdgeInsets.only(
            top: 15.0,
            right: 10.0,
            bottom: 15.0,
            left: 10.0,
          ),
      child: child ??
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /// Text
              Row(
                children: <Widget>[
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      color: AppColors.bgGrey,
                      shape: BoxShape.circle,
                    ),
                    child: leadingIcon,
                  ),
                  lbl(text ?? '', fontSize: 16.0, color: textColor ?? AppColors.lblDark),
                ],
              ),

              /// Icon
              icon ??
                  Icon(
                    Icons.bookmark,
                    color: AppColors.iconRegentGrey,
                  ),
            ],
          ),
    ),
  );
}
