import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/acnt/bank_acnt_list_response.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';

import 'add_bank_acnt_route.dart';
import 'bank_acnt_detail_route.dart';

/// Миний данс
class BankAcntListRoute extends StatefulWidget {
  BankAcntListRoute({Key key}) : super(key: key);

  @override
  _BankAcntListRouteState createState() => _BankAcntListRouteState();
}

class _BankAcntListRouteState extends State<BankAcntListRoute> {
  var _bankAcntListKey = GlobalKey<ScaffoldState>();
  double _paddingHorizontal = 15.0;
  var _bankAcntList = <BankAcnt>[];
  BankAcnt _mainBankAcnt;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AcntBloc>(context)..add(GetBankAcntList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AcntBloc, AcntState>(
      listener: _blocListener,
      child: BlocBuilder<AcntBloc, AcntState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _blocListener(BuildContext context, AcntState state) {
    if (state is BankAcntSuccess) {
      _bankAcntList = state.bankAcntList;
      _mainBankAcnt = state.mainBankAcnt;

//      _bankAcntList = [];
//      _mainBankAcnt = null;
    } else if (state is BankAcntNotFound) {
      _mainBankAcnt = null;
      _bankAcntList = [];
    } else if (state is BankAcntFailed) {
      showSnackBar(key: _bankAcntListKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, AcntState state) {
    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBarSimple(
          context: context,
          brightness: Brightness.light,
          onPressed: () {
            _onBackPressed();
          },
          hasBackArrow: true,
        ),
        backgroundColor: AppColors.bgGrey,
        key: _bankAcntListKey,
        body: LoadingContainer(
          loading: state is BankAcntLoading,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: _paddingHorizontal, left: _paddingHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// Миний данс
                      lbl(globals.text.myAcnt(), style: lblStyle.Headline4, color: AppColors.lblDark, fontWeight: FontWeight.normal),

                      /// Profile pic
//                      Image.asset(AssetName.profile_pic, width: 37.0, colorBlendMode: BlendMode.modulate),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

                CustomCard(
                  margin: EdgeInsets.only(right: _paddingHorizontal, left: _paddingHorizontal),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(0.0),
                        padding: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0, left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            /// Үндсэн данс
                            lbl(_mainBankAcnt != null ? globals.text.mainAcnt() : globals.text.account(),
                                style: lblStyle.Medium, fontWeight: FontWeight.w500),

                            /// Add account button
                            ButtonIcon(
                              onPressed: () {
                                Navigator.push(context, FadeRouteBuilder(route: AddBankAcntRoute()));
                              },
                              icon: Icon(Icons.add, color: AppColors.iconBlue),
                            ),
                          ],
                        ),
                      ),

                      /// Үндсэн данс
                      if (_mainBankAcnt != null)
                        _listItem(_mainBankAcnt, showTopBorder: true),

                      /// Бусад данс
                      if (_bankAcntList != null && _bankAcntList.isNotEmpty)
                        Container(
                          margin: EdgeInsets.all(0.0),
                          padding: EdgeInsets.only(top: 15.0, right: 10.0, bottom: 10.0, left: 10.0),
                          child: lbl(globals.text.otherAcnt(), style: lblStyle.Medium, fontWeight: FontWeight.w500),
                        ),
                      for (var el in _bankAcntList) _listItem(el, showTopBorder: true),
                    ],
                  ),
                ),

                /// Зээл хүлээн авах данс
//                _mainBankAcntWidget(),

//                SizedBox(height: 15.0),

                /// Бусад данс
//                _bankAcntListWidget(),

                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

//  Widget _mainBankAcntWidget() {
//    return _mainBankAcnt != null
//        ? FadeInSlow(
//            child: CustomCard(
//              margin: EdgeInsets.only(right: _paddingHorizontal, left: _paddingHorizontal),
//              child: Column(
//                children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.all(0.0),
//                    padding: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0, left: 10.0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        /// Үндсэн данс
//                        lbl('Үндсэн данс', style: lblStyle.Medium, fontWeight: FontWeight.w500),
//
//                        /// Add account button
//                        ButtonIcon(
//                          onPressed: () {
//                            Navigator.push(context, FadeRouteBuilder(route: AddBankAcntRoute()));
//                          },
//                          icon: Icon(Icons.add, color: AppColors.iconBlue),
//                        ),
//                      ],
//                    ),
//                  ),
//                  _listItem(_mainBankAcnt, showTopBorder: true),
//                ],
//              ),
//            ),
//          )
//        : Container();
//  }

//  Widget _bankAcntListWidget() {
//    return _mainBankAcnt != null
//        ? FadeInSlow(
//            child: CustomCard(
//              margin: EdgeInsets.only(right: _paddingHorizontal, left: _paddingHorizontal),
//              child: Column(
//                children: <Widget>[
//                  /// Бусад данс
//                  Container(
//                    margin: EdgeInsets.all(0.0),
//                    padding: EdgeInsets.only(top: 15.0, right: 10.0, bottom: 10.0, left: 10.0),
//                    child: lbl('Бусад данс', style: lblStyle.Medium, fontWeight: FontWeight.w500),
//                  ),
//
//                  /// List
//                  for (var el in _bankAcntList) _listItem(el, showTopBorder: true),
//                ],
//              ),
//            ),
//          )
//        : Container();
//  }

  Widget _listItem(BankAcnt bankAcnt, {bool showTopBorder = false}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, FadeRouteBuilder(route: BankAcntDetailRoute(bankAcnt: bankAcnt)));
      },
      child: Container(
        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.only(top: 15.0, right: 10.0, bottom: 15.0, left: 10.0),
        decoration: showTopBorder ? BoxDecoration(border: Border(top: BorderSide(width: 1.0, color: AppColors.bgGrey))) : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            /// Bank icon
            Image.asset(DictionaryManager.getAssetNameByCode(bankAcnt.bankCode), height: 34.0),

            SizedBox(width: 10.0),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Account number
                lbl(Func.toStr(bankAcnt.acntNo), fontSize: 16.0, color: AppColors.lblDark),

                /// Account name
                lbl(Func.toStr(bankAcnt.acntName), style: lblStyle.Caption, color: AppColors.lblGrey),
              ],
            ),

            /// Text

            /// Icon
//            Expanded(
//              child: Align(
//                alignment: Alignment.centerRight,
//                child: Icon(
//                  Icons.arrow_forward_ios,
//                  color: AppColors.iconMirage,
//                ),
//              ),
//            ),

            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
