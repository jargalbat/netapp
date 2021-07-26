import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/loan/create_loan_request.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/app/bloc/fee_score_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';

class LoanConfirmRoute extends StatefulWidget {
  const LoanConfirmRoute({
    Key key,
    this.prodName,
    this.reqAmt,
    this.termSize,
    this.feeAmt,
    this.totalRepayAmt,
    this.repayDate,
    this.bankCode,
    this.bankName,
    this.bankAcntNo,
  }) : super(key: key);

  final String prodName;
  final double reqAmt;
  final int termSize;
  final double feeAmt;
  final double totalRepayAmt;
  final String repayDate;
  final String bankCode;
  final String bankName;
  final String bankAcntNo;

  @override
  _LoanConfirmRouteState createState() => _LoanConfirmRouteState();
}

class _LoanConfirmRouteState extends State<LoanConfirmRoute> {
  /// UI
  var _loanConfirmKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

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
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBarSimple(
          context: context,
          brightness: Brightness.light,
          onPressed: () {
            _onBackPressed(context);
          },
          hasBackArrow: true,
        ),
        backgroundColor: AppColors.bgGrey,
        key: _loanConfirmKey,
        body: LoadingContainer(
          loading: _isLoading,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                /// Зээл авах
                lbl(globals.text.getLoan(), style: lblStyle.Headline4, color: AppColors.lblDark, margin: EdgeInsets.only(left: AppHelper.margin)),

                /// Баталгаажуулах
                CustomCard(
                  color: AppColors.bgGreyLight,
                  margin: EdgeInsets.fromLTRB(AppHelper.margin, 20.0, AppHelper.margin, AppHelper.margin),
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      /// Баталгаажуулах
                      lbl(
                        globals.text.confirm().toUpperCase(),
                        color: AppColors.lblBlue,
                        fontSize: AppHelper.fontSizeMedium,
                        fontWeight: FontWeight.w500,
                        alignment: Alignment.center,
                      ),

                      Container(height: 1.0, color: AppColors.lineGreyCard, margin: EdgeInsets.all(AppHelper.margin)),

                      /// Зээлийн дугаар
//                      _rowItem('Зээлийн дугаар:', widget.prodName),
//
//                      SizedBox(height: AppHelper.margin),

                      /// Хэмжээ
                      _rowItem('${globals.text.reqAmt()}:', '${Func.toMoneyStr(widget.reqAmt)}₮'),

                      SizedBox(height: AppHelper.margin),

                      /// Хугацаа
                      _rowItem('${globals.text.term()}:', '${widget.termSize} ${globals.text.days()}'),

                      SizedBox(height: AppHelper.margin),

                      /// Шимтгэл
                      _rowItem('${globals.text.fee()}:', '${Func.toMoneyStr(widget.feeAmt)}₮'),

                      SizedBox(height: AppHelper.margin),

                      /// Нийт төлөх дүн
                      _rowItem('${globals.text.totalRepayAmt2()}:', '${Func.toMoneyStr(widget.totalRepayAmt)}₮'),

                      SizedBox(height: AppHelper.margin),

                      /// Төлөх огноо
                      _rowItem('${globals.text.repayDate()}:', widget.repayDate),

                      SizedBox(height: AppHelper.margin),

                      /// Хүлээн авах данс
                      _rowItem('${globals.text.receivingAccount()}:', widget.bankAcntNo),
                    ],
                  ),
                ),

                SizedBox(height: AppHelper.margin),

                _btnGetLoan(),

                SizedBox(height: AppHelper.marginBottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowItem(String caption, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Caption
        lbl(caption, fontSize: AppHelper.fontSizeMedium),

        // Value
        Expanded(
            child: lbl(
          value,
          fontSize: AppHelper.fontSizeMedium,
          alignment: Alignment.centerRight,
        )),
      ],
    );
  }

  Widget _btnGetLoan() {
    return CustomButton(
        text: globals.text.getLoan(),
        context: context,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        color: AppColors.bgBlue,
        disabledColor: AppColors.btnGreyDisabled,
        textColor: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        onPressed: !_isLoading
            ? () {
                _onPressedBtnGetLoan();
              }
            : null);
  }

  void _onPressedBtnGetLoan() async {
    CreateLoanRequest request = CreateLoanRequest()
      ..termSize = widget.termSize
      ..reqAmt = widget.reqAmt
      ..bankCode = widget.bankCode
      ..bankAcntNo = widget.bankAcntNo;

    setState(() => _isLoading = true);

    ApiManager.createLoanRequest(request).then((res) {
      setState(() => _isLoading = false);

      if (res.resultCode == 0) {
        BlocProvider.of<FeeScoreBloc>(context).add(GetFeeScore());
        BlocProvider.of<AcntBloc>(context).add(GetOnlineLoanList());
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        showSnackBar(key: _loanConfirmKey, text: res.resultDesc ?? globals.text.requestFailed());
      }
    });
  }

  _onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
