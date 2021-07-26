import 'package:flutter/material.dart';

class RoundedContainer extends StatefulWidget {
  RoundedContainer({
    Key key,
    this.child,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.radius = 10.0,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double radius;

  @override
  _RoundedContainerState createState() => _RoundedContainerState();
}

class _RoundedContainerState extends State<RoundedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.radius),
          topRight: Radius.circular(widget.radius),
        ),
        color: Colors.white,
      ),
//      color: Colors.black,
      child: widget.child,
    );
  }
}
