import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/labels.dart';
import 'combo_helper.dart';

class SimpleCombo extends StatefulWidget {
  const SimpleCombo({
    Key key,
    @required this.list,
    @required this.onItemSelected,
    this.label,
    this.margin,
    this.width,
    this.initialText,
    this.bgColor,
    this.icon,
  }) : super(key: key);

  /// UI
  final String label;
  final EdgeInsets margin;
  final double width;
  final Color bgColor;
  final Icon icon;

  /// Data
  final String initialText;
  final List<ComboItem> list;
  final Function(dynamic) onItemSelected; // Return selected item

  @override
  _SimpleComboState createState() => _SimpleComboState();
}

class _SimpleComboState extends State<SimpleCombo> {
  String _assetImageName = '';
  String _text = '';
  bool _isValidated = false;

  @override
  void initState() {
    _text = widget.initialText ?? '';
    _isValidated = Func.isNotEmpty(_text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showBottomSheetDialog,
      child: Container(
        margin: widget.margin ?? EdgeInsets.zero,
        width: widget.width ?? double.infinity,
        child: Column(
          children: <Widget>[
            Func.isNotEmpty(widget.label)
                ? Row(
                    children: <Widget>[
                      /// Label
                      lbl(widget.label, fontSize: AppHelper.fontSizeCaption),

                      /// Label validation
                      lbl(_isValidated ? '' : AppHelper.symbolValid, color: AppColors.lblRed),
                    ],
                  )
                : Container(),

            SizedBox(height: 10.0),

            /// Combo
            Container(
              height: AppHelper.textBoxHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppHelper.borderRadiusBtn),
                ),
                color: widget.bgColor ?? AppColors.bgGrey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /// Image
                  Func.isNotEmpty(_assetImageName)
                      ? Container(
                          child: Image.asset(_assetImageName, height: AppHelper.heightComboImage),
                          margin: EdgeInsets.only(left: 12.0),
                        )
                      : Container(),

                  /// Text
                  Expanded(
                    child: lbl(_text, margin: EdgeInsets.only(left: 12.0)),
                  ),

                  /// Suffix icon
                  Align(
                    child: Container(
                      padding: EdgeInsets.only(right: 5.0),
                      child: widget.icon ?? Icon(Icons.keyboard_arrow_down, size: AppHelper.iconSize),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, i) {
            return _listItem(i);
          },
        );
      },
    );
  }

  Widget _listItem(int index) {
    return ListTile(
      leading: Func.isNotEmpty(widget.list[index].imageAssetName)
          ? Image.asset(widget.list[index].imageAssetName, height: AppHelper.heightComboImage)
          : Container(),
      title: lbl(widget.list[index].txt),
      onTap: () {
        setState(() {
          _text = widget.list[index].txt;
          _assetImageName = widget.list[index].imageAssetName;

          _isValidated = Func.isNotEmpty(_text);

          widget.onItemSelected(widget.list[index].val);
        });

        Navigator.pop(context);
      },
    );
  }
}

class SimpleComboHolder extends StatelessWidget {
  SimpleComboHolder({
    Key key,
    this.label,
    this.margin,
    this.width,
    this.bgColor,
    this.icon,
    this.initialText,
    this.onTap,
  });

  /// UI
  final String label;
  final EdgeInsets margin;
  final double width;
  final Color bgColor;
  final Icon icon;

  /// Data
  final String initialText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.zero,
        width: width ?? double.infinity,
        child: Column(
          children: <Widget>[
            Func.isNotEmpty(label)
                ? Row(
                    children: <Widget>[
                      /// Label
                      lbl(label, fontSize: AppHelper.fontSizeCaption),
                    ],
                  )
                : Container(),

            SizedBox(height: 10.0),

            /// Combo
            Container(
              height: AppHelper.textBoxHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppHelper.borderRadiusBtn),
                ),
                color: bgColor ?? AppColors.bgGrey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /// Text
                  Expanded(
                    child: lbl('', margin: EdgeInsets.only(left: 12.0)),
                  ),

                  /// Suffix icon
                  Align(
                    child: Container(
                      padding: EdgeInsets.only(right: 5.0),
                      child: icon ?? Icon(Icons.keyboard_arrow_down, size: AppHelper.iconSize),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
