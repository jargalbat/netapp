import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/bloc/fee_score_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'get_loan_route.dart';

class LoanTab extends StatefulWidget {
  LoanTab({this.scaffoldKey});

  final scaffoldKey;

  @override
  _LoanTabState createState() => _LoanTabState();
}

class _LoanTabState extends State<LoanTab> {
  /// UI
  final _settingsKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeeScoreBloc, FeeScoreState>(
      listener: _blocListener,
      child: BlocBuilder<FeeScoreBloc, FeeScoreState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _blocListener(BuildContext context, FeeScoreState state) {
    if (state is GetLimitFeeScoreSuccess) {
//
    }

//    showSnackBar(key: widget.scaffoldKey, text: state.text);
  }

  Widget _blocBuilder(BuildContext context, FeeScoreState state) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          key: _settingsKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarEmpty(
            context: context,
            brightness: Brightness.light,
            backgroundColor: AppColors.bgGreyLight,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /// Тохиргоо
                lbl(globals.text.loan(), style: lblStyle.Headline4, color: AppColors.blue, margin: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0)),

                CustomCard(
                  margin: EdgeInsets.only(right: AppHelper.margin, left: AppHelper.margin),
                  padding: EdgeInsets.fromLTRB(30.0, AppHelper.margin, 30.0, AppHelper.margin),
                  child: Row(
                    children: <Widget>[
                      /// Нийт зээлийн үлдэгдэл
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            // Value
                            lbl(
                              '${Func.toMoneyStr(globals.onlineLoanList.curLoanTotalBal)}₮',
                              fontSize: AppHelper.fontSizeHeadline5,
                              fontWeight: FontWeight.w500,
                            ),

                            SizedBox(height: 5.0),

                            // Caption
                            lbl(globals.text.totalLoanAmt(), fontSize: AppHelper.fontSizeCaption, color: AppColors.lblGrey, maxLines: 2)
                          ],
                        ),
                      ),

                      Container(
                        height: 39.0,
                        width: 1.0,
                        color: AppColors.lineGreyCard,
                        margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
                      ),

                      Expanded(
                        child: Column(
                          children: <Widget>[
                            // Value
                            lbl(
                              '0', //todo
                              fontSize: AppHelper.fontSizeHeadline5,
                              fontWeight: FontWeight.w500,
                            ),

                            SizedBox(height: 5.0),

                            // Caption
                            lbl(globals.text.activeLoan(), fontSize: AppHelper.fontSizeCaption, color: AppColors.lblGrey, maxLines: 2)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppHelper.margin),

                _btnLoanApplication(),

                SizedBox(height: AppHelper.marginBottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnLoanApplication() {
    return CustomButton(
//      text: Func.toStr(_loc.save()).toUpperCase(),
      text: globals.text.getLoan().toUpperCase(),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: (globals.feeScore != null) ? () => Navigator.push(context, FadeRouteBuilder(route: GetLoanRoute())) : null,
    );
  }
}
