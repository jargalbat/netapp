//import 'package:flutter/material.dart';
//import 'package:netware/app/globals.dart';
//import 'package:netware/app/localization/localization.dart';
//import 'package:netware/app/themes/app_colors.dart';
//import 'package:netware/app/widgets/app_bar.dart';
//import 'package:netware/app/widgets/cards.dart';
//import 'package:netware/app/widgets/labels.dart';
//import 'package:netware/app/widgets/list_item.dart';
//
//class LanguageScreen extends StatefulWidget {
//  @override
//  _LanguageScreenState createState() => _LanguageScreenState();
//}
//
//class _LanguageScreenState extends State<LanguageScreen> {
//  final _scaffoldKey = GlobalKey<ScaffoldState>();
//  Localization _loc;
//  double _paddingHorizontal = 20.0;
//  bool _isLangMN = true;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    _loc = globals.text;
//
//    return WillPopScope(
//      onWillPop: () async {
//        _onBackPressed();
//        return Future.value(false);
//      },
//      child: SafeArea(
//        child: Scaffold(
//          key: _scaffoldKey,
//          backgroundColor: AppColors.bgGrey,
//          appBar: appBarSimple(
//            context: context,
//            onPressed: _onBackPressed,
//            hasBackArrow: true,
//          ),
//          body: SingleChildScrollView(
//            child: Column(
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(
//                    right: _paddingHorizontal,
//                    left: _paddingHorizontal,
//                  ),
//                  child: lbl(
//                    _loc.settings(),
//                    style: lblStyle.Headline4,
//                    color: AppColors.lblDark,
//                    fontWeight: FontWeight.normal,
//                  ),
//                ),
//                SizedBox(height: 20.0),
//                card(
//                  margin: EdgeInsets.only(
//                    right: _paddingHorizontal,
//                    left: _paddingHorizontal,
//                  ),
//                  child: Column(
//                    children: <Widget>[
//                      /// Item1
//                      listItemMenu(
//                        onPressed: () {
////                          BlocProvider.of<AppBloc>(context)
////                            ..add(ChangeLang(
////                                locale: newLocale(globals.langCode)));
//
//                          setState(() {
//                            _isLangMN = true;
//                          });
//                        },
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            /// Text
//                            lbl('Монгол',
//                                fontSize: 16.0, color: AppColors.lblDark),
//
//                            Icon(Icons.check_circle,
//                                color: _isLangMN
//                                    ? AppColors.jungleGreen
//                                    : Colors.transparent),
//                          ],
//                        ),
//                      ),
//
//                      Divider(height: 2.0, color: AppColors.bgGrey),
//
//                      /// Item2
//                      Container(
//                        child: listItemMenu(
//                          onPressed: () {
////                            BlocProvider.of<AppBloc>(context)
////                              ..add(ChangeLang(
////                                  locale: newLocale(globals.langCode)));
//
//                            setState(() {
//                              _isLangMN = false;
//                            });
//                          },
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              /// Text
//                              lbl('English',
//                                  fontSize: 16.0, color: AppColors.lblDark),
//
//                              Icon(Icons.check_circle,
//                                  color: !_isLangMN
//                                      ? AppColors.jungleGreen
//                                      : Colors.transparent),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  _onBackPressed() {
//    Navigator.pop(context);
//  }
//}
