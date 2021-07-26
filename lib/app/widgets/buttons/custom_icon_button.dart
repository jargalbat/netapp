import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({@required this.icon, this.onTap});

  final Icon icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: icon);
  }
}
