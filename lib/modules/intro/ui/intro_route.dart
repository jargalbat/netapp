import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/routes/term_cond/ui/term_cond_route.dart';
import 'package:netware/app/shared_pref_key.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/modules/intro/provider/offset_notifier.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/modules/intro/ui/page4.dart';
import 'package:netware/modules/login/login_route.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';

class IntroRoute extends StatefulWidget {
  @override
  _IntroRouteState createState() => new _IntroRouteState();
}

class _IntroRouteState extends State<IntroRoute> {
  /// UI
  final _paddingHorizontal = 30.0;

  /// Page view
  PageController _pageController = PageController(initialPage: 0, keepPage: false);
  final _pageCount = 4;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBarEmpty(
          context: context,
          brightness: Brightness.light,
          backgroundColor: AppColors.bgGreyLight,
        ),
        backgroundColor: AppColors.bgGreyLight,
        body: ChangeNotifierProvider(
          create: (_) => OffsetNotifier(_pageController),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),

              /// Page view
              Expanded(
                flex: 5,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPageNotifier.value = index;
                    });
                  },
                  children: <Widget>[
                    Page1(),
                    Page2(),
                    Page3(),
                    Page4(),
                  ],
                ),
              ),

              /// Text
              Expanded(
                flex: 3,
                child: Stack(
                  children: <Widget>[
                    _text1(),
                    _text2(),
                    _text3(),
                    _text4(),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(_paddingHorizontal, 30.0, _paddingHorizontal, 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    /// Indicator
                    _indicator(),

                    /// Алгасах
                    _btnSkip(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _text1() {
    return Consumer<OffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: math.max(0, 1 - 2 * notifier.page), //0.1 (0.8), 0.9(-0.8)
          child: child,
        );
      },
      child: _textWidget(globals.text.page1Title(), globals.text.page1Text()),
    );
  }

  Widget _text2() {
    return Consumer<OffsetNotifier>(
      builder: (context, notifier, child) {
        double multiplier;

        if (notifier.page <= 1.0) {
          multiplier = math.max(0, 4 * notifier.page - 3); //0.1 (-3.6), 0.9 (0.6)
        } else {
          multiplier = math.max(0, 1 - (4 * notifier.page - 4)); //1.1 (0.6), 1.9 (-2.6)
        }

        return Opacity(
          opacity: multiplier,
          child: child,
        );

//                    return Transform.translate(
//                      offset: Offset(0, 50 * (1 - multiplier)),
//                      child: Opacity(
//                        opacity: multiplier,
//                        child: child,
//                      ),
//                    );
      },
      child: _textWidget(globals.text.page2Title(), globals.text.page2Text()),
    );
  }

  Widget _text3() {
    return Consumer<OffsetNotifier>(
      builder: (context, notifier, child) {
        double multiplier;
        if (notifier.page <= 2.0) {
          multiplier = math.max(0, 4 * notifier.page - 7); //1.1 (-2.6), 1.9 (0.6)
        } else {
          multiplier = math.max(0, 1 - (4 * notifier.page - 8)); //2.1 (0.6), 2.9 (-2.6)
        }

        return Opacity(
          opacity: multiplier,
          child: child,
        );
      },
      child: _textWidget(globals.text.page3Title(), globals.text.page3Text()),
    );
  }

  Widget _text4() {
    return Consumer<OffsetNotifier>(
      builder: (context, notifier, child) {
        double multiplier;

        if (notifier.page <= 3.0) {
          multiplier = math.max(0, 4 * notifier.page - 11); //2.1 (-2.6), 2.9 (0.6)
        } else {
          multiplier = math.max(0, 1 - (4 * notifier.page - 12)); //3.1 (0.6), 3.9 (-2.6)
        }

        return Opacity(
          opacity: multiplier,
          child: child,
        );
      },
      child: _textWidget(globals.text.page4Title(), globals.text.page4Text()),
    );
  }

  Widget _textWidget(String title, String text) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(_paddingHorizontal, 20.0, _paddingHorizontal, 0.0),
        child: Column(
          children: <Widget>[
            lbl(
              title,
              fontSize: 28.0,
              color: AppColors.lblBlue,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10.0),
            lbl(
              text,
              style: lblStyle.Medium,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicator() {
    return CirclePageIndicator(
      selectedDotColor: AppColors.imgActive,
      dotColor: Colors.grey,
      itemCount: _pageCount,
      currentPageNotifier: _currentPageNotifier,
    );
  }

  Widget _btnSkip() {
    return TextButton(
      text: _currentPageNotifier.value == (_pageCount - 1) ? globals.text.finish() : globals.text.skip(),
      textColor: AppColors.lblBlue,
      fontSize: AppHelper.fontSizeMedium,
      onPressed: () {
        if (_currentPageNotifier.value == (_pageCount - 1)) {
          /// Privacy policy зөвшөөрсөн эсэх
          bool hasPermitted = globals.sharedPref.containsKey(SharedPrefKey.PrivacyPolicy) ? globals.sharedPref.getBool(SharedPrefKey.PrivacyPolicy) : false;
          if (!hasPermitted) {
            Navigator.pushReplacement(context, FadeRouteBuilder(route: TermCondRoute()));
          } else {
            Navigator.pushReplacement(context, FadeRouteBuilder(route: LoginRoute()));
          }
        } else {
          _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }
}
