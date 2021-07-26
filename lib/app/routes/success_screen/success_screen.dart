import 'dart:async';
import 'package:flutter/material.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/widgets/labels.dart';
import 'animation_success.dart';

class SuccessScreen extends StatefulWidget {
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Localization _loc;

  @override
  Widget build(BuildContext context) {
    _loc = globals.text;

    return WillPopScope(
      onWillPop: () async {
        await _onPressed();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.bgBlue,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new RawMaterialButton(
                onPressed: () async {
                  await _onPressed();
                },
                child: CheckAnimation(),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: AppColors.jungleGreen,
                padding: const EdgeInsets.all(5.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              lbl(
                _loc.msgSignUpSuccessTitle(),
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                textAlign: TextAlign.center,
                maxLines: 5,
                fontWeight: FontWeight.bold,
                color: AppColors.lblWhite,
                fontSize: 17.0,
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPressed() async {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
