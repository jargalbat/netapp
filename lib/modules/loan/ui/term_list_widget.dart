import 'package:flutter/material.dart';
import 'package:netware/api/models/loan/extend_info_response.dart';
import 'package:netware/api/models/loan/fee_terms.dart';
import 'package:netware/api/models/loan/loan_prod_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/labels.dart';

/// Зээл авах - Terms model ашигласан
class TermListWidget extends StatefulWidget {
  TermListWidget({
    @required this.onItemSelected,
    @required this.termList,
    @required this.termUnit,
  }) : assert(onItemSelected != null);

  final Function(int index) onItemSelected;
  final List<Terms> termList;
  final String termUnit;

  @override
  _TermListWidgetState createState() => _TermListWidgetState();
}

class _TermListWidgetState extends State<TermListWidget> {
  int _selectedIndex = 0;
  Color _selectedColor = AppColors.blue;
  Color _unSelectedColor = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 5;

    return Container(
      height: size,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (int i = 0; i < widget.termList.length; i++) _rowItem(i, size),
        ],
      ),
    );

//    return Container(
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          for (int i = 0; i < widget.termList.length; i++) _rowItem(i),
//        ],
//      ),
//    );
  }

  Widget _rowItem(int index, double size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          widget.onItemSelected(_selectedIndex);
        });
      },
      child: Container(
        margin: (index == 0) ? EdgeInsets.only(left: AppHelper.margin, right: AppHelper.margin) : EdgeInsets.only(right: AppHelper.margin),
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: AppColors.bgGrey,
          border: _selectedIndex == index ? Border.all(color: _selectedColor) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            lbl('${widget.termList[index].termSize}',
                color: _selectedIndex == index ? _selectedColor : AppColors.lblDark, alignment: Alignment.center),
            SizedBox(height: 5.0),
            lbl('${widget.termUnit}', color: _selectedIndex == index ? _selectedColor : AppColors.lblDark, alignment: Alignment.center),
          ],
        ),
      ),
    );
  }
}

//TODO fee term list-тэй нэгтгэх - Дундын модел ашиглах
/// Зээл авах - Terms model ашигласан
class FeeTermListWidget extends StatefulWidget {
  FeeTermListWidget({
    @required this.onItemSelected,
    @required this.feeTermsList,
    @required this.termUnit,
  }) : assert(onItemSelected != null);

  final Function(int index) onItemSelected;
  final List<FeeTerms> feeTermsList;
  final String termUnit;

  @override
  _FeeTermListWidgetState createState() => _FeeTermListWidgetState();
}

class _FeeTermListWidgetState extends State<FeeTermListWidget> {
  int _selectedIndex = 0;
  Color _selectedColor = AppColors.blue;
  Color _unSelectedColor = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 5;

    return Container(
      height: size,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (int i = 0; i < widget.feeTermsList.length; i++) _rowItem(i, size),
        ],
      ),
    );

//    return Container(
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          for (int i = 0; i < widget.termList.length; i++) _rowItem(i),
//        ],
//      ),
//    );
  }

  Widget _rowItem(int index, double size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          widget.onItemSelected(_selectedIndex);
        });
      },
      child: Container(
        margin: (index == 0) ? EdgeInsets.only(left: AppHelper.margin, right: AppHelper.margin) : EdgeInsets.only(right: AppHelper.margin),
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: AppColors.bgGrey,
          border: _selectedIndex == index ? Border.all(color: _selectedColor) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            lbl('${widget.feeTermsList[index].termSize}',
                color: _selectedIndex == index ? _selectedColor : AppColors.lblDark, alignment: Alignment.center),
            SizedBox(height: 5.0),
            lbl('${widget.termUnit}', color: _selectedIndex == index ? _selectedColor : AppColors.lblDark, alignment: Alignment.center),
          ],
        ),
      ),
    );
  }
}
