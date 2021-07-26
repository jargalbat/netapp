import 'package:flutter/material.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/buttons/custom_icon_button.dart';
import 'package:netware/app/widgets/labels.dart';

class CustomSlider extends StatefulWidget {
  CustomSlider({
    @required this.onChanged,
    this.unitType = '',
    @required this.minValue,
    @required this.maxValue,
    this.stepValue = 1000,
  });

  final Function(int) onChanged;
  final String unitType; // Төрөл: 10₮, 10ш, 10$
  final int minValue;
  final int maxValue;
  final int stepValue;

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  int _value;

  @override
  void initState() {
    super.initState();

    _value = widget.minValue;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
//          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 18.0)
//          thumbShape:  RetroSliderThumbShape(thumbRadius: 18.0),
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 10.0,
          disabledThumbRadius: 10.0,
        ),
//        rangeThumbShape: _CustomRangeThumbShape(),
        // ...
      ),
      child: Column(
        children: <Widget>[
          /// Value
          lbl('${Func.toMoneyStr(_value)}${widget.unitType}', style: lblStyle.Headline4, alignment: Alignment.center),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /// Decrease
              CustomIconButton(
                icon: Icon(
                  Icons.remove,
                  color: AppColors.blue,
                ),
                onTap: () {
                  if (_value - widget.stepValue >= widget.minValue) {
                    setState(() {
                      _value -= widget.stepValue;
                      widget.onChanged(_value);
                    });
                  }
                },
              ),

              /// Slider
              Expanded(
                child: Slider(
                  value: _value.toDouble(),
                  min: widget.minValue.toDouble(),
                  max: widget.maxValue.toDouble(),
//                  divisions: ((widget.maxValue - widget.minValue) / widget.stepValue).round(),
                  activeColor: AppColors.blue,
                  inactiveColor: AppColors.bgGrey,
                  onChanged: (double newValue) {
                    setState(() {
                      _value = newValue.round();
                      widget.onChanged(_value);
                    });
                  },
                  semanticFormatterCallback: (double newValue) {
                    return '${newValue.round()} dollars';
                  },
                ),
              ),

              /// Increase
              CustomIconButton(
                icon: Icon(
                  Icons.add,
                  color: AppColors.blue,
                ),
                onTap: () {
                  if (_value + widget.stepValue <= widget.maxValue) {
                    setState(() {
                      _value += widget.stepValue;
                      widget.onChanged(_value);
                    });
                  }
                },
              ),
            ],
          ),

          lbl(((globals.langCode == LangCode.mn) ? 'Боломжит дээд хэмжээ: ' : 'Loan limit') + '${Func.toMoneyStr(widget.maxValue)}${widget.unitType}', color: AppColors.lblGrey, alignment: Alignment.center),

//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              /// Min value
//              lbl('${Func.toMoneyStr(widget.minValue)}${widget.unitType}'),
//
//              /// Max value
//              lbl('${Func.toMoneyStr(widget.maxValue)}${widget.unitType}'),
//            ],
//          ),
        ],
      ),
    );
  }
}

class RetroSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const RetroSliderThumbShape({
    this.thumbRadius = 6.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;

    final rect = Rect.fromCircle(center: center, radius: thumbRadius);

//    final rect = Rect.from(center: center, radius: thumbRadius);

//    final rect = Rect.fromCenter(center: center, height: thumbRadius, width: thumbRadius);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(rect.left - 1, rect.top),
        Offset(rect.right + 1, rect.bottom),
      ),
      Radius.circular(thumbRadius),
    );

    final fillPaint = Paint()
      ..color = sliderTheme.activeTrackColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, borderPaint);
  }
}
