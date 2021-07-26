import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/themes/app_colors.dart';

/// LABEL TYPE
enum lblStyle {
  Caption,
  Normal,
  Medium,
  Headline5, // Subtitle
  Headline4, // Title
}

/// BASE LABEL
// ignore: must_be_immutable, camel_case_types
class lbl extends StatelessWidget {
  lbl(
    this.text, {
    this.style = lblStyle.Normal,
    this.color,
    this.bgColor,
    this.fontSize,
    this.fontWeight,
    this.softWrap,
    this.maxLines,
    this.lineSpace,
    this.textAlign,
    this.overflow,
    this.padding,
    this.margin,
    this.alignment,
  });

  final String text;
  final lblStyle style;

  /// Text arguments
  final Color color;
  final Color bgColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool softWrap;
  final int maxLines;
  final double lineSpace;
  TextAlign textAlign;
  final TextOverflow overflow;

  /// Box constraint arguments
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    if (alignment == Alignment.center) this.textAlign = TextAlign.center;

    return Container(
      margin: margin ?? EdgeInsets.all(0.0),
      padding: padding ?? EdgeInsets.all(0.0),
      alignment: alignment ?? Alignment.centerLeft,
      child: Text(
        text ?? '',
        softWrap: softWrap ?? true,
        maxLines: maxLines ?? 1,
        textAlign: textAlign ?? TextAlign.start,
        overflow: overflow ?? TextOverflow.ellipsis,
        style: TextStyle(
          color: color ?? _color(),
          fontSize: fontSize ?? _fontSize(),
          fontWeight: fontWeight ?? _fontWeight(),
          height: lineSpace,
          backgroundColor: bgColor,
        ),
      ),
    );
  }

  Color _color() {
    switch (style) {
      case lblStyle.Headline4:
        return AppColors.lblDark;

      case lblStyle.Headline5:
      case lblStyle.Caption:
        return AppColors.lblBlue;

      case lblStyle.Medium:
      case lblStyle.Normal:
      default:
        return AppColors.lblDark;
    }
  }

  FontWeight _fontWeight() {
    switch (style) {
      case lblStyle.Headline4:
        return FontWeight.w800;

      case lblStyle.Headline5:
        return FontWeight.w500;

      case lblStyle.Medium:
      case lblStyle.Normal:
      case lblStyle.Caption:
      default:
        return FontWeight.normal;
    }
  }

  double _fontSize() {
    switch (style) {
      case lblStyle.Headline4:
        return AppHelper.fontSizeHeadline4;
        break;

      case lblStyle.Headline5:
        return AppHelper.fontSizeHeadline5;
        break;

      case lblStyle.Medium:
        return AppHelper.fontSizeMedium;
        break;

      case lblStyle.Caption:
        return AppHelper.fontSizeCaption;
        break;

      case lblStyle.Normal:
      default:
        return AppHelper.fontSizeNormal;
        break;
    }
  }
}
