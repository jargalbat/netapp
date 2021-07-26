import 'package:flutter/material.dart';
import 'package:netware/api/models/acnt/acnt.dart';
import 'package:netware/api/models/loan/extend_info_response.dart';
import 'package:netware/api/models/loan/fee_terms.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/cards/row_item.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/modules/loan/ui/term_list_widget.dart';
import 'package:netware/app/widgets/bottom_sheet_dialogs.dart';
import 'package:netware/modules/qpay/qpay_widget.dart';

/// Зээл сунгах
class ExtendLoanWidget extends StatefulWidget {
  ExtendLoanWidget({
    Key key,
    this.scaffoldKey,
    this.acnt,
    this.height,
    this.extendInfoResponse,
    this.rcvAcntList = const <ComboItem>[],
  });

  // Шимтгэлийн мэдээлэл
  final ExtendInfoResponse extendInfoResponse;

  // Хүлээн авах дансны жагсаалт
  final List<ComboItem> rcvAcntList;

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Acnt acnt;
  final double height;

  @override
  _ExtendLoanWidgetState createState() => _ExtendLoanWidgetState();
}

class _ExtendLoanWidgetState extends State<ExtendLoanWidget> {
  // Term
  FeeTerms _selectedFeeTerm;

  @override
  void initState() {
    // Анхны утга олгох
    if (widget.extendInfoResponse != null &&
        widget.extendInfoResponse.fees != null &&
        widget.extendInfoResponse.fees.isNotEmpty &&
        widget.extendInfoResponse.fees[0].feeTerms.isNotEmpty) {
      _selectedFeeTerm = widget.extendInfoResponse.fees[0].feeTerms[0];
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.

    return (widget.extendInfoResponse != null)
        ? Column(
            children: <Widget>[
              /// Title
              Container(
                padding: EdgeInsets.fromLTRB(AppHelper.margin, 5.0, 5.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    /// Хугацаа сунгах хүсэлт
                    lbl(globals.text.extendRequest(), style: lblStyle.Headline5),

                    /// Close icon
                    IconButton(
                      icon: Icon(Icons.close),
                      color: AppColors.iconBlue,
                      iconSize: AppHelper.iconSizeMedium,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              Container(height: 1.0, color: AppColors.lineGreyCard),

              /// List

              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20.0),

                    /// Сунгах хугацаа сонгох
                    lbl(
                      globals.text.selectExtendPeriod().toUpperCase(),
                      style: lblStyle.Caption,
                      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
                    ),

                    SizedBox(height: AppHelper.margin),

                    /// Term list
                    FeeTermListWidget(
                      onItemSelected: (index) {
                        setState(() {
                          _selectedFeeTerm = widget.extendInfoResponse.fees[0].feeTerms[index];
                        });
                      },
                      feeTermsList: widget.extendInfoResponse.fees[0].feeTerms,
                      termUnit: globals.text.days(),
                    ),

                    /// Reminder
                    Func.isNotEmpty(widget.extendInfoResponse.extendReminder) //todo
//                  true //todo
                        ? Container(
                            margin: EdgeInsets.fromLTRB(AppHelper.margin, 30.0, AppHelper.margin, 30.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: new TextSpan(
                                style: new TextStyle(fontSize: 12.0, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(text: '${globals.text.reminder()}: ', style: new TextStyle(color: AppColors.lblBlue)),
                                  TextSpan(
                                    text: ' ' + (widget.extendInfoResponse.extendReminder ?? ' ${globals.text.reminderExtend()}'),
                                    style: new TextStyle(color: AppColors.lblDark),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(height: 30.0),

                    /// Зээл сунгалтын дэлгэрэнгүй
                    lbl(
                      globals.text.extendDetails().toUpperCase(),
                      style: lblStyle.Caption,
                      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
                    ),

                    SizedBox(height: AppHelper.margin),

                    CustomCard(
                      color: AppColors.bgGreyLight,
                      margin: EdgeInsets.fromLTRB(AppHelper.margin, 5, AppHelper.margin, AppHelper.margin),
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          /// Сунгах хугацаа
                          RowItem(
                              caption: '${globals.text.extendPeriod()}:',
                              value: (_selectedFeeTerm != null) ? '${(_selectedFeeTerm.termSize)} хоног' : ''),

                          SizedBox(height: AppHelper.margin),

                          /// Төлөх огноо
                          RowItem(
                              caption: '${globals.text.repayDate()}:',
                              value: Func.addDaysOnDateStr(widget.acnt.endDate, _selectedFeeTerm.termSize)),

                          SizedBox(height: AppHelper.margin),

                          /// Зээл сунгах шимтгэл
                          RowItem(
                            caption: '${globals.text.loanExtensionFee()}:',
                            value: (_selectedFeeTerm != null)
                                ? '${Func.toMoneyStr(_selectedFeeTerm.feeSize)}${Func.toCurSymbol(widget.acnt.curCode)}'
                                : '',
                          ),

                          SizedBox(height: AppHelper.margin),

                          /// Үндсэн зээлийн шимтгэл
                          RowItem(
                            caption: '${globals.text.princFee()}:',
                            value: '${Func.toMoneyStr(widget.acnt.advFeeBal)}${Func.toCurSymbol(widget.acnt.curCode)}',
                          ),

                          SizedBox(height: AppHelper.margin),

                          /// Алданги
                          RowItem(
                            caption: '${globals.text.lateCharge()}:',
                            value: '${Func.toMoneyStr(widget.acnt.fineintDebtBal)}${Func.toCurSymbol(widget.acnt.curCode)}',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppHelper.margin),

                    /// Шимтгэл төлөх
                    _btnPayFee(),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _btnPayFee() {
    return CustomButton(
      context: context,
      text: globals.text.payFee(),
      isUppercase: false,
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      color: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: AppHelper.fontSizeMedium,
      fontWeight: FontWeight.w500,
      onPressed: () {
        DialogHelper.showBottomSheetDialog(
          context: context,
          height: widget.height,
          child: QPayWidget(
            scaffoldKey: widget.scaffoldKey,
            title: globals.text.payFee(),
            paymentCode: widget.extendInfoResponse.paymentCode,
            acnt: widget.acnt,
            tranAmt: widget.extendInfoResponse.totalPay,
            rcvAcntList: widget.rcvAcntList,
            termSize: _selectedFeeTerm.termSize,
          ),
        );
      },
    );
  }
}
