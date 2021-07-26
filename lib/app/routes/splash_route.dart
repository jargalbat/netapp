import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/routes/term_cond/ui/term_cond_route.dart';
import 'package:netware/app/shared_pref_key.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/modules/intro/provider/intro_helper.dart';
import 'package:netware/modules/intro/ui/intro_route.dart';
import 'package:netware/modules/login/login_route.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/modules/story/story_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRoute extends StatefulWidget {
  @override
  _SplashRouteState createState() => new _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  @override
  void initState() {
    _navigateAfterDelay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarEmpty(context: context, brightness: Brightness.light, backgroundColor: AppColors.bgGreyLight),
        backgroundColor: AppColors.bgGreyLight,
        body: Container());
  }

  _navigateAfterDelay() async {
    if (globals.sharedPref == null) globals.sharedPref = await SharedPreferences.getInstance();
//    _clearSharedPref();

    return new Timer(
      Duration(milliseconds: 500),
      () {
        // Privacy policy зөвшөөрсөн эсэх
        bool hasPermitted = globals.sharedPref.containsKey(SharedPrefKey.PrivacyPolicy) ? globals.sharedPref.getBool(SharedPrefKey.PrivacyPolicy) : false;
        if (hasPermitted) {
          // Navigate to login
          Navigator.pushReplacement(context, FadeRouteBuilder(route: LoginRoute()));
        } else {
          // Navigate to Term cond, privacy policy
          Navigator.pushReplacement(context, FadeRouteBuilder(route: StoryRoute()));
        }
      },
    );
  }

  void _clearSharedPref(){
    globals.sharedPref.setBool(SharedPrefKey.PrivacyPolicy, false);
  }
}

class SplashBody extends StatefulWidget {
  @override
  _SplashBodyState createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /// Lion logo
              FadeInSplash(
                delay: 0,
                begin: -50,
                end: 0,
                child: Image.asset(AssetName.splash_lion, height: 62.0),
              ),
              SizedBox(height: 5.0),

              /// NET CAPITAL
              FadeInSplash(
                delay: 0,
                begin: -500,
                end: 0,
                child: Image.asset(AssetName.splash_net_capital, height: 23.0),
              ),
              SizedBox(height: 5.0),

              /// Financial enterprise
              FadeInSplash(
                delay: 0,
                begin: -50,
                end: 0,
                child: Image.asset(AssetName.splash_financial_enterprise, height: 11.0),
              ),

              SizedBox(height: 100.0),
            ],
          ),
        ),

        /// Powered by Netcapital Financial Enterprise
        Align(
          alignment: Alignment.bottomCenter,
          child: FadeInSplash2(
            delay: 0,
            begin: -30,
            end: 0,
            child: Text(
              'Powered by Netcapital Financial Enterprise',
              style: TextStyle(
                fontSize: 12.0,
                color: AppColors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Intro харуулсан тоо
//int ii = IntroHelper.IntroLimit;
//int introShownCount = globals.sharedPref.containsKey(SharedPrefKey.IntroLimit) ? globals.sharedPref.getInt(SharedPrefKey.IntroLimit) : 0;
//if (introShownCount < IntroHelper.IntroLimit) {
//introShownCount++;
//globals.sharedPref.setInt(SharedPrefKey.IntroLimit, introShownCount);
//Navigator.pushReplacement(context, FadeRouteBuilder(route: IntroRoute()));
//return;
//}
//
////test
//if (globals.isTest) {
////          globals.sharedPref.setBool(SharedPrefKey.PrivacyPolicy, false);
//}
