//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:netware/api/models/loan/limit_fee_score_response.dart';
//import 'package:netware/api/models/loan/loan_list_response.dart';
//import 'package:netware/app/app_helper.dart';
//import 'package:netware/app/assets/image_asset.dart';
//import 'package:netware/app/bloc/acnt_bloc.dart';
//import 'package:netware/app/globals.dart';
//import 'package:netware/app/route_transitions.dart';
//import 'package:netware/app/themes/app_colors.dart';
//import 'package:netware/app/utils/func.dart';
//import 'package:netware/app/widgets/animations.dart';
//import 'package:netware/modules/loan/ui/get_loan_route.dart';
//import 'package:netware/app/widgets/buttons/buttons.dart';
//import 'package:netware/app/widgets/cards/cards.dart';
//import 'package:netware/app/widgets/labels.dart';
//import 'package:netware/modules/loan/ui/offline_loan_list_widget.dart';
//
//import 'online_loan_list_widget.dart';
//
//class HomeTab extends StatefulWidget {
//  HomeTab({this.scaffoldKey});
//
//  final scaffoldKey;
//
//  @override
//  _HomeTabState createState() => _HomeTabState();
//}
//
//class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
//  /// Notification
//  int _notifCount = 0;
//
//  /// Зээлийн дэлгэрэнгүй мэдээлэл
//  double _loanLimit; // Боломжит зээлийн хэмжээ
//  int _netPoint; // Net point
//  double _loanTotalBal; // Нийт зээлийн үлдэгдэл
//  int _activeLoanCount; // Идэвхтэй зээлийн тоо
//
//  /// Button - Зээлийн эрх нээх
//  bool _visibleBtnLoanPrivilege = false;
//
//  /// Button - Зээл авах
//  bool _visibleBtnLoanApplication = false;
//
//  bool fixedScroll = false;
//
//  @override
//  void initState() {
//    super.initState();
//
//    _visibleBtnLoanPrivilege = (globals.user.isValidated == 0);
//    _visibleBtnLoanApplication = !_visibleBtnLoanPrivilege;
//
//    _scrollController = ScrollController();
//    _scrollController.addListener(_scrollListener);
//    _tabController = TabController(length: 2, vsync: this);
//    _tabController.addListener(_smoothScrollToTop);
//  }
//
//  _scrollListener() {
//    if (fixedScroll) {
//      _scrollController.jumpTo(0);
//    }
//  }
//
//  _smoothScrollToTop() {
//    _scrollController.animateTo(
//      0,
//      duration: Duration(microseconds: 300),
//      curve: Curves.ease,
//    );
//
//    setState(() {
//      fixedScroll = _tabController.index == 1;
//    });
//  }
//
//  @override
//  void dispose() {
//    _tabController.dispose();
//    _scrollController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    /// Bloc listener
//    return MultiBlocListener(
//      listeners: [
//        BlocListener<AcntBloc, AcntState>(
//          listener: (context, state) {
//            if (state is OnlineLoanListSuccess) {
//              _loanLimit = state.onlineLoanListResponse.curLimit ?? 0.0;
//              _netPoint = state.onlineLoanListResponse.bonusScore ?? 0;
//            } else if (state is CalculatedLoanTotalBal) {
//              _loanTotalBal = state.loanTotalBal;
//              _activeLoanCount = state.activeLoanCount;
//            }
//          },
//        ),
//      ],
//
//      /// Bloc builder
//      child: BlocBuilder<AcntBloc, AcntState>(
//        builder: _blocBuilder,
//      ),
//    );
//  }
//
//  Widget _buildCarousel() {
//    return Stack(
//      children: <Widget>[
//        Placeholder(fallbackHeight: 100),
//        Positioned.fill(
//            child: Align(
//          alignment: Alignment.center,
//          child: Text('Slider'),
//        )),
//      ],
//    );
//  }
//
//  Widget _buildCarouse2() {
//    return Stack(
//      children: <Widget>[
//        Placeholder(fallbackHeight: 320),
//        Positioned.fill(
//          child: Column(
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              SizedBox(height: 20.0),
//
//              /// Header
//              _header(),
//
//              SizedBox(height: 20.0),
//
//              /// Боломжит зээлийн хэмжээ, зээлийн үлдэгдэл
//              _loanInfoCard(),
//
//              SizedBox(height: AppHelper.margin),
//
//              /// Зээлийн эрх нээх
//              Visibility(child: _btnLoanPrivilege(), visible: _visibleBtnLoanPrivilege),
//
//              /// Зээл авах
//              Visibility(child: _btnLoanApplication(), visible: _visibleBtnLoanApplication),
//
//              SizedBox(height: AppHelper.margin),
//            ],
//          ),
//        ),
//      ],
//    );
//  }
//
//  ScrollController _scrollController;
//  TabController _tabController;
//
//  Widget _blocBuilder(BuildContext context, AcntState state) {
//    return WillPopScope(
//        onWillPop: () async {
//          return Future.value(false);
//        },
//        child: Scaffold(
//          body: NestedScrollView(
//            controller: _scrollController,
//            headerSliverBuilder: (context, value) {
//              return [
//                SliverToBoxAdapter(child: _buildCarouse2()),
//                SliverToBoxAdapter(
//                  child: Container(
//                    color: AppColors.bgWhite,
//                    child: TabBar(
//                      controller: _tabController,
//                      labelPadding: EdgeInsets.all(0.0),
//                      labelColor: AppColors.lblBlue,
//                      //Selected
//                      labelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
//                      unselectedLabelColor: AppColors.lblGrey,
////                  controller: tabController,
//                      indicatorColor: Colors.transparent,
////                  indicatorSize: TabBarIndicatorSize.tab,
//                      tabs: [
//                        Tab(child: Text('Бичил зээл')),
//                        Tab(child: Text('Барьцаат зээл')),
//                      ],
//                    ),
//                  ),
//                ),
//              ];
//            },
//            body: Container(
//              child: TabBarView(
//                controller: _tabController,
//                children: [
//                  OnlineLoanListWidget(scaffoldKey: widget.scaffoldKey),
//                  OfflineLoanListWidget(scaffoldKey: widget.scaffoldKey),
//                ],
//              ),
//            ),
//          ),
//        )
//
////      DefaultTabController(
////        length: 2,
////        child: Scaffold(
////          body:
//
////          LayoutBuilder(
////            builder: (context, constraint) {
////              return SingleChildScrollView(
////                child: ConstrainedBox(
////                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
////                  child: IntrinsicHeight(
////                    child: Column(
////                      mainAxisSize: MainAxisSize.min,
////                      children: <Widget>[
////                        SizedBox(height: 20.0),
////
////                        /// Header
////                        _header(),
////
////                        SizedBox(height: 20.0),
////
////                        /// Боломжит зээлийн хэмжээ, зээлийн үлдэгдэл
////                        _loanInfoCard(),
////
////                        SizedBox(height: AppHelper.margin),
////
////                        /// Зээлийн эрх нээх
////                        Visibility(child: _btnLoanPrivilege(), visible: _visibleBtnLoanPrivilege),
////
////                        /// Зээл авах
////                        Visibility(child: _btnLoanApplication(), visible: _visibleBtnLoanApplication),
////
////                        SizedBox(height: AppHelper.margin),
////
////                        /// Tab bar
////                        Container(
////                          color: AppColors.bgWhite,
////                          child: TabBar(
////                            labelPadding: EdgeInsets.all(0.0),
////                            labelColor: AppColors.lblBlue,
////                            //Selected
////                            labelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
////                            unselectedLabelColor: AppColors.lblGrey,
//////                  controller: tabController,
////                            indicatorColor: Colors.transparent,
//////                  indicatorSize: TabBarIndicatorSize.tab,
////                            tabs: [
////                              Tab(child: Text('Бичил зээл')),
////                              Tab(child: Text('Барьцаат зээл')),
////                            ],
////                          ),
////                        ),
////
////                        Container(height: 1.0, color: AppColors.lineCard),
////
////                        /// Tab bar view
////                        Container(
////                          height: 200.0,
////                          child: TabBarView(
////                            children: [
////                              OnlineLoanListWidget(scaffoldKey: widget.scaffoldKey),
////                              OfflineLoanListWidget(scaffoldKey: widget.scaffoldKey),
////                            ],
////                          ),
////                        ),
////
////                        SizedBox(height: 30.0),
////                      ],
////                    ),
////                  ),
////                ),
////              );
////            },
////          ),
////        ),
////      ),
//        );
//  }
//
//  Widget _header() {
//    return Container(
//      padding: EdgeInsets.only(
//        right: AppHelper.margin,
//        left: AppHelper.margin,
//      ),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          /// Logo
//          Image.asset(
//            AssetName.net_capital_logo,
//            width: 160.0,
//            colorBlendMode: BlendMode.modulate,
//          ),
//
//          Expanded(child: Container()),
//
//          /// Notification
//          Stack(
//            children: <Widget>[
//              new Icon(Icons.email, color: AppColors.iconRegentGrey),
//              new Positioned(
//                right: 0,
//                child: new Container(
//                  padding: EdgeInsets.all(1),
//                  decoration: new BoxDecoration(
//                    color: Colors.red,
//                    borderRadius: BorderRadius.circular(6),
//                  ),
//                  constraints: BoxConstraints(
//                    minWidth: 12,
//                    minHeight: 12,
//                  ),
//                  child: new Text(
//                    '$_notifCount',
//                    style: new TextStyle(
//                      color: Colors.white,
//                      fontSize: 8,
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                ),
//              )
//            ],
//          ),
//
//          SizedBox(width: 20.0),
//
//          /// Profile pic
//          Image.asset(
//            AssetName.profile_pic,
//            width: 37.0,
//            colorBlendMode: BlendMode.modulate,
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _loanInfoCard() {
//    return CustomCard(
//      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
//      padding: EdgeInsets.all(AppHelper.margin),
//      child: Container(
////        height: 150.0,
//        child: Column(
//          children: <Widget>[
//            /// Боломжилт зээлийн хэмжээ
//            lbl('Боломжилт зээлийн хэмжээ', style: lblStyle.Medium),
//
//            // Value
//            _loanLimit != null
//                ? FadeIn(child: lbl('${Func.toMoneyStr(_loanLimit)}${Func.toCurSymbol('MNT')}', fontSize: 28.0), delay: 0, begin: 0, end: 0)
//                : lbl('', fontSize: 28.0),
//
//            /// Net point
//            _netPoint != null
//                ? FadeIn(
//                    child: lbl('Netpoint: ${Func.toMoneyStr(_netPoint)}', color: AppColors.lblGrey, fontSize: AppHelper.fontSizeCaption),
//                    delay: 0,
//                    begin: 0,
//                    end: 0)
//                : lbl('', fontSize: AppHelper.fontSizeCaption),
//
//            SizedBox(height: 8.0),
//
//            /// Хөндлөн зураас
//            Divider(color: AppColors.lineLightGrey),
//
//            SizedBox(height: 8.0),
//
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    // Caption
//                    lbl('Зээлийн үлдэгдэл', color: AppColors.lblGrey, fontSize: AppHelper.fontSizeCaption),
//
//                    /// Зээлийн үлдэгдэл - Value
//                    _loanTotalBal != null
//                        ? FadeIn(child: lbl('${Func.toMoneyStr(_loanTotalBal)}${Func.toCurSymbol('MNT')}', fontSize: 22.0), delay: 0, begin: 0, end: 0)
//                        : lbl('', fontSize: 22.0)
//                  ],
//                ),
//                SizedBox(width: 10.0),
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.end,
//                  children: <Widget>[
//                    // Caption
//                    lbl('Идэвхтэй зээл', color: AppColors.lblGrey, fontSize: AppHelper.fontSizeCaption),
//
//                    /// Зээлийн үлдэгдэл - Value
//                    _activeLoanCount != null
//                        ? FadeIn(child: lbl('${Func.toStr(_activeLoanCount)}', fontSize: 22.0), delay: 0, begin: 0, end: 0)
//                        : lbl('', fontSize: 22.0)
//                  ],
//                ),
////                Image.asset(AssetName.up_arrow_alt, color: AppColors.blue, height: 11.0),
//              ],
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _btnLoanPrivilege() {
//    return CustomButton(
//      text: globals.text.getLoanPrivilege(),
//      context: context,
//      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
//      color: AppColors.bgGreyLight,
//      disabledColor: AppColors.bgGreyLight,
//      textColor: AppColors.lblBlue,
//      disabledTextColor: AppColors.lblBlue,
//      fontSize: AppHelper.fontSizeMedium,
//      fontWeight: FontWeight.w500,
////      onPressed: (_limitFeeScoreResponse != null) ? () => Navigator.push(context, FadeRouteBuilder(route: BranchRoute())) : null,
//      onPressed: null, //todo
//    );
//  }
//
//  Widget _btnLoanApplication() {
//    return CustomButton(
//      text: Func.toStr('Зээл авах').toUpperCase(),
//      context: context,
//      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
//      color: AppColors.bgBlue,
//      disabledColor: AppColors.btnBlue,
//      textColor: Colors.white,
//      fontSize: 16.0,
//      fontWeight: FontWeight.w500,
//      onPressed: (globals.onlineLoanList != null) ? () => Navigator.push(context, FadeRouteBuilder(route: LoanApplicationRoute())) : null,
//    );
//  }
//}
