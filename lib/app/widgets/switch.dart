import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/labels.dart';

// ignore: must_be_immutable
class CustomSwitch extends StatefulWidget {
  CustomSwitch({
    this.value = false,
    this.text = "",
    this.textColor,
    @required this.onChanged,
    this.transformScale = 1.0,
  });

  final Function(bool) onChanged;
  bool value;
  final String text;
  final Color textColor;
  final double transformScale;

  /// State
  @override
  State<StatefulWidget> createState() => _CustomSwitchState();
}

// ignore: camel_case_types
class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    Widget w;

    if (!Func.isEmpty(widget.text)) {
      if (Platform.isIOS) {
        /// iOS with text
        w = MergeSemantics(
          child: ListTile(
            title: lbl(widget.text ?? ""),
            trailing: Transform.scale(
              scale: widget.transformScale,
              child: CupertinoSwitch(
                value: widget.value,
                onChanged: (val) => _onChanged(val),
                activeColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
        );
      } else {
        /// Android with text
        w = MergeSemantics(
          child: ListTile(
            title: lbl(widget.text ?? ""),
            trailing: Transform.scale(
              alignment: Alignment.centerRight,
              scale: widget.transformScale,
              child: Switch(
                value: widget.value,
                onChanged: (val) => _onChanged(val),
                activeColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
        );
      }
    } else {
      if (Platform.isIOS) {
        /// iOS no text
        w = Transform.scale(
          scale: widget.transformScale,
          child: CupertinoSwitch(
            value: widget.value,
            onChanged: (val) => _onChanged(val),
            activeColor: Theme
                .of(context)
                .primaryColor,
          ),
        );
      } else {
        /// Android no text
        w = Transform.scale(
          scale: widget.transformScale,
          child: Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: widget.value,
            onChanged: (val) => _onChanged(val),
            activeColor: Theme
                .of(context)
                .primaryColor,
          ),
        );
      }
    }

    return w;
  }

  _onChanged(bool val) {
    if (widget.onChanged != null) {
      setState(() => widget.value = val);
      widget.onChanged(val);
    }
  }
}
