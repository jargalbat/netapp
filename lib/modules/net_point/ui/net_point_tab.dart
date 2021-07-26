import 'package:flutter/material.dart';
import 'package:netware/api/models/loan/limit_fee_score_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/app/bloc/fee_score_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';

class NetPointTab extends StatefulWidget {
  NetPointTab({this.scaffoldKey});

  final scaffoldKey;

  @override
  _NetPointTabState createState() => _NetPointTabState();
}

class _NetPointTabState extends State<NetPointTab> {
  /// UI
  //

  /// Data
  int _selectedCardIndex = 0;

  @override
  void initState() {
    BlocProvider.of<FeeScoreBloc>(context).add(GetFeeScore());
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
      globals.feeScore = state.limitFeeScoreResponse;
    } else if (state is UseBonusLimitSuccess || state is UseBonusFeeSuccess) {
      BlocProvider.of<FeeScoreBloc>(context).add(GetFeeScore());
      BlocProvider.of<AcntBloc>(context).add(GetOnlineLoanList());
    } else if (state is FeeScoreFailed) {
      showSnackBar(key: widget.scaffoldKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, FeeScoreState state) {
    return BlurLoadingContainer(
//      isLoading: state is LimitFeeScoreLoading,
      loading: false,
      child: Scaffold(
        backgroundColor: AppColors.bgGrey,
        appBar: AppBarEmpty(context: context, brightness: Brightness.light, backgroundColor: AppColors.bgGrey),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),

              /// Netpoint
              _header(),

              SizedBox(height: 20.0),

              /// Цуглуулсан, зарцуулсан оноо
              _bonusScoreCard(),

              SizedBox(height: AppHelper.margin),

              /// Зээлийн хэмжээ, шимтгэл
              _limitFeeCards(),

              SizedBox(height: AppHelper.margin),

              /// Ашиглах, дэлгэрэнгүй
              _detailCard(),

              SizedBox(height: AppHelper.marginBottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        /// Icon
        Image.asset(AssetName.wallet, height: 14.0, width: 14.0, color: AppColors.iconBlue),

        SizedBox(width: 10.0),

        /// Net point
        lbl(globals.text.netPoint2(), fontWeight: FontWeight.w500, fontSize: AppHelper.fontSizeMedium, color: AppColors.lblBlue),
      ],
    );
  }

  Widget _bonusScoreCard() {
    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Цуглуулсан
          Expanded(
            child: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /// Icon
                      Image.asset(AssetName.green_arrow, height: 11.0),

                      SizedBox(width: 10.0),

                      /// Оноо
                      (globals.feeScore?.bonusScore != null)
                          ? FadeIn(
                              delay: 0,
                              begin: 0,
                              end: 0,
                              child: lbl(
                                '${globals.feeScore?.bonusScore ?? ''} ',
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.lblBlue,
                              ),
                            )
                          : lbl('', fontSize: 24.0),
                    ],
                  ),

                  /// Цуглуулсан
                  lbl(
                    globals.text.collected(),
                    fontSize: 12.0,
                    color: AppColors.lblGrey,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),

          Container(width: 1.0, color: AppColors.lineGreyCard, height: 39.0),

          /// Зарцуулсан
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /// Icon
                    Image.asset(AssetName.red_arrow, height: 11.0),

                    SizedBox(width: 10.0),

                    /// Оноо

                    lbl('${globals.feeScore?.usedScore ?? ''}', fontSize: 24.0, fontWeight: FontWeight.w500, color: AppColors.lblGrey),
                  ],
                ),

                /// Цуглуулсан
                lbl(globals.text.used(), fontSize: 12.0, color: AppColors.lblGrey, alignment: Alignment.center),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _limitFeeCards() {
    return Row(
      children: <Widget>[
        /// Зээлийн хэмжээ нэмэх
        Expanded(
          child: CustomCard(
              margin: EdgeInsets.only(left: AppHelper.margin),
              color: (_selectedCardIndex == 0) ? AppColors.blue : AppColors.bgWhite,
              padding: EdgeInsets.all(AppHelper.margin),
              child: Container(
                height: 78.0,
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedCardIndex = 0);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_circle_outline,
                        size: 30.0,
                        color: (_selectedCardIndex == 0) ? AppColors.lblWhite : AppColors.lblGrey,
                      ),
                      SizedBox(height: 10.0),
                      lbl(
                        globals.text.increaseLimit(),
                        alignment: Alignment.center,
                        color: (_selectedCardIndex == 0) ? AppColors.lblWhite : AppColors.lblGrey,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              )),
        ),

        SizedBox(width: AppHelper.margin),

        /// Шимтгэл бууруулах
        Expanded(
          child: CustomCard(
              margin: EdgeInsets.only(right: AppHelper.margin),
              color: (_selectedCardIndex == 1) ? AppColors.blue : AppColors.bgWhite,
              padding: EdgeInsets.all(AppHelper.margin),
              child: Container(
                height: 78.0,
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedCardIndex = 1);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        AssetName.fee_down,
                        height: 30.0,
                        width: 22.0,
                        color: (_selectedCardIndex == 1) ? AppColors.lblWhite : AppColors.iconRegentGrey,
                      ),
                      SizedBox(height: 5.0),
                      lbl(
                        globals.text.decreaseFee(),
                        alignment: Alignment.center,
                        color: (_selectedCardIndex == 1) ? AppColors.lblWhite : AppColors.lblGrey,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget _detailCard() {
    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Container(
//        height: 214.0,
        child: Column(
          children: <Widget>[
            /// Hint
            lbl(
              (_selectedCardIndex == 0) ? globals.text.msgIncLimit() : globals.text.msgDecFee(),
              color: AppColors.lblGrey,
              fontSize: 16.0,
              maxLines: 2,
              alignment: Alignment.center,
              fontWeight: FontWeight.bold,
              margin: EdgeInsets.fromLTRB(AppHelper.margin, AppHelper.margin, AppHelper.margin, 0.0),
            ),

            SizedBox(height: AppHelper.margin),

            (_selectedCardIndex == 0)
                ? Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(AssetName.green_arrow, height: 11.0),

                          SizedBox(width: 10.0),

                          /// Оноо
                          lbl('${Func.toMoneyStr(globals.feeScore?.limitIncrDiff ?? '')} ₮', fontSize: 24.0, fontWeight: FontWeight.w500, color: AppColors.lblBlue),
                        ],
                      ),
                      lbl(
                        '${globals.text.limitAfter()}: ${Func.toMoneyStr((globals.feeScore?.limitIncrDiff ?? 0) + (globals.onlineLoanList?.curLimit ?? 0))} ₮',
                        maxLines: 3,
                        color: AppColors.lblGrey,
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(AppHelper.margin, 5.0, AppHelper.margin, 5.0),
                      ),
                    ],
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
                    child: Column(
                      children: <Widget>[
                        /// Header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  lbl(globals.text.currentFees(), maxLines: 2, color: AppColors.lblGrey),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  lbl(globals.text.feeAfterDec(), maxLines: 2, color: AppColors.lblGrey),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.0),

                        /// Шимтгэлийн жагсаалт
                        _feeList(),
                      ],
                    ),
                  ),

            SizedBox(height: AppHelper.margin),

            Container(height: 1.0, color: AppColors.lineGreyCard),

            /// Ашиглах
            TextButton(
              text: globals.text.use(),
              textColor: AppColors.lblBlue,
              fontWeight: FontWeight.bold,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0.0, AppHelper.margin, 0.0, AppHelper.margin),
              fontSize: 16.0,
              onPressed: () {
                showDefaultDialog(
                  context: context,
                  body: globals.text.sureUsePoint(),
                  onPressedBtnPositive: () {
                    if (_selectedCardIndex == 0) {
                      BlocProvider.of<FeeScoreBloc>(context).add(UseBonusLimit());
                    } else {
                      BlocProvider.of<FeeScoreBloc>(context).add(UseBonusFee());
                    }
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _feeList() {
    Widget result = Container();

    if (globals?.feeScore?.fees != null && globals.feeScore.fees.length > 0) {
      result = Column(
        children: <Widget>[
          for (var el in globals.feeScore.fees[0].feeTerms) _feeItem(el),
        ],
      );
    }

    return result;
  }

  Widget _feeItem(FeeTerms feeTermItem) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: lbl('${feeTermItem.termSize} ${globals.text.days()}', color: AppColors.lblGrey),
        ),
        Flexible(
          flex: 3,
          child: lbl('${Func.toStrFixed(feeTermItem.feeSize)}%', color: AppColors.lblGrey),
        ),

        // Half
        Flexible(
          flex: 1,
          child: Image.asset(AssetName.red_arrow, height: 11.0),
        ),
        Flexible(
          flex: 2,
          child: lbl('${Func.toStrFixed(feeTermItem.feeDecrDiff)}%', color: AppColors.lblGrey),
        ),
        Flexible(
          flex: 3,
          child: lbl('${Func.toStrFixed(feeTermItem.feeSize - feeTermItem.feeDecrDiff)}%', alignment: Alignment.centerRight, color: AppColors.lblGrey),
        ),
      ],
    );
  }
}
