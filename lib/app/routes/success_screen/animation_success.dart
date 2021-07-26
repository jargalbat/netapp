import 'dart:async';
import 'dart:math';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';

class FadeBox extends StatelessWidget {
  final Animation<double> containerGrowAnimation;
  final Animation<Color> fadeScreenAnimation;

  FadeBox({this.containerGrowAnimation, this.fadeScreenAnimation});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return (new Hero(
        tag: "fade",
        child: new Container(
          width: containerGrowAnimation.value < 1 ? screenSize.width : 0.0,
          height: containerGrowAnimation.value < 1 ? screenSize.height : 0.0,
          decoration: new BoxDecoration(
            color: fadeScreenAnimation.value,
          ),
        )));
  }
}

class CheckAnimation extends StatefulWidget {
  final double size;
  final VoidCallback onComplete;

  CheckAnimation({this.size, this.onComplete});

  @override
  _CheckAnimationState createState() => _CheckAnimationState();
}

class _CheckAnimationState extends State<CheckAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> curve;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);

    _controller.addListener(() {
      setState(() {});
      if (_controller.status == AnimationStatus.completed &&
          widget.onComplete != null) {
        widget.onComplete();
      }
    });

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _controller.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size ?? 100,
      width: widget.size ?? 100,
      color: Colors.transparent,
      child: CustomPaint(
        painter: CheckPainter(value: curve.value),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}

class CheckPainter extends CustomPainter {
  Paint _paint;
  double value;

  double _length;
  double _offset;
  double _startingAngle;

  CheckPainter({this.value}) {
    _paint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, 1.0)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    assert(value != null);

//    _length = 1;
//    _offset = 0;
//    _startingAngle = 270;
    _length = 60;
    _offset = 0;
    _startingAngle = 205;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Background canvas
    var rect = Offset(0, 0) & size;
    _paint.color = Color.fromRGBO(255, 255, 255, 0.0);

    double line1x1 = size.width / 2 +
        size.width * cos(Angle.fromDegrees(_startingAngle).radians) * .5;
    double line1y1 = size.height / 2 +
        size.height * sin(Angle.fromDegrees(_startingAngle).radians) * .5;
    double line1x2 = size.width * .45;
    double line1y2 = size.height * .65;

    double line2x1 =
        size.width / 2 + size.width * cos(Angle.fromDegrees(320).radians) * .35;
    double line2y1 = size.height / 2 +
        size.height * sin(Angle.fromDegrees(320).radians) * .35;

    canvas.drawArc(rect, Angle.fromDegrees(_startingAngle).radians,
        Angle.fromDegrees(360).radians, false, _paint);
    canvas.drawLine(Offset(line1x1, line1y1), Offset(line1x2, line1y2), _paint);
    canvas.drawLine(Offset(line2x1, line2y1), Offset(line1x2, line1y2), _paint);

    // animation painter

    double circleValue, checkValue;
    if (value < .5) {
      checkValue = 0;
      circleValue = value / .5;
    } else {
      checkValue = (value - .5) / .5;
      circleValue = 1;
    }

    _paint.color = Color.fromRGBO(255, 255, 255, 1.0);
    double firstAngle = _startingAngle + 360 * circleValue;

    canvas.drawArc(
        rect,
        Angle.fromDegrees(firstAngle).radians,
        Angle.fromDegrees(
                getSecondAngle(firstAngle, _length, _startingAngle + 360))
            .radians,
        false,
        _paint);

    double line1Value = 0, line2Value = 0;
    if (circleValue >= 1) {
      if (checkValue < .5) {
        line2Value = 0;
        line1Value = checkValue / .5;
      } else {
        line2Value = (checkValue - .5) / .5;
        line1Value = 1;
      }
    }

    double auxLine1x1 = (line1x2 - line1x1) * getMin(line1Value, .8);
    double auxLine1y1 =
        (((auxLine1x1) - line1x1) / (line1x2 - line1x1)) * (line1y2 - line1y1) +
            line1y1;

    if (_offset < 60) {
      auxLine1x1 = line1x1;
      auxLine1y1 = line1y1;
    }

    double auxLine1x2 = auxLine1x1 + _offset / 2;
    double auxLine1y2 =
        (((auxLine1x1 + _offset / 2) - line1x1) / (line1x2 - line1x1)) *
                (line1y2 - line1y1) +
            line1y1;

    if (checkIfPointHasCrossedLine(Offset(line1x2, line1y2),
        Offset(line2x1, line2y1), Offset(auxLine1x2, auxLine1y2))) {
      auxLine1x2 = line1x2;
      auxLine1y2 = line1y2;
    }

    if (_offset > 0) {
      canvas.drawLine(Offset(auxLine1x1, auxLine1y1),
          Offset(auxLine1x2, auxLine1y2), _paint);
    }

    // SECOND LINE

    double auxLine2x1 = (line2x1 - line1x2) * line2Value;
    double auxLine2y1 =
        ((((line2x1 - line1x2) * line2Value) - line1x2) / (line2x1 - line1x2)) *
                (line2y1 - line1y2) +
            line1y2;

    if (checkIfPointHasCrossedLine(Offset(line1x1, line1y1),
        Offset(line1x2, line1y2), Offset(auxLine2x1, auxLine2y1))) {
      auxLine2x1 = line1x2;
      auxLine2y1 = line1y2;
    }
    if (line2Value > 0) {
      canvas.drawLine(
          Offset(auxLine2x1, auxLine2y1),
          Offset(
              (line2x1 - line1x2) * line2Value + _offset * .75,
              ((((line2x1 - line1x2) * line2Value + _offset * .75) - line1x2) /
                          (line2x1 - line1x2)) *
                      (line2y1 - line1y2) +
                  line1y2),
          _paint);
    }
  }

  double getMax(double x, double y) {
    return (x > y) ? x : y;
  }

  double getMin(double x, double y) {
    return (x > y) ? y : x;
  }

  bool checkIfPointHasCrossedLine(Offset a, Offset b, Offset point) {
    return ((b.dx - a.dx) * (point.dy - a.dy) -
            (b.dy - a.dy) * (point.dx - a.dx)) >
        0;
  }

  double getSecondAngle(double angle, double plus, double max) {
    if (angle + plus > max) {
      _offset = angle + plus - max;
      return max - angle;
    } else {
      _offset = 0;
      return plus;
    }
  }

  @override
  bool shouldRepaint(CheckPainter old) {
    return old.value != value;
  }
}
