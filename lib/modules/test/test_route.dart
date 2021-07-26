import 'package:flutter/material.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';

class TestRoute extends StatefulWidget {
  @override
  _TestRouteState createState() => _TestRouteState();
}

class _TestRouteState extends State<TestRoute> {
  var _testKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        key: _testKey,
        appBar: AppBarEmpty(context: context, brightness: Brightness.light, backgroundColor: AppColors.bgGreyLight),
        backgroundColor: AppColors.bgGreyLight,
        body: LoadingContainer(
          loading: false,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  void _onBackPressed() {
    Navigator.pop(context);
  }
}
