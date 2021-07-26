import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/labels.dart';

/// Card дээр ашиглагдах row item
class RowItem extends StatelessWidget {
  RowItem({
    Key key,
    this.caption,
    this.value,
    this.valueMaxLines = 3,
  });

  final String caption;
  final String value;
  final int valueMaxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Caption
        lbl(caption, fontSize: AppHelper.fontSizeMedium, alignment: Alignment.topLeft),

        SizedBox(width: 5.0),

        // Value
        Func.isNotEmpty(value)
            ? Expanded(
                child: FadeInSlow(
                  child: lbl(
                    value,
                    fontSize: AppHelper.fontSizeMedium,
                    alignment: Alignment.topRight,
                    textAlign: TextAlign.end,
                    maxLines: valueMaxLines,
                  ),
                ),
              )
            : Expanded(
                child: lbl(
                  '',
                  fontSize: AppHelper.fontSizeMedium,
                  alignment: Alignment.topRight,
                  textAlign: TextAlign.end,
                  maxLines: valueMaxLines,
                ),
              ),
      ],
    );
  }
}
