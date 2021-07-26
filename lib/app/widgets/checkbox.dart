import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/labels.dart';

// ignore: must_be_immutable, camel_case_types
class chk extends StatefulWidget {
  bool isChecked;
  String text;
  Function(bool) onChanged;
  EdgeInsets padding;
  double width;
  Color textColor;
  Color unselectedColor;

  chk({
    this.isChecked = false,
    this.text = "",
    @required this.onChanged,
    this.padding = const EdgeInsets.all(0.0),
    @required this.width,
    this.textColor,
    this.unselectedColor,
  });

  @override
  State<StatefulWidget> createState() {
    return _chkState(this.isChecked);
  }
}

class _chkState extends State<chk> {
  bool isChecked;

  _chkState(this.isChecked);

  @override
  Widget build(BuildContext context) {
    Widget checkBox;

    if (!Func.isEmpty(widget.text)) {
      /// Has text
      Widget checkBoxListTile = CheckboxListTile(
        title: lbl(
          widget.text,
          maxLines: 10,
          color: widget.textColor ?? AppColors.iconRegentGrey,
          fontSize: 16.0,
        ),
        dense: false,
        value: isChecked ?? false,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (isChecked) => _onChanged(isChecked),
        activeColor: AppColors.jungleGreen,
      );

      checkBox = MergeSemantics(
        child: new ListTileTheme(
//          iconColor: widget.textColor ?? AppColors.iconRegentGrey,
//          textColor: widget.textColor ?? AppColors.iconRegentGrey,
          contentPadding: EdgeInsets.zero,
          child: checkBoxListTile,
        ),
      );
    } else {
      /// No text
      checkBox = Checkbox(
        activeColor: AppColors.jungleGreen,
        value: isChecked ?? false,
        onChanged: (isChecked) => _onChanged(isChecked),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor:
            widget.unselectedColor ?? AppColors.chkUnselectedGrey,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        width: widget.width,
        child: checkBox,
      ),
    );
  }

  _onChanged(bool isChecked) {
    setState(() => this.isChecked = isChecked);
    widget.onChanged(isChecked);
  }
}



