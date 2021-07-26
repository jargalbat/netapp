import 'package:flutter/material.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/labels.dart';

/// Login хийсний дараа харуулна

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(right: 20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 35,
              child: Container(),
            ),
            FadeIn(
              delay: 0,
              begin: 20,
              end: 40,
              child: lbl(
                globals.text.welcome(),
                color: AppColors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.0),
            FadeIn(
              delay: 0,
              begin: 0,
              end: 40,
              child: lbl(globals.user.firstName ?? '', color: AppColors.blue, style: lblStyle.Headline4, fontWeight: FontWeight.w500),
            ),
            Expanded(
              flex: 55,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
