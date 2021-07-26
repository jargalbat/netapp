import 'package:flutter/material.dart';
import 'package:netware/api/models/acnt/sched.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/labels.dart';

/// Зээл сунгах
class LoanScheduleWidget extends StatefulWidget {
  LoanScheduleWidget({Key key, this.sched, this.height});

  final List<Sched> sched;
  final double height;

  @override
  _LoanScheduleWidgetState createState() => _LoanScheduleWidgetState();
}

class _LoanScheduleWidgetState extends State<LoanScheduleWidget> {
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
    return Column(
      children: <Widget>[
        /// Title
        Container(
          padding: EdgeInsets.fromLTRB(AppHelper.margin, 5.0, 5.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /// Зээлийн график
              lbl(globals.text.loanGraph(), style: lblStyle.Headline5),

              /// Close icon
              IconButton(icon: Icon(Icons.close), color: AppColors.iconBlue, iconSize: AppHelper.iconSizeMedium, onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),

        /// Header
        _listHeader(),

        /// List
        Expanded(
          child: ListView(
            children: <Widget>[
//              Text('asd'),
              for (int i = 0; i < widget.sched.length; i++) _listItem(i),

              SizedBox(height: AppHelper.margin),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listHeader() {
    return Container(
      height: AppHelper.heightListItem,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lineGreyCard),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Огноо
          Flexible(flex: 1, child: lbl(globals.text.date(), margin: EdgeInsets.only(left: AppHelper.margin))),

          /// Нийт төлөлт
          Flexible(flex: 1, child: lbl(globals.text.totalPayment())),

          /// Эцсийн үлдэгдэл
          Flexible(flex: 1, child: lbl(globals.text.theorBal(), margin: EdgeInsets.only(right: AppHelper.margin))),
        ],
      ),
    );
  }

  Widget _listItem(int index) {
    return Container(
      height: AppHelper.heightListItem,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lineGreyCard),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Огноо
          Flexible(
            flex: 1,
            child: lbl(Func.toDateStr(widget.sched[index].payDay), margin: EdgeInsets.only(left: AppHelper.margin)),
          ),

          /// Нийт төлөлт
          Flexible(
            flex: 1,
            child: lbl('${Func.toMoneyStr(widget.sched[index].totalAmt)}${Func.toCurSymbol('MNT')}'),
          ),

          /// Эцсийн үлдэгдэл
          Flexible(
            flex: 1,
            child: lbl(
              '${Func.toMoneyStr(widget.sched[index].theorBal)}${Func.toCurSymbol('MNT')}',
              margin: EdgeInsets.only(right: AppHelper.margin),
              color: AppColors.lblBlue,
            ),
          ),
        ],
      ),
    );
  }
}
