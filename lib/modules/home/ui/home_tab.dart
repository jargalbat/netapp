import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/app/bloc/fee_score_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/modules/loan/ui/get_loan_route.dart';
import 'package:netware/modules/loan/ui/offline_loan_list_widget.dart';
import 'package:netware/modules/login/login_helper.dart';
import 'package:netware/modules/notification/bloc/notif_bloc.dart';
import 'package:netware/modules/notification/ui/notification_route.dart';
import 'package:netware/modules/settings/ui/branch_route.dart';
import 'online_loan_list_widget.dart';

class HomeTab extends StatefulWidget {
  HomeTab({this.scaffoldKey});

  final scaffoldKey;

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  /// Notification
  int _notifCount = 0;

  /// Зээлийн дэлгэрэнгүй мэдээлэл
  double _loanLimit; // Боломжит зээлийн хэмжээ
  int _netPoint; // Net point
  double _loanTotalBal; // Нийт зээлийн үлдэгдэл
  int _activeLoanCount; // Идэвхтэй зээлийн тоо

  /// Button - Зээлийн эрх нээх
  bool _visibleBtnLoanPrivilege = false;

  /// Button - Зээл авах
  bool _visibleBtnLoanApplication = false;

  /// Tab bar
  final double _tabBarHeightMultiplier = 3;
  double _tabBarHeight;

  @override
  void initState() {
    _tabBarHeight = AppHelper.listItemHeightLoan * _tabBarHeightMultiplier;

    super.initState();

    BlocProvider.of<AcntBloc>(context).add(GetOnlineLoanList());
//    BlocProvider.of<AcntBloc>(context).add(GetOfflineLoanList());

    BlocProvider.of<FeeScoreBloc>(context).add(GetFeeScore());

    _visibleBtnLoanPrivilege = (globals.user.isValidated == 0);
    _visibleBtnLoanApplication = !_visibleBtnLoanPrivilege;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Bloc listener
    return MultiBlocListener(
      listeners: [
        BlocListener<AcntBloc, AcntState>(
          listener: (context, state) {
            if (state is OnlineLoanListSuccess) {
              _loanLimit = state.onlineLoanListResponse.curLimit ?? 0.0;
              _netPoint = state.onlineLoanListResponse.bonusScore ?? 0;
//              BlocProvider.of<AcntBloc>(context).add(CalcLoanTotalBal());

              _calcLoanTotalBal();
            } else if (state is CalculatedLoanTotalBal) {
              _loanTotalBal = state.loanTotalBal;
              _activeLoanCount = state.activeLoanCount;

              // Tab bar height
              _calcTabBarHeight(state);
            }
          },
        ),
      ],

      /// Bloc builder
      child: BlocBuilder<AcntBloc, AcntState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _calcLoanTotalBal() {
    double loanTotalBal = 0.0;
    int onlineLoanCount = 0;
    int offlineLoanCount = 0;
    int activeLoanCount = 0;

    // Онлайн зээл
    if (globals.onlineLoanList != null) {
      // Total bal
      loanTotalBal += (globals.onlineLoanList.curLoanTotalBal ?? 0.0);

      // Active loan count
      if (globals.onlineLoanList.acnts != null) {
        onlineLoanCount += globals.onlineLoanList.acnts.length;
      }
    }

    // Оффлайн зээл
    if (globals.offlineLoanList != null) {
      // Total bal
      loanTotalBal += (globals.offlineLoanList.curLoanTotalBal ?? 0.0);

      // Active loan count
      if (globals.offlineLoanList.acnts != null) {
        offlineLoanCount = globals.offlineLoanList.acnts.length;
      }
    }

    activeLoanCount = onlineLoanCount + offlineLoanCount;

    setState(() {
      _loanTotalBal = loanTotalBal;
      _activeLoanCount = activeLoanCount;
    });
  }

  void _calcTabBarHeight(CalculatedLoanTotalBal state) {
    _tabBarHeight = AppHelper.listItemHeightLoan;
    if (state.onlineLoanCount == 0 && state.offlineLoanCount == 0) {
      _tabBarHeight *= _tabBarHeightMultiplier; // Place holder
    } else if (state.onlineLoanCount >= state.offlineLoanCount) {
      if (state.offlineLoanCount > _tabBarHeightMultiplier) {
        _tabBarHeight *= state.onlineLoanCount;
      } else {
        _tabBarHeight *= _tabBarHeightMultiplier; // Place holder
      }
    } else {
      if (state.offlineLoanCount > _tabBarHeightMultiplier) {
        _tabBarHeight *= state.onlineLoanCount;
      } else {
        _tabBarHeight *= state.offlineLoanCount; // Place holder
      }
    }
  }

  Widget _blocBuilder(BuildContext context, AcntState state) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarEmpty(
            context: context,
            brightness: Brightness.light,
            backgroundColor: AppColors.bgGrey,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),

                /// Header
                _header(),

                SizedBox(height: 20.0),

                /// Боломжит зээлийн хэмжээ, зээлийн үлдэгдэл
                _loanInfoCard(),

                SizedBox(height: AppHelper.margin),

                /// Зээлийн эрх нээх
                Visibility(child: _btnLoanPrivilege(), visible: _visibleBtnLoanPrivilege),

                /// Зээл авах
                Visibility(child: _btnLoanApplication(), visible: _visibleBtnLoanApplication),

                SizedBox(height: AppHelper.margin),

                /// Tab bar
                Container(
                  color: AppColors.bgWhite,
                  child: TabBar(
                    labelPadding: EdgeInsets.all(0.0),
                    labelColor: AppColors.lblBlue,
                    //Selected
                    labelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
                    unselectedLabelColor: AppColors.lblGrey,
//                  controller: tabController,
                    indicatorColor: Colors.transparent,
//                  indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(child: Text(globals.text.collateralLoan())),
                      Tab(child: Text(globals.text.microLoan())),
                    ],
                  ),
                ),

                Container(height: 1.0, color: AppColors.lineGreyCard),

                /// Tab bar view
                Container(
                  height: _tabBarHeight,
                  child: TabBarView(
                    children: [
                      OfflineLoanListWidget(scaffoldKey: widget.scaffoldKey),
                      OnlineLoanListWidget(scaffoldKey: widget.scaffoldKey),
                    ],
                  ),
                ),

                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(
        right: AppHelper.margin,
        left: AppHelper.margin,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Logo
          Image.asset(
            AssetName.net_capital_logo,
            width: 160.0,
            colorBlendMode: BlendMode.modulate,
          ),

          Expanded(child: Container()),

          /// Notification
//          _notifWidget(),

          /// Logout button
          InkWell(
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(
                Icons.power_settings_new,
                color: AppColors.iconRegentGrey,
              ),
            ),
            onTap: () {
              LoginHelper.showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _notifWidget() {
    return BlocListener<NotifBloc, NotifState>(
      listener: (context, state) {
        if (state is NotifCountChanged) {
          _notifCount = state.notifCount;
        }
      },
      child: BlocBuilder<NotifBloc, NotifState>(
        builder: (context, state) {
          return InkWell(
            onTap: () {
              Navigator.push(context, FadeRouteBuilder(route: NotifRoute()));
            },
            child: Stack(
              children: <Widget>[
                /// Email icon
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Image.asset(
                    AssetName.mail,
                    color: AppColors.iconRegentGrey,
                    height: 16.0,
                  ),
                ),

                /// Notification count badge
                (_notifCount != null && _notifCount > 0)
                    ? Positioned(
                        right: 0,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$_notifCount',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _loanInfoCard() {
    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      padding: EdgeInsets.all(AppHelper.margin),
      child: Container(
//        height: 150.0,
        child: Column(
          children: <Widget>[
            /// Боломжит зээлийн хэмжээ
            lbl(globals.text.availableLoanAmount(), style: lblStyle.Medium),

            // Value
            _loanLimit != null ? FadeIn(child: lbl('${Func.toMoneyStr(_loanLimit)}${Func.toCurSymbol('MNT')}', fontSize: 28.0), delay: 0, begin: 0, end: 0) : lbl('', fontSize: 28.0),

            /// Net point
            _netPoint != null ? FadeIn(child: lbl('Netpoint: ${Func.toMoneyStr(_netPoint)}', color: AppColors.lblGrey, fontSize: AppHelper.fontSizeCaption), delay: 0, begin: 0, end: 0) : lbl('', fontSize: AppHelper.fontSizeCaption),

            SizedBox(height: 8.0),

            /// Хөндлөн зураас
            Divider(color: AppColors.lineLightGrey),

            SizedBox(height: 8.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Caption
                      lbl(globals.text.loanAmount(), color: AppColors.lblGrey, fontSize: AppHelper.fontSizeCaption),

                      /// Зээлийн үлдэгдэл - Value
                      _loanTotalBal != null ? FadeIn(child: lbl('${Func.toMoneyStr(_loanTotalBal)}${Func.toCurSymbol('MNT')}', fontSize: 22.0), delay: 0, begin: 0, end: 0) : lbl('', fontSize: 22.0)
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Caption
                    lbl(globals.text.activeLoan(), color: AppColors.lblGrey, fontSize: AppHelper.fontSizeCaption),

                    /// Зээлийн үлдэгдэл - Value
                    _activeLoanCount != null ? FadeIn(child: lbl('${Func.toStr(_activeLoanCount)}', fontSize: 22.0), delay: 0, begin: 0, end: 0) : lbl('', fontSize: 22.0)
                  ],
                ),
//                Image.asset(AssetName.up_arrow_alt, color: AppColors.blue, height: 11.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnLoanPrivilege() {
    return CustomButton(
      text: globals.text.getLoanPrivilege(),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      color: AppColors.bgGreyLight,
      disabledColor: AppColors.bgGreyLight,
      textColor: AppColors.lblBlue,
      disabledTextColor: AppColors.lblBlue,
      fontSize: AppHelper.fontSizeMedium,
      fontWeight: FontWeight.w500,
      onPressed: () => Navigator.push(context, FadeRouteBuilder(route: BranchRoute())),
//      onPressed: null, //todo
    );
  }

  Widget _btnLoanApplication() {
    return CustomButton(
      text: Func.toStr(globals.text.getLoan()),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
//      onPressed: (globals.feeScore != null) ? () => Navigator.push(context, FadeRouteBuilder(route: GetLoanRoute())) : null,
      onPressed: () => Navigator.push(context, FadeRouteBuilder(route: GetLoanRoute())),
//      onPressed: (globals.onlineLoanList != null) ? () => Navigator.push(context, FadeRouteBuilder(route: ComingSoonRoute())) : null,
    );
  }
}
