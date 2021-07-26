import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/loan/loan_list_response.dart';
import 'package:netware/api/models/loan/offline_loan_list_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/app/bloc/acnt_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/home/bloc/home_bloc.dart';
import 'package:netware/modules/loan/ui/acnt_detail_route.dart';
import 'package:netware/app/bloc/bloc_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OfflineLoanListWidget extends StatefulWidget {
  OfflineLoanListWidget({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey scaffoldKey;

  @override
  _OfflineLoanListWidgetState createState() => _OfflineLoanListWidgetState();
}

class _OfflineLoanListWidgetState extends State<OfflineLoanListWidget>
    with AutomaticKeepAliveClientMixin<OfflineLoanListWidget> {
  /// Data
  OfflineLoanListResponse _offlineLoanListResponse;

  @override
  bool get wantKeepAlive => true;

  /// UI
  bool _visibleOfflineLnAcntList = false;

  /// Refresh
  RefreshController _refreshControllerOffline =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    BlocProvider.of<AcntBloc>(context).add(GetOfflineLoanList());
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
    if (state is OfflineLoanListSuccess) {
      _offlineLoanListResponse = state.offlineLoanListResponse;
      _visibleOfflineLnAcntList = (_offlineLoanListResponse.acnts != null &&
          _offlineLoanListResponse.acnts.length > 0);
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
        controller: _refreshControllerOffline,
        onRefresh: () => _onRefresh(),
        onLoading: () => _refreshControllerOffline.loadComplete(),
        child: CustomCard(
//      margin: EdgeInsets.fromLTRB(0.0, AppHelper.margin, 0.0, AppHelper.marginBottom),
          borderRadius: 0.0,
          child: LoadingContainer(
            loading: state is OfflineLoanListLoading,
            height: 138.0,
            child: Column(
              children: <Widget>[
                /// Идэвхтэй зээл, дэлгэрэнгүй
                _onlineLoanList(state),
              ],
            ),
          ),
        ));
  }

  void _onRefresh() async {
    /// SCROLL UP

    // Remove cache
//    app.expireTime.investmentList = null;

    // Get data
    BlocProvider.of<AcntBloc>(context).add(GetOfflineLoanList());

    // Loading
//    await Future.delayed(Duration(milliseconds: 500));

    // Idle
    _refreshControllerOffline.refreshCompleted();

    // if failed,use refreshFailed()
  }

  Widget _onlineLoanList(AcntState state) {
    return Column(
      children: <Widget>[
        Visibility(
          child: lbl(
            globals.text.noActiveLoan(),
            margin: EdgeInsets.fromLTRB(
                AppHelper.margin, 20.0, AppHelper.margin, 0.0),
            alignment: Alignment.center,
            fontSize: AppHelper.fontSizeMedium,
          ),
          visible:
              ((globals.currentBlocEvent != BlocHelper.OnlineLoanListLoading) &&
                  !(state is OfflineLoanListLoading) &&
                  !_visibleOfflineLnAcntList),
        ),

        /// Зээлийн данснууд
        Visibility(
            child: _lnAcntListWidget(), visible: _visibleOfflineLnAcntList),
      ],
    );
  }

  Widget _lnAcntListWidget() {
    Widget result = Container();
    if (_offlineLoanListResponse != null &&
        _offlineLoanListResponse?.acnts != null &&
        _offlineLoanListResponse.acnts.isNotEmpty) {
      result = Column(
        children: <Widget>[
          for (int i = 0; i < _offlineLoanListResponse.acnts.length; i++)
            _listItemAcnt(offlineAcnt: _offlineLoanListResponse.acnts[i]),
        ],
      );
    }

    return result;
  }

  Widget _listItemAcnt({Acnt offlineAcnt}) {
    return FadeIn(
      delay: 0,
      begin: 0,
      end: 0,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              FadeRouteBuilder(
                  route: AcntDetailRoute(offlineAcnt: offlineAcnt)));
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
                  height: 35.0,
                  width: 35.0,
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
                  lbl('${Func.toMoneyStr(offlineAcnt.princBal ?? 0.0)}₮',
                      fontSize: AppHelper.fontSizeMedium,
                      alignment: Alignment.centerLeft),
//                  lbl(
//                    '${offlineAcnt.termSize} ${globals.text.daysRemaining()}',
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
                            text: (offlineAcnt.isExpired == AcntClass.Normal)
                                ? '${Func.toStr(offlineAcnt.nextPayAsDay?.abs())} ${globals.text.daysRemaining()}' // хоног үлдсэн
                                : '${Func.toStr(offlineAcnt.expiredDay?.abs())} ${globals.text.daysOvertime()}', // хоног хэтэрсэн
                            style: new TextStyle(
                              color: (offlineAcnt.isExpired == AcntClass.Normal)
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
                  child: _repayLoanButton(offlineAcnt),
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
        onPressed: () {
          Navigator.push(context,
              FadeRouteBuilder(route: AcntDetailRoute(offlineAcnt: acnt)));
        });
  }
}
