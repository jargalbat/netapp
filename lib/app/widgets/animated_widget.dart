import 'package:flutter/material.dart';

class ScaleWidget extends StatefulWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;

  ScaleWidget({@required this.child, this.margin, this.padding});

  @override
  State<StatefulWidget> createState() => ScaleWidgetState();
}

class ScaleWidgetState extends State<ScaleWidget> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            margin: widget.margin,
            padding: widget.padding,
            child: widget.child ?? Container(),
          ),
        ),
      ),
    );
  }
}
