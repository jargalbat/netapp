import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/acnt/rcv_acnts.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/bloc/acnt_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/combobox/simple_combo.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/qpay/qpay_bloc.dart';
import 'package:netware/modules/qpay/qpay_helper.dart';
import 'package:url_launcher/url_launcher.dart';

/// Зээл, шимтгэл төлөх
class QPayWidget extends StatefulWidget {
  QPayWidget({
    Key key,
    this.scaffoldKey,
    this.title,
    this.paymentCode,
    this.acnt,
    this.tranAmt,
    this.tranAmtQpay,
    this.rcvAcntList,
    this.termSize,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final String paymentCode;
  final Acnt acnt;
  final double tranAmt;
  final double tranAmtQpay;
  final List<ComboItem> rcvAcntList;
  final int termSize;

  @override
  _QPayWidgetState createState() => _QPayWidgetState();
}

class _QPayWidgetState extends State<QPayWidget>
    with SingleTickerProviderStateMixin {
  final _qpayKey = GlobalKey<ScaffoldState>();

  // Data
  final _qpayBloc = QPayBloc();

  // Tab bar
  TabController _qpayTabController;

  // Хүлээн авах данс
  String _selectedRcvAcntNo = '';
  String _selectedRcvAcntName = '';
  String _selectedRcvBankCode = '';

  @override
  void initState() {
//    _qpayBloc.add(GetExtendLoanInfo(acntNo: widget.acnt.acntNo));
    super.initState();
    _qpayTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _qpayTabController.dispose();
    _qpayBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QPayBloc>(
      create: (context) => _qpayBloc,
      child: BlocListener<QPayBloc, QPayState>(
        listener: _blocListener,
        child: BlocBuilder<QPayBloc, QPayState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, QPayState state) {
    if (state is QPayQrCodeSuccess) {
      _openDeeplink(state.deepLink);
    } else if (state is QPayQrCodeFailed) {
      showSnackBar(key: _qpayKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, QPayState state) {
    return LoadingContainer(
      loading: state is QPayLoading,
      child: Scaffold(
        key: _qpayKey,
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            /// Title
            Container(
              padding: EdgeInsets.fromLTRB(AppHelper.margin, 5.0, 5.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /// Title (Шимтгэл төлөх, бичил зээл)
                  lbl(widget.title, style: lblStyle.Headline5),

                  /// Close icon
                  IconButton(
                      icon: Icon(Icons.close),
                      color: AppColors.iconBlue,
                      iconSize: AppHelper.iconSizeMedium,
                      onPressed: () => Navigator.pop(context))
                ],
              ),
            ),

            Container(height: 1.0, color: AppColors.lineGreyCard),

            _getTabBar(),

            Expanded(
              child: _getTabBarView([
                _tab1(state),
                _tab2(state),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  TabBarView _getTabBarView(tabs) {
    return TabBarView(
      children: tabs,
      controller: _qpayTabController,
    );
  }

  Widget _getTabBar() {
    /// Tab bar
    return Container(
      color: AppColors.bgWhite,
      child: TabBar(
        labelPadding: EdgeInsets.all(0.0),
        labelColor: AppColors.lblBlue,
        //Selected
        labelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
        unselectedLabelColor: AppColors.lblGrey,
        controller: _qpayTabController,
        indicatorColor: Colors.transparent,
//                  indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          /// QPAY
          Tab(child: Text('QPay')),

          /// Интернэт банкаар төлөх
          Tab(child: Text(globals.text.otherBanks())),
        ],
      ),
    );
  }

  Widget _tab2(QPayState state) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 20.0),

        /// Дүн
        lbl(
          '${Func.toMoneyStr(widget.tranAmt)}${Func.toCurSymbol(widget.acnt.curCode)}',
          style: lblStyle.Headline4,
          margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
          alignment: Alignment.center,
        ),

        /// Ангилал
        Container(
          margin: EdgeInsets.fromLTRB(
              AppHelper.margin, 0.0, AppHelper.margin, AppHelper.margin),
          child: RichText(
            textAlign: TextAlign.center,
            text: new TextSpan(
              style: new TextStyle(fontSize: 12.0, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: '${globals.text.classs()}: ',
                    style: new TextStyle(color: AppColors.lblGrey)),
                TextSpan(
                  text: AcntHelper.getClassName(widget.acnt.isExpired),
                  style: new TextStyle(
                    color: (widget.acnt.isExpired == AcntClass.Normal)
                        ? AppColors.jungleGreen
                        : AppColors.lblRed,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 10.0),

        /// Хүлээн авагчийн банк сонгох
        Container(
          margin:
              EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
          child: _finAcntCombo(),
        ),

        /// Дансны нэр
        _listItem('${globals.text.acntName()}:', _selectedRcvAcntName),

        /// Дансны дугаар
        _listItem('${globals.text.acntNo()}:', _selectedRcvAcntNo),

        /// Гүйлгээний утга
        _listItem('${globals.text.tranDesc()}:', widget.paymentCode),

        SizedBox(height: AppHelper.marginBottom),
      ],
    );
  }

  Widget _tab1(QPayState state) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 20.0),

        /// Дүн
        lbl(
          '${Func.toMoneyStr(widget.tranAmtQpay)}${Func.toCurSymbol(widget.acnt.curCode)}',
          style: lblStyle.Headline4,
          margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
          alignment: Alignment.center,
        ),

        /// Ангилал
        Container(
          margin: EdgeInsets.fromLTRB(
              AppHelper.margin, 0.0, AppHelper.margin, AppHelper.margin),
          child: RichText(
            textAlign: TextAlign.center,
            text: new TextSpan(
              style: new TextStyle(fontSize: 12.0, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: '${globals.text.classs()}: ',
                    style: new TextStyle(color: AppColors.lblGrey)),
                TextSpan(
                  text: AcntHelper.getClassName(widget.acnt.isExpired),
                  style: new TextStyle(
                    color: (widget.acnt.isExpired == AcntClass.Normal)
                        ? AppColors.jungleGreen
                        : AppColors.lblRed,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 10.0),

        lbl(
          '${globals.text.bankApp()}:',
          fontSize: AppHelper.fontSizeCaption,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: AppHelper.margin),
        ),

        SizedBox(height: 10.0),

        /// Fintech app list
        _fintechAppList(state),

        SizedBox(height: AppHelper.marginBottom),
      ],
    );
  }

  Widget _finAcntCombo() {
    return (widget.rcvAcntList != null && widget.rcvAcntList.isNotEmpty)
        ? SimpleCombo(
            list: widget.rcvAcntList,
            icon: Icon(Icons.keyboard_arrow_down, size: AppHelper.iconSize),
            label: globals.text.receiveBank(),
            onItemSelected: (value) {
              setState(() {
                _selectedRcvAcntNo = (value as RcvAcnts).acntNo;
                _selectedRcvAcntName = (value as RcvAcnts).acntName;
                _selectedRcvBankCode = (value as RcvAcnts).bankCode;
              });
            },
          )
        : SimpleComboHolder(
            icon: Icon(Icons.keyboard_arrow_down,
                size: AppHelper.iconSize, color: AppColors.iconBlue),
            onTap: () {
//              Navigator.push(context, FadeRouteBuilder(route: AddBankAcntRoute()));
            },
          );
  }

  Widget _listItem(String caption, String value) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            margin: EdgeInsets.fromLTRB(
                AppHelper.margin, 0.0, AppHelper.margin, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Caption
                      lbl('${Func.toStr(caption)}',
                          fontSize: AppHelper.fontSizeCaption,
                          alignment: Alignment.centerLeft),

                      /// Value
                      lbl('${Func.toStr(value)}',
                          fontSize: AppHelper.fontSizeMedium,
                          alignment: Alignment.centerLeft),
                    ],
                  ),
                ),

                /// Хуулах
                TextButton(
                  text: globals.text.copy(),
                  alignment: Alignment.centerRight,
                  textColor: AppColors.lblBlue,
                  fontSize: AppHelper.fontSizeMedium,
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(text: value));
                    showSnackBar(
                        key: _qpayKey,
                        text: globals.text.copied(),
                        duration: Duration(milliseconds: 500));
                    print('Хуулагдлаа:' + Func.toStr(value));
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(height: 1.0, color: AppColors.lineGreyCard),
        ],
      ),
    );
  }

  Widget _fintechAppList(QPayState state) {
    return Container(
      height: 200.0,
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(AppHelper.borderRadiusBtn),
        ),
        color: AppColors.bgGrey,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (var el in QPayHelper.fintechAppList)
            IconButton(
              icon: Image.asset(el.imageAssetName, height: 51.0, width: 51.0),
              onPressed: (state is QPayLoading)
                  ? null
                  : () {
                      _qpayBloc.add(
                        CreateQpayQrCode(
                          uriScheme: el.deepLink,
                          acntCode: widget.acnt.acntNo,
                          paymentCode: widget.paymentCode,
                          termSize: widget.termSize ?? 0,
                        ),
                      );
                    },
            )
        ],
      ),
    );
  }

  _openDeeplink(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
//        khanbank://q?qPay_QRcode=7729010259415096644150863802398062&object_type=&object_id=
        showSnackBar(key: _qpayKey, text: globals.text.cantOpenApp());
        throw 'Амжилтгүй. url: $url';
      }
    } catch (e) {
      print(e);
    }
  }
}
