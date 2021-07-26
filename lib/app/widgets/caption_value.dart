import 'package:flutter/material.dart';
import 'package:netware/app/widgets/labels.dart';

class CaptionValue extends StatelessWidget {
  CaptionValue({
    Key key,
    this.margin = const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
    this.padding = EdgeInsets.zero,
    this.captionWidget,
    this.valueWidget,
    this.caption,
    this.captionColor,
    this.value,
  }) : super(key: key);

  /// UI
  final EdgeInsets margin;
  final EdgeInsets padding;

  /// Widgets
  final Widget captionWidget;
  final Widget valueWidget;

  /// Strings
  final String caption;
  final Color captionColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Caption
          captionWidget ?? lbl(caption, style: lblStyle.Medium, alignment: Alignment.centerLeft, color: captionColor),

          /// Value
          Flexible(
            child: valueWidget ?? lbl(value, style: lblStyle.Medium, fontWeight: FontWeight.w500, alignment: Alignment.centerRight),
          ),
        ],
      ),
    );
  }
}
