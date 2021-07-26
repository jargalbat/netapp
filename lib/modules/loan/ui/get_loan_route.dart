import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/acnt/bank_acnt_list_response.dart';
import 'package:netware/api/models/loan/loan_prod_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/app/bloc/fee_score_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/amt_slider.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/combobox/simple_combo.dart';
import 'package:netware/app/widgets/containers/rounded_container.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/bank_acnt/ui/add_bank_acnt_route.dart';
import 'package:netware/modules/loan/bloc/get_loan_bloc.dart';
import 'package:netware/modules/loan/ui/loan_confirm_route.dart';
import 'package:netware/modules/loan/ui/term_list_widget.dart';

class GetLoanRoute extends StatefulWidget {
  const GetLoanRoute({Key key}) : super(key: key);

  @override
  _GetLoanRouteState createState() => _GetLoanRouteState();
}

class _GetLoanRouteState extends State<GetLoanRoute> {
  /// UI
  var _getLoanKey = GlobalKey<ScaffoldState>();

  /// Data
  GetLoanBloc _getLoanBloc;
  LoanProdResponse _loanProdResponse;

  /// Bank account
  var _bankAcntComboList = <ComboItem>[];
  String _selectedBankAcntNo = '';
  String _selectedBankCode = '';
  String _selectedBankName = '';

  /// Баталгаажуулах button
  bool _enabledBtnConfirm = false;

  ///
  int _term = 0;
  double _loanLimit = 0.0;
  double _amtSliderValue = 0.0;
  String _repayDate = '2020.01.01';
  double _feePercent = 0.0;
  double _feeAmt = 0.0;
  double _totalRepayAmt = 0.0;

  @override
  void initState() {
    _loanLimit = globals.onlineLoanList.curLimit;
    _getLoanBloc = GetLoanBloc()..add(GetLoanProd());
    BlocProvider.of<AcntBloc>(context)..add(GetBankAcntList());
    BlocProvider.of<FeeScoreBloc>(context).add(GetFeeScore());
    super.initState();
  }

  @override
  void dispose() {
    _getLoanBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      /// Providers
      providers: [
        BlocProvider<GetLoanBloc>(
            create: (BuildContext context) => _getLoanBloc),
      ],

      /// Listeners
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetLoanBloc, GetLoanState>(
            listener: _blocListener,
          ),
          BlocListener<AcntBloc, AcntState>(
            listener: (context, state) {
              if (state is BankAcntSuccess) {
                setState(() => _bankAcntComboList = state.bankAcntComboList);
              } else if (state is BankAcntFailed) {
                showSnackBar(key: _getLoanKey, text: state.text);
              }
            },
          ),
          BlocListener<FeeScoreBloc, FeeScoreState>(
            listener: (context, state) {
              if (state is GetLimitFeeScoreSuccess) {
                setState(() {
                  print('test *******************************************');
                });
              }
            },
          ),
        ],

        /// Builder
        child: BlocBuilder<GetLoanBloc, GetLoanState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, GetLoanState state) {
    if (state is GetLoanProdSuccess) {
      _loanProdResponse = state.loanProdResponse;
      _amtSliderValue = (state.loanProdResponse.prod.minAmt ?? 0).toDouble();
      _term = state.loanProdResponse?.terms[0].termSize;
      _calcTotalRepayAmt();
    } else if (state is ShowSnackBar) {
      showSnackBar(key: _getLoanKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, GetLoanState state) {
//    return Container();

    return WillPopScope(
      onWillPop: () {
        _onBackPressed(context);
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
        key: _getLoanKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: <Widget>[
              lbl(
                globals.text.getLoan(),
                style: lblStyle.Headline4,
                color: AppColors.lblDark,
                margin: EdgeInsets.only(left: AppHelper.margin),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: LoadingContainer(
                  loading: state is GetLoanLoading,
                  child: RoundedContainer(
                    child: (state is GetLoanProdSuccess)
                        ? SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppHelper.margin),
                              child: Column(
                                children: [
                                  /// Бичил зээл
                                  lbl(globals.text.microLoan(),
                                      style: lblStyle.Headline5,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: AppHelper.margin)),

                                  SizedBox(height: 30.0),

                                  /// Зээлийн хугацаа
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: AppHelper.margin),
                                    child: CustomSlider(
                                      onChanged: (val) {
                                        _amtSliderValue = val.toDouble();
                                        _calcTotalRepayAmt();
                                      },
                                      unitType: Func.toCurSymbol('MNT'),
                                      minValue:
                                          state.loanProdResponse.prod.minAmt,
                                      maxValue: (_loanLimit <
                                              state
                                                  .loanProdResponse.prod.maxAmt)
                                          ? _loanLimit.toInt()
                                          : state.loanProdResponse.prod.maxAmt,
                                    ),
                                  ),

                                  SizedBox(height: 30.0),

                                  /// Зээлийн хугацаа
                                  lbl(
                                    globals.text.loanTerm().toUpperCase(),
                                    style: lblStyle.Caption,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: AppHelper.margin),
                                  ),

                                  SizedBox(height: 15.0),

                                  // Term list
                                  TermListWidget(
                                    onItemSelected: (index) {
                                      _term = state.loanProdResponse
                                          .terms[index].termSize;
                                      _calcTotalRepayAmt();
                                    },
                                    termList: state.loanProdResponse.terms,
                                    termUnit: globals.text.days(),
                                  ),

                                  SizedBox(height: 20.0),

                                  SizedBox(height: 30.0),

                                  /// Төлөлтийн дэлгэрэнгүй
                                  // Caption
                                  lbl(
                                      globals.text
                                          .paymentDetails()
                                          .toUpperCase(),
                                      style: lblStyle.Caption,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: AppHelper.margin)),

                                  SizedBox(height: 15.0),

                                  // Card
                                  _repayDetail(state.loanProdResponse.prod),

                                  SizedBox(height: 30.0),

                                  /// Хүлээн авах данс сонгох
                                  // Caption
                                  lbl(globals.text.selectToAcnt().toUpperCase(),
                                      style: lblStyle.Caption,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: AppHelper.margin)),

                                  SizedBox(height: 15.0),

                                  // Combobox
                                  Container(
                                      child: _bankAcntCombo(),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: AppHelper.margin)),

                                  SizedBox(height: 30.0),

                                  /// Button Баталгаажуулах
                                  _btnConfirm(),

                                  SizedBox(height: 30.0),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calcTotalRepayAmt() {
    setState(() {
      /// Шимтгэлийн хувь
      _feePercent = _getFeePercent(_term);

      /// Шимтгэл
//      _feeAmt = _amtSliderValue * (_feePercent * 0.01) * _term;
      _feeAmt = _amtSliderValue * (_feePercent * 0.01);

      /// Нийт төлөх дүн
      _totalRepayAmt = _amtSliderValue + _feeAmt;
    });
  }

  void _decreaseFee() {
    //
  }

  double _getFeePercent(int termSize) {
    double result = 0.0;

    if (globals.feeScore != null &&
        globals.feeScore.fees != null &&
        globals.feeScore.fees.isNotEmpty &&
        globals.feeScore.fees[0].feeTerms != null) {
      for (var el in globals.feeScore.fees[0].feeTerms) {
        if (el.termSize == termSize) {
          result = el.feeSize;
          break;
        }
      }
    }

    return result;
  }

  void _increaseLimit() {}

  Widget _repayDetail(Prod prod) {
    return CustomCard(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  lbl('${Func.toMoneyStr(_totalRepayAmt)} ${Func.toCurSymbol(prod.curCode)}',
                      style: lblStyle.Medium, fontWeight: FontWeight.w500),
                  SizedBox(height: 5.0),
                  lbl(globals.text.totalRepayAmt(),
                      fontSize: AppHelper.fontSizeCaption,
                      color: AppColors.lblGrey)
                ],
              ),

              /// Босоо зураас
              Container(
                width: 1.0,
                height: 50.0,
                color: Color(0XFF8D98AB),
                margin: EdgeInsets.only(
                    top: 10.0, right: 30.0, bottom: 10.0, left: 30.0),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        lbl(globals.text.repayDate(),
                            fontSize: AppHelper.fontSizeCaption,
                            color: AppColors.lblGrey),
                        Expanded(
                          child: lbl(
                            '$_repayDate',
                            style: lblStyle.Medium,
                            fontWeight: FontWeight.w500,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        lbl(globals.text.fee(),
                            fontSize: AppHelper.fontSizeCaption,
                            color: AppColors.lblGrey),
                        Expanded(
                          child: lbl(
                            '${Func.toMoneyStr(_feeAmt)} ${Func.toCurSymbol(prod.curCode)}',
                            style: lblStyle.Medium,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Net point
  int _sliderStepAmt = 0;

  Widget _netPointWidget(Prod prod) {
    _sliderStepAmt = globals.feeScore.useMinScore;

    return (globals.feeScore.bonusScore >= globals.feeScore.useMinScore)
        ? CustomCard(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: <Widget>[
//          SizedBox(height: 15.0),

//          // Caption
                lbl('Netpoint:  ${globals.feeScore.bonusScore}',
                    style: lblStyle.Normal),
//
//          lbl('Шимтгэл бууруулах', style: lblStyle.Normal),
//
                SizedBox(height: 15.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        lbl('${Func.toMoneyStr(globals.onlineLoanList.curLimit)} ${Func.toCurSymbol(prod.curCode)}',
                            style: lblStyle.Medium,
                            fontWeight: FontWeight.w500),
                        SizedBox(height: 5.0),
                        lbl(globals.text.loanLimit(),
                            fontSize: AppHelper.fontSizeCaption,
                            color: AppColors.lblGrey)
                      ],
                    ),
                    CustomButton(
                      icon: Icon(Icons.add,
                          color: AppColors.iconWhite, size: 20.0),
                      isUppercase: false,
//                text: 'Нэмэгдүүлэх',
                      borderRadius: 25.0,
                      height: 25.0,
                      width: 25.0,
                      context: context,
                      margin: EdgeInsets.all(0.0),
                      color: AppColors.bgBlue,
                      disabledColor: AppColors.btnBlue,
                      textColor: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      onPressed: () {
                        _decreaseFee();
                      },
                    ),
                  ],
                ),

                SizedBox(height: 15.0),

                /// Amount slider
                lbl(globals.text.loanLimit().toUpperCase(),
                    style: lblStyle.Caption),

                SizedBox(height: 20.0),

                CustomSlider(
                  onChanged: (val) {
                    _amtSliderValue = val.toDouble();
                    _calcTotalRepayAmt();
                  },
                  unitType: Func.toCurSymbol('MNT'),
                  minValue: prod.minAmt,
                  stepValue: _sliderStepAmt,
                  maxValue: (_loanLimit < prod.maxAmt)
                      ? _loanLimit.toInt()
                      : prod.maxAmt,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        lbl('${Func.toMoneyStr(_feeAmt)} ${Func.toCurSymbol(prod.curCode)}',
                            style: lblStyle.Medium,
                            fontWeight: FontWeight.w500),
                        SizedBox(height: 5.0),
                        lbl(globals.text.fee(),
                            fontSize: AppHelper.fontSizeCaption,
                            color: AppColors.lblGrey)
                      ],
                    ),
                    CustomButton(
                      icon: Icon(Icons.remove,
                          color: AppColors.iconWhite, size: 20.0),
                      isUppercase: false,
//                text: 'Бууруулах',
                      borderRadius: 25.0,
                      height: 25.0,
                      width: 25.0,
                      context: context,
                      margin: EdgeInsets.all(0.0),
                      color: AppColors.bgBlue,
                      disabledColor: AppColors.btnBlue,
                      textColor: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      onPressed: () {
                        _decreaseFee();
                      },
                    ),
                  ],
                ),

                SizedBox(height: 10.0),
              ],
            ),
          )
        : Container();
  }

  Widget _bankAcntCombo() {
//    _bankAcntComboList = null;

    return (_bankAcntComboList != null && _bankAcntComboList.isNotEmpty)
        ? SimpleCombo(
            list: _bankAcntComboList,
            icon: Icon(Icons.keyboard_arrow_down, size: AppHelper.iconSize),
            onItemSelected: (value) {
              _selectedBankAcntNo = (value as BankAcnt).acntNo;
              _selectedBankCode = (value as BankAcnt).bankCode;
              _selectedBankName = (value as BankAcnt).bankName;

              _checkEnabledBtnConfirm();
            },
          )
        : SimpleComboHolder(
            icon: Icon(Icons.add,
                size: AppHelper.iconSize, color: AppColors.iconBlue),
            onTap: () => Navigator.push(
                context, FadeRouteBuilder(route: AddBankAcntRoute())),
          );
  }

  void _checkEnabledBtnConfirm() {
    bool result = false;

    if (Func.isNotEmpty(_selectedBankAcntNo)) {
      result = true;
    }

    setState(() => _enabledBtnConfirm = result);
  }

  Widget _btnConfirm() {
    return CustomButton(
      text: globals.text.confirm(),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnGreyDisabled,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: _enabledBtnConfirm ? _onPressedBtnConfirm : null,
    );
  }

  _onPressedBtnConfirm() {
    Navigator.push(
      context,
      FadeRouteBuilder(
        route: LoanConfirmRoute(
          prodName: _loanProdResponse?.prod?.name ?? '',
          reqAmt: _amtSliderValue,
          termSize: _term,
          feeAmt: _feeAmt,
          totalRepayAmt: _totalRepayAmt,
          repayDate: Func.toDateStr(
              DateTime.now().add(Duration(days: _term)).toString()),
          bankCode: _selectedBankCode,
          bankName: _selectedBankName,
          bankAcntNo: _selectedBankAcntNo,
        ),
      ),
    );
  }

  _onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
