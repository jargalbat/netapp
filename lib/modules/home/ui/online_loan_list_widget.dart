import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/loan/loan_list_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/app/bloc/acnt_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/bloc/bloc_helper.dart';
import 'package:netware/modules/loan/ui/acnt_detail_route.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OnlineLoanListWidget extends StatefulWidget {
  OnlineLoanListWidget({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey scaffoldKey;

  @override
  _OnlineLoanListWidgetState createState() => _OnlineLoanListWidgetState();
}

//with AutomaticKeepAliveClientMixin {}

class _OnlineLoanListWidgetState extends State<OnlineLoanListWidget>
    with AutomaticKeepAliveClientMixin<OnlineLoanListWidget> {
  /// Data
  OnlineLoanListResponse _onlineLoanListResponse;

  @override
  bool get wantKeepAlive => true;

  /// UI
  bool _visibleLnRequest = false;
  bool _visibleLnAcntList = false;

  /// Refresh
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    BlocProvider.of<AcntBloc>(context).add(GetOnlineLoanList());

    super.initState();
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
    if (state is OnlineLoanListSuccess) {
      _onlineLoanListResponse = state.onlineLoanListResponse;
      _visibleLnRequest = (_onlineLoanListResponse.request != null);
      _visibleLnAcntList = (_onlineLoanListResponse.acnts != null &&
          _onlineLoanListResponse.acnts.length > 0);
      BlocProvider.of<AcntBloc>(context).add(CalcLoanTotalBal());
    } else if (state is OnlineLoanListFailed) {
      showSnackBar(key: widget.scaffoldKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, AcntState state) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
//      header: WaterDropHeader(
//
//      ),
      header: ClassicHeader(
        refreshStyle: RefreshStyle.Behind,
        idleText: "",
        idleIcon:
            Icon(Icons.keyboard_arrow_down, color: AppColors.iconRegentGrey),
        releaseIcon: Icon(Icons.refresh, color: AppColors.iconRegentGrey),
        completeIcon: Icon(Icons.refresh, color: AppColors.iconRegentGrey),
        failedIcon: Icon(Icons.error, color: AppColors.iconRegentGrey),
        releaseText: "",
        refreshingText: "",
        completeText: "",
      ),

      controller: _refreshController,
      onRefresh: () => _onRefresh(),
      onLoading: () => _refreshController.loadComplete(),
      child: CustomCard(
//      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, AppHelper.marginBottom),
        borderRadius: 0.0,
        child: LoadingContainer(
          loading: state is OnlineLoanListLoading,
          height: 138.0,
          child: Column(
            children: <Widget>[
              /// Идэвхтэй зээл, дэлгэрэнгүй
              _onlineLoanList(state),
            ],
          ),
        ),
      ),
    );
  }

  void _onRefresh() async {
    /// SCROLL UP

    // Remove cache
//    app.expireTime.investmentList = null;

    // Get data
    BlocProvider.of<AcntBloc>(context).add(GetOnlineLoanList());

    // Loading
//    await Future.delayed(Duration(milliseconds: 500));

    // Idle
    _refreshController.refreshCompleted();

    // if failed,use refreshFailed()
  }

  Widget _onlineLoanList(AcntState state) {
    return Column(
      children: <Widget>[
        Visibility(
          child: lbl(
            globals.text.noActiveLoans(),
            margin: EdgeInsets.fromLTRB(
                AppHelper.margin, 20.0, AppHelper.margin, 0.0),
            alignment: Alignment.center,
            fontSize: AppHelper.fontSizeMedium,
          ),
          visible: ((globals.currentBlocEvent !=
                  BlocHelper.OfflineLoanListLoading) &&
              !(state is OnlineLoanListLoading) &&
              !_visibleLnRequest &&
              !_visibleLnAcntList),
        ),

        /// Зээлийн хүсэлт
        Visibility(child: _lnRequestWidget(), visible: _visibleLnRequest),

        /// Зээлийн данснууд
        Visibility(child: _lnAcntListWidget(), visible: _visibleLnAcntList),
      ],
    );
  }

  Widget _lnRequestWidget() {
    Widget result = Container();
    if (_onlineLoanListResponse != null &&
        _onlineLoanListResponse.request != null) {
      result = _listItemRequest(lnRequest: _onlineLoanListResponse.request);
    }

    return result;
  }

  Widget _lnAcntListWidget() {
    Widget result = Container();
    if (_onlineLoanListResponse != null &&
        _onlineLoanListResponse?.acnts != null &&
        _onlineLoanListResponse.acnts.isNotEmpty) {
      result = Column(
        children: <Widget>[
          for (int i = 0; i < _onlineLoanListResponse.acnts.length; i++)
            _listItemAcnt(acnt: _onlineLoanListResponse.acnts[i]),
        ],
      );
    }

    return result;
  }

  Widget _listItemRequest({Request lnRequest}) {
    return FadeIn(
      delay: 0,
      begin: 0,
      end: 0,
      child: InkWell(
        onTap: () {
          //Navigator.push(context, FadeRouteBuilder(route: RelativeDetailRoute(relative: relative)));
        },
        child: Container(
          height: AppHelper.listItemHeightLoan,
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.only(
              top: 10.0,
              right: AppHelper.margin,
              bottom: 10.0,
              left: AppHelper.margin),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: AppColors.bgGrey))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /// Icon
              ClipRRect(
                borderRadius: BorderRadius.circular(34.0),
                child: Container(
                  height: 34.0,
                  width: 34.0,
                  color: AppColors.bgGrey,
                  padding: EdgeInsets.all(7.0),
                  child:
                      Image.asset(AssetName.ln_acnt, color: AppColors.iconBlue),
                ),
              ),

              SizedBox(width: AppHelper.margin),

              /// Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  lbl('${Func.toMoneyStr(lnRequest.reqAmt ?? 0.0)}₮',
                      fontSize: AppHelper.fontSizeMedium,
                      alignment: Alignment.centerLeft),
                  lbl(
                    (globals.langCode == LangCode.mn)
                        ? '${lnRequest.termSize} хоног'
                        : '${lnRequest.termSize} days',
                    fontSize: AppHelper.fontSizeCaption,
                    color: AppColors.jungleGreen,
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ),

              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listItemAcnt({Acnt acnt}) {
    return FadeIn(
      delay: 0,
      begin: 0,
      end: 0,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              FadeRouteBuilder(route: AcntDetailRoute(onlineAcnt: acnt)));
        },
        child: Container(
          height: AppHelper.listItemHeightLoan,
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.only(
              top: 10.0,
              right: AppHelper.margin,
              bottom: 10.0,
              left: AppHelper.margin),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: AppColors.bgGrey))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /// Icon
              ClipRRect(
                borderRadius: BorderRadius.circular(34.0),
                child: Container(
                  height: 34.0,
                  width: 34.0,
                  padding: EdgeInsets.all(7.0),
                  color: AppColors.bgGrey,
                  child:
                      Image.asset(AssetName.ln_acnt, color: AppColors.iconBlue),
                ),
              ),

              SizedBox(width: AppHelper.margin),

              /// Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  lbl('${Func.toMoneyStr(acnt.princBal ?? 0.0)}₮',
                      fontSize: AppHelper.fontSizeMedium,
                      alignment: Alignment.centerLeft),
//                  lbl(
//                    (globals.langCode == LangCode.mn) ? '${acnt.termSize} хоног үлдсэн' : '${acnt.termSize} days remaining',
//                    fontSize: AppHelper.fontSizeCaption,
//                    color: AppColors.jungleGreen,
//                    alignment: Alignment.centerLeft,
//                  ),

                  Container(
//                    margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, AppHelper.margin),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        style:
                            new TextStyle(fontSize: 12.0, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: (acnt.isExpired == AcntClass.Normal)
                                ? '${Func.toStr(acnt.nextPayAsDay?.abs())} ${globals.text.daysRemaining()}' // хоног үлдсэн
                                : '${Func.toStr(acnt.expiredDay?.abs())} ${globals.text.daysOvertime()}', // хоног хэтэрсэн
                            style: new TextStyle(
                              color: (acnt.isExpired == AcntClass.Normal)
                                  ? AppColors.jungleGreen
                                  : AppColors.lblRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  child: _repayLoanButton(acnt),
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _repayLoanButton(Acnt acnt) {
    return CustomButton(
        context: context,
        text: globals.text.pay(),
        width: 70.0,
        height: AppHelper.heightBtnSmall,
        isUppercase: false,
        onPressed: () => Navigator.push(context,
            FadeRouteBuilder(route: AcntDetailRoute(onlineAcnt: acnt))));
  }
}
