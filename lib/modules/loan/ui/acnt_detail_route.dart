import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/acnt/get_acnt_detail_response.dart';
import 'package:netware/api/models/loan/offline_pay_info_response.dart';
import 'package:netware/api/models/loan/online_pay_info_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/bloc/acnt_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/bottom_sheet_dialogs.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/cards/row_item.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/loan/bloc/acnt_detail_bloc.dart';
import 'package:netware/modules/loan/ui/extend_loan_widget.dart';
import 'package:netware/modules/loan/ui/loan_schedule_widget.dart';
import 'package:netware/modules/qpay/qpay_widget.dart';

/// Дансны дэлгэрэнгүй, Зээл төлөх
class AcntDetailRoute extends StatefulWidget {
  AcntDetailRoute({Key key, this.onlineAcnt, this.offlineAcnt});

  final Acnt onlineAcnt;
  final Acnt offlineAcnt;

  @override
  _AcntDetailRouteState createState() => _AcntDetailRouteState();
}

class _AcntDetailRouteState extends State<AcntDetailRoute> {
  // UI
  final _acntDetailKey = GlobalKey<ScaffoldState>();
  final _titleHeight = 55.0;
  double _statusBarHeight = 20.0;
  double _headerHeight = 0.0;

  // Data
  final _acntDetailBloc = AcntDetailBloc();
  AcntDetailResponse _acntDetail;
  OfflinePayInfoResponse _offlinePayInfoResponse;
  OnlinePayInfoResponse _onlinePayInfoResponse;

  // Хүлээн авах дансны жагсаалт
  List<ComboItem> _rcvAcntList = [];

  // Зээл төлөх
  bool _enabledBtnRepay = true;

  // Зээл сунгах
  bool _enabledBtnExtend = true;

  @override
  void initState() {
    _headerHeight = kToolbarHeight + _titleHeight + _statusBarHeight;

    if (widget.onlineAcnt != null) {
      _acntDetailBloc.add(GetOnlineAcntDetailEvent(onlineAcntNo: widget.onlineAcnt.acntNo));
    } else {
      _acntDetailBloc.add(GetOfflineAcntDetailEvent(offlineAcntNo: widget.offlineAcnt.acntNo));
    }

    super.initState();
  }

  @override
  void dispose() {
    _acntDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AcntDetailBloc>(
      create: (context) => _acntDetailBloc,
      child: BlocListener<AcntDetailBloc, AcntDetailState>(
        listener: _blocListener,
        child: BlocBuilder<AcntDetailBloc, AcntDetailState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AcntDetailState state) {
    if (state is AcntDetailSuccess) {
      _acntDetail = state.acntDetail;
    } else if (state is AcntDetailFailed) {
      setState(() => _enabledBtnRepay = true);
      showSnackBar(key: _acntDetailKey, text: state.text);
    } else if (state is PayInfoOnlineSuccess) {
      setState(() => _enabledBtnRepay = true);
      _rcvAcntList = state.rcvAcntList;
      _onlinePayInfoResponse = state.onlinePayInfoResponse;
      _navigateToQPay();
      print('');
    } else if (state is PayInfoOnlineFailed) {
      setState(() => _enabledBtnRepay = true);
      showSnackBar(key: _acntDetailKey, text: state.text);
    } else if (state is PayInfoOfflineSuccess) {
      setState(() => _enabledBtnRepay = true);
      _rcvAcntList = state.rcvAcntList;
      _offlinePayInfoResponse = state.offlinePayInfoResponse;
      _navigateToQPay();
    } else if (state is PayInfoOfflineFailed) {
      setState(() => _enabledBtnRepay = true);
      showSnackBar(key: _acntDetailKey, text: state.text);
    } else if (state is ExtendInfoSuccess) {
      DialogHelper.showBottomSheetDialog(
        context: context,
        height: MediaQuery.of(context).size.height - _headerHeight,
        child: ExtendLoanWidget(
          scaffoldKey: _acntDetailKey,
          acnt: widget.onlineAcnt,
          height: MediaQuery.of(context).size.height - _headerHeight,
          extendInfoResponse: state.extendInfoResponse,
          rcvAcntList: state.rcvAcntList,
        ),
      );
    } else if (state is ExtendInfoFailed) {
      showSnackBar(key: _acntDetailKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, AcntDetailState state) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: LoadingContainer(
        loading: state is AcntDetailLoading,
        child: Scaffold(
          appBar: AppBarSimple(
            context: context,
            brightness: Brightness.light,
            onPressed: () {
              Navigator.pop(context);
            },
            hasBackArrow: true,
          ),
          key: _acntDetailKey,
          backgroundColor: AppColors.bgGrey,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  /// Зээлийн дэлгэрэнгүй
                  CustomCard(
                    color: AppColors.bgGreyLight,
                    margin: EdgeInsets.fromLTRB(AppHelper.margin, 5, AppHelper.margin, AppHelper.margin),
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        /// Зээлийн дэлгэрэнгүй
                        lbl(
                          globals.text.loanDetail().toUpperCase(),
                          color: AppColors.lblBlue,
                          fontSize: AppHelper.fontSizeMedium,
                          fontWeight: FontWeight.w500,
                          alignment: Alignment.center,
                        ),

                        Container(height: 1.0, color: AppColors.lineGreyCard, margin: EdgeInsets.all(AppHelper.margin)),

                        /// Online acnt detail
                        if (widget.onlineAcnt != null)
                          _onlineAcntDetail(state),

                        /// Offline acnt detail
                        if (widget.offlineAcnt != null)
                          _offlineAcntDetail(state),

                        SizedBox(height: 30.0),

                        /// Төлбөрийн хуваарь
                        _btnSchedule(),
                      ],
                    ),
                  ),

                  SizedBox(height: AppHelper.margin),

                  /// Buttons

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// Button - Хугацаа сунгах
                      if (widget.onlineAcnt != null)
                        Expanded(child: _btnExtend(state)),

                      /// Button - Зээл төлөх
                      Expanded(child: _btnRepay(state)),
                    ],
                  ),

                  SizedBox(height: AppHelper.marginBottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _onlineAcntDetail(AcntDetailState state) {
    return Column(
      children: <Widget>[
//        /// Дүн
//        _totalCurPayAmt(),
//
//        /// Ангилал
//        _acntClass(),

//        SizedBox(height: AppHelper.margin),

        /// Данс
        RowItem(caption: '${globals.text.acnt()}:', value: (_acntDetail != null) ? Func.toStr(_acntDetail.acntNo) : ''),

        SizedBox(height: AppHelper.margin),

        /// Зээлийн төлөв
        RowItem(caption: '${globals.text.loanStatus()}:', value: (_acntDetail != null) ? AcntHelper.getStatusName(_acntDetail.status) : ''),

        SizedBox(height: AppHelper.margin),

        /// Зээлийн үлдэгдэл
        RowItem(
          caption: '${globals.text.loanAmount()}:',
          value: (_acntDetail != null) ? '${Func.toMoneyStr(_acntDetail.princBal)}${Func.toCurSymbol(_acntDetail.curCode)}' : '',
        ),

        SizedBox(height: AppHelper.margin),

        /// Төлсөн
        RowItem(
          caption: '${globals.text.paid()}:',
          value: (_acntDetail != null) ? '${Func.toMoneyStr(_acntDetail.basePaidAmt)}${Func.toCurSymbol(_acntDetail.curCode)}' : '',
        ),

        SizedBox(height: AppHelper.margin),

        /// Шимтгэл
        RowItem(
          caption: '${globals.text.fee()}:',
          value: (_acntDetail != null) ? '${Func.toMoneyStr(_acntDetail.feePayBal)}${Func.toCurSymbol(_acntDetail.curCode)}' : '',
        ),

        SizedBox(height: AppHelper.margin),

        /// Алданги
        RowItem(
          caption: '${globals.text.lateCharge()}:',
          value: (_acntDetail != null) ? '${Func.toMoneyStr(_acntDetail.fineintDebtBal)}${Func.toCurSymbol(_acntDetail.curCode)}' : '',
        ),

        SizedBox(height: AppHelper.margin),

        /// Авсан огноо
        RowItem(caption: '${globals.text.advanceDate()}:', value: (_acntDetail != null) ? Func.toDateStr(_acntDetail.advDatetime) : ''),

        SizedBox(height: AppHelper.margin),

        /// Үлдсэн хоног
        RowItem(
            caption: '${globals.text.remainingDays()}:',
            value: (_acntDetail != null)
                ? ((globals.langCode == LangCode.mn) ? '${_acntDetail.expiredDay} хоног' : '${_acntDetail.expiredDay} days')
                : ''),

        SizedBox(height: AppHelper.margin),

        /// Дараагийн төлөх огноо
        RowItem(caption: '${globals.text.nextDuePayment()}:', value: (_acntDetail != null) ? Func.toDateStr(_acntDetail.nextPayDay) : ''),

        SizedBox(height: AppHelper.margin),

        /// Дуусах огноо
        RowItem(caption: '${globals.text.endDate()}:', value: (_acntDetail != null) ? Func.toDateStr(_acntDetail.endDate) : ''),
      ],
    );
  }

  Widget _offlineAcntDetail(AcntDetailState state) {
    return Column(
      children: <Widget>[
        /// Энэ сард төлөх
        lbl(globals.text.thisMonthsPayment(),
            margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
            alignment: Alignment.center,
            fontSize: 12.0,
            color: AppColors.lblGrey),

        /// Дүн
        _totalCurPayAmt(),

        /// Ангилал
        _acntClass(),

        SizedBox(height: AppHelper.margin),

        /// Данс
        RowItem(caption: '${globals.text.acnt()}:', value: (_acntDetail != null) ? Func.toStr(_acntDetail.acntNo) : ''),

        SizedBox(height: AppHelper.margin),

        /// Бүтээгдэхүүн
        RowItem(caption: '${globals.text.product()}:', value: (_acntDetail != null) ? Func.toStr(_acntDetail.prodName) : ''),

        SizedBox(height: AppHelper.margin),

        /// Зээлийн үлдэгдэл
        RowItem(
            caption: '${globals.text.loanAmount()}:',
            value: (_acntDetail != null) ? '${Func.toMoneyStr(_acntDetail.princBal)}${Func.toCurSymbol(_acntDetail.curCode)}' : ''),

        SizedBox(height: AppHelper.margin),

        /// Төлсөн
        RowItem(
            caption: '${globals.text.paid()}:',
            value: (_acntDetail != null) ? '${Func.toMoneyStr(_acntDetail.basePaidAmt)}${Func.toCurSymbol(_acntDetail.curCode)}' : ''),

        SizedBox(height: AppHelper.margin),

        /// Хэтэрсэн хугацаа
        RowItem(
            caption: '${globals.text.excessDate()}:', value: (_acntDetail != null) ? '${Func.toStr(_acntDetail.expiredDay)} хоног' : ''),

        SizedBox(height: AppHelper.margin),

        /// Нэмэгдүүлсэн хүү
        RowItem(
            caption: '${globals.text.increasedInterest()}:',
            value: (_acntDetail != null) ? '${Func.toMoneyStr(_acntDetail.fineintDebtBal)}${Func.toCurSymbol(_acntDetail.curCode)}' : ''),
      ],
    );
  }

  Widget _totalCurPayAmt() {
    return (_acntDetail != null)
        ? FadeInSlow(
            delay: 0,
            child: lbl(
              '${Func.toMoneyStr(_acntDetail.totalCurPayAmt)}${Func.toCurSymbol(_acntDetail.curCode)}',
              style: lblStyle.Headline4,
              margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
              alignment: Alignment.center,
            ),
          )
        : lbl('', style: lblStyle.Headline4, margin: EdgeInsets.symmetric(horizontal: AppHelper.margin), alignment: Alignment.center);
  }

  Widget _acntClass() {
    return Container(
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, AppHelper.margin),
      child: RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
          style: new TextStyle(fontSize: 12.0, color: AppColors.lblGrey),
          children: <TextSpan>[
            TextSpan(text: '${globals.text.status()}: ', style: new TextStyle(color: AppColors.lblGrey)),
            TextSpan(
              text: (_acntDetail != null) ? AcntHelper.getClassName(_acntDetail.isExpired) : '',
              style: new TextStyle(
                color: (_acntDetail != null && _acntDetail.isExpired == AcntClass.Normal) ? AppColors.jungleGreen : AppColors.lblRed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnSchedule() {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: AppColors.btnGrey,
      disabledColor: AppColors.btnGrey,
      child: Container(
        width: 160.0,
        child: lbl(
          '${globals.text.paymentSchedule()}'.toUpperCase(),
          fontSize: 12.0,
          alignment: Alignment.center,
        ),
      ),
      onPressed: _acntDetail != null
          ? () {
              _onPressedBtnSchedule();
            }
          : null,
    );
  }

  Widget _btnExtend(AcntDetailState state) {
    return CustomButton(
      context: context,
      text: globals.text.extendLoan(),
      isUppercase: false,
      margin: EdgeInsets.only(left: AppHelper.margin, right: AppHelper.margin),
      color: AppColors.bgWhite,
      textColor: AppColors.lblGrey,
      fontSize: AppHelper.fontSizeMedium,
      fontWeight: FontWeight.w500,
      onPressed: () {
        if (_enabledBtnExtend && _acntDetail != null) {
          _acntDetailBloc.add(GetExtendLoanInfo(acntNo: widget.onlineAcnt.acntNo));
        }
      },
    );
  }

  Widget _btnRepay(AcntDetailState state) {
    return CustomButton(
      context: context,
      text: globals.text.repayLoan(),
      isUppercase: false,
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      color: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: AppHelper.fontSizeMedium,
      fontWeight: FontWeight.w500,
      onPressed: (_acntDetail != null && _enabledBtnRepay)
          ? () {
              setState(() => _enabledBtnRepay = false);
              if (widget.onlineAcnt != null) {
                _acntDetailBloc.add(GetPayInfoOnlineEvent(onlineAcntNo: widget.onlineAcnt.acntNo));
              } else if (widget.offlineAcnt.acntNo != null) {
                _acntDetailBloc.add(GetPayInfoOfflineEvent(offlineAcntNo: widget.offlineAcnt.acntNo));
              }
            }
          : null,
    );
  }

  void _navigateToQPay() {
    if (_rcvAcntList != null && _rcvAcntList.isNotEmpty) {
      if (_onlinePayInfoResponse != null) {
        /// Online loan
        DialogHelper.showBottomSheetDialog(
          context: context,
          height: MediaQuery.of(context).size.height - _headerHeight,
          child: QPayWidget(
            scaffoldKey: _acntDetailKey,
            title: globals.text.repayLoan(),
            paymentCode: _onlinePayInfoResponse.paymentCode,
            acnt: _onlinePayInfoResponse?.acnt,
            tranAmt: _onlinePayInfoResponse.totalPay,
            tranAmtQpay: _onlinePayInfoResponse.totalPayQpay,
            rcvAcntList: _rcvAcntList,
            termSize: 0,
          ),
        );
      } else if (_offlinePayInfoResponse != null) {
        ///Offline loan
        DialogHelper.showBottomSheetDialog(
          context: context,
          height: MediaQuery.of(context).size.height - _headerHeight,
          child: QPayWidget(
            scaffoldKey: _acntDetailKey,
            title: globals.text.repayLoan(),
            paymentCode: _offlinePayInfoResponse.paymentCode,
            acnt: _offlinePayInfoResponse?.acnt,
            tranAmt: _offlinePayInfoResponse.totalPay,
            tranAmtQpay: _offlinePayInfoResponse.totalPayQpay,
            rcvAcntList: _rcvAcntList,
            termSize: 0,
          ),
        );
      }
    }
  }

  void _onPressedBtnSchedule() {
    if (_acntDetail != null && _acntDetail.sched != null && _acntDetail.sched.isNotEmpty) {
      DialogHelper.showBottomSheetDialog(
        context: context,
        height: MediaQuery.of(context).size.height - _headerHeight,
        child: LoanScheduleWidget(
          sched: _acntDetail.sched,
          height: MediaQuery.of(context).size.height - _headerHeight,
        ),
      );
    } else {
      showSnackBar(key: _acntDetailKey, text: globals.text.noScheduleData());
    }
  }
}
