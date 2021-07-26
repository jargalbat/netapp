import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/labels.dart';
import 'combo_bloc.dart';
import 'combo_helper.dart';

class CustomCombo extends StatefulWidget {
  const CustomCombo({
    Key key,
    @required this.comboBloc,
    @required this.list,
    @required this.onItemSelected,
    this.label,
    this.margin,
    this.width,
    this.initialText,
    this.bgColor,
  }) : super(key: key);

  /// UI
  final String label;
  final EdgeInsets margin;
  final double width;
  final Color bgColor;

  /// Data
  final ComboBloc comboBloc;
  final String initialText;
  final List<ComboItem> list;
  final Function(dynamic) onItemSelected; // Return selected item

  @override
  _CustomComboState createState() => _CustomComboState();
}

class _CustomComboState extends State<CustomCombo> {
  String _text = '';
  bool _isValidated = false;

  @override
  void initState() {
    _text = widget.initialText ?? '';
    _isValidated = Func.isNotEmpty(_text);

    super.initState();
  }

  @override
  void dispose() {
    widget.comboBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ComboBloc>(
      create: (context) => widget.comboBloc,
      child: BlocListener<ComboBloc, ComboState>(
        listener: _blocListener,
        child: BlocBuilder<ComboBloc, ComboState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ComboState state) {
    if (state is SelectItemState) {
      _setText(state.text);
    } else if (state is SelectItemState2) {
      _setText(state.text);
    } else if (state is SelectRelativeItemState) {
      _setText(state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, ComboState state) {
    return GestureDetector(
      onTap: _showBottomSheetDialog,
      child: Container(
        margin: widget.margin ?? EdgeInsets.symmetric(horizontal: AppHelper.margin),
        width: widget.width ?? double.infinity,
        child: Column(
          children: <Widget>[
            /// Label
            if (Func.isNotEmpty(widget.label))
              Row(
                children: <Widget>[
                  /// Label
                  lbl(widget.label, fontSize: AppHelper.fontSizeCaption),

                  /// Label validation
                  lbl(_isValidated ? '' : AppHelper.symbolValid, color: AppColors.lblRed),
                ],
              ),

            SizedBox(height: 10.0),

            /// Combo
            Container(
              height: AppHelper.textBoxHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppHelper.borderRadiusBtn),
                ),
                color: widget.bgColor ?? AppColors.bgWhite,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /// Text
                  Expanded(
                    child: lbl(_text, margin: EdgeInsets.only(left: 12.0)),
                  ),

                  /// Validator
//                  if (!_isValidated)
//                    Align(
//                      child: Container(
//                        child: Icon(Icons.error_outline, color: AppColors.iconRed),
//                      ),
//                    ),

                  /// Suffix icon
                  Align(
                    child: Container(
                        padding: EdgeInsets.only(right: 14.0),
//                      child: Icon(Icons.keyboard_arrow_down, size: AppHelper.iconSize),
                        child: Image.asset(
                          AssetName.down_arrow,
                          height: 20.0,
                          width: 20.0,
                          color: AppColors.iconMirage,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setText(String text) {
    _text = text;
    _isValidated = Func.isNotEmpty(_text);
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
      title: lbl(widget.list[index].txt),
      onTap: () {
        setState(() {
          _text = widget.list[index].txt;
          _isValidated = Func.isNotEmpty(_text);

          widget.onItemSelected(widget.list[index].val);
        });

        Navigator.pop(context);
      },
    );
  }
}
