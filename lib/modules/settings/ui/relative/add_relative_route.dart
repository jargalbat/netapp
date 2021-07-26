import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/api/models/settings/add_relative_request.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/combobox/combo_bloc.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/combobox/combobox.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/settings/bloc/add_relative_bloc.dart';
import 'package:netware/modules/settings/bloc/profile_helper.dart';
import 'package:netware/modules/settings/bloc/relative_list_bloc.dart';

class AddRelativeRoute extends StatefulWidget {
  @override
  _AddRelativeRouteState createState() => _AddRelativeRouteState();
}

class _AddRelativeRouteState extends State<AddRelativeRoute> {
  /// UI
  final _addRelativeKey = GlobalKey<ScaffoldState>();

  /// Data
  final AddRelativeBloc _addRelativeBloc = AddRelativeBloc();

  /// Last name
  TextEditingController _relLastNameController = TextEditingController();
  FocusNode _relLastNameFocusNode = FocusNode();
  bool _isRelLastNameValid = false;

  /// First name
  TextEditingController _relFirstNameController = TextEditingController();
  FocusNode _relFirstNameFocusNode;
  bool _isRelFirstNameValid = false;

  /// Регистрийн дугаар
  TextEditingController _relRegNoController = TextEditingController();
  bool _isRelRegNoValid = false;
  List<String> _cyrillicList;
  String _relRegNoFirstCharComboId = '_relRegNoFirstCharComboId';
  String _relRegNoFirstChar = '';
  String _relRegNoSecondCharComboId = '_relRegNooSecondCharComboId';
  String _relRegNoSecondChar = '';

  /// Холбоо барих утас
  TextEditingController _relMobileController = TextEditingController();
  bool _isRelMobileValid = false;
  String _prefixMobile = '+976';

  /// Таны хэн болох
  var _relativeComboBloc = ComboBloc();
  List<ComboItem> _relativeComboItemList = [];
  String _relativeComboValue;

  /// Хамт амьдардаг эсэх
  bool _chkLiveWithValue = false;

  /// Button add
  bool _enabledBtnAdd = true;

  @override
  void initState() {
    _addRelativeBloc.add(GetRelativeComboList());

    _initControls();

    super.initState();
  }

  @override
  void dispose() {
    _addRelativeBloc.close();
    _relativeComboBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddRelativeBloc>(
      create: (context) => _addRelativeBloc,
      child: BlocListener<AddRelativeBloc, AddRelativeState>(
        listener: _blocListener,
        child: BlocBuilder<AddRelativeBloc, AddRelativeState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AddRelativeState state) {
    if (state is GetRelativeComboListSuccess) {
      _relativeComboItemList = state.relativeComboList;
      _relativeComboValue = (_relativeComboItemList.first.val as DictionaryData).val;
    } else if (state is AddRelativeShowSnackBar) {
      showSnackBar(key: _addRelativeKey, text: state.text);
    } else if (state is AddRelativeSuccess) {
      BlocProvider.of<RelativeBloc>(context)..add(GetRelativeList());
      showSnackBar(key: _addRelativeKey, text: globals.text.success());
      Navigator.pop(context);
    } else if (state is AddRelativeFailed) {
      showSnackBar(key: _addRelativeKey, text: state.text);
      _enabledBtnAdd = true;
    }
  }

  Widget _blocBuilder(BuildContext context, AddRelativeState state) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        key: _addRelativeKey,
        backgroundColor: AppColors.bgGrey,
        appBar: AppBarSimple(context: context, onPressed: _onBackPressed, brightness: Brightness.light),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode()); // Hide keyboard
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Холбоотой хүмүүс
                lbl(
                  globals.text.relative(),
                  style: lblStyle.Headline4,
                  margin: EdgeInsets.only(left: AppHelper.margin),
                ),

                SizedBox(height: 20.0),

                CustomCard(
                  margin: EdgeInsets.only(right: AppHelper.margin, left: AppHelper.margin),
                  padding: EdgeInsets.all(AppHelper.margin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Холбоотой хүмүүс
                      lbl(globals.text.relative(), style: lblStyle.Headline5),

                      SizedBox(height: 10.0),

                      /// Та зөвхөн өөрийн ойр дотны хүнийхээ мэдээллийг үнэн зөв бөглөж оруулна уу.
                      lbl(globals.text.relativeHint(), maxLines: 3, fontSize: AppHelper.fontSizeMedium),

                      /// Овог
                      _txtLastName(),

                      /// Нэр
                      _txtFirstName(),

                      /// Регистрийн дугаар
                      lbl(
                        globals.text.registerNo(),
                        fontSize: 12.0,
                        margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      ),
                      _registerNoWidget(),

                      /// Холбоо барих утас
                      _txtMobile(),

                      /// Таны хэн болох
                      _relativeCombo(),

                      /// Хамт амьдардаг эсэх
                      _chkLiveWith(),

                      /// Нэмэх
                      _btnAdd(),
                    ],
                  ),
                ),

                SizedBox(height: AppHelper.marginBottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initControls() {
    _relLastNameController.addListener(() {
      setState(() => _isRelLastNameValid = _relLastNameController.text.length > 0);
    });

    _relFirstNameController.addListener(() {
      setState(() => _isRelFirstNameValid = _relFirstNameController.text.length > 0);
    });

    _relRegNoController.addListener(() {
      setState(() => _validateRegNo());
    });

    _relMobileController.addListener(() {
      setState(() => _isRelMobileValid = _relMobileController.text.length == 8);
    });

    _cyrillicList = ProfileHelper.getCyrillicList();
  }

  _txtLastName() {
    return txt(
      labelText: globals.text.lastName(),
      context: context,
      margin: EdgeInsets.only(top: 20.0),
      controller: _relLastNameController,
      maxLength: 30,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGreyDark,
    );
  }

  _txtFirstName() {
    return txt(
      labelText: globals.text.firstName(),
      context: context,
      margin: EdgeInsets.only(top: 20.0),
      controller: _relFirstNameController,
      maxLength: 30,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGreyDark,
    );
  }

  _registerNoWidget() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Row(
        children: <Widget>[
          /// First char
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode()); // Hide keyboard
              _showRegNoComboList(_relRegNoFirstCharComboId);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppHelper.borderRadiusBtn),
                ),
                color: AppColors.txtBgGreyDark,
              ),
              height: AppHelper.textBoxHeight,
              width: AppHelper.textBoxHeight,
              child: Center(child: lbl(_relRegNoFirstChar, alignment: Alignment.center)),
            ),
          ),

          SizedBox(width: 10.0),

          /// Second char
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode()); // Hide keyboard
              _showRegNoComboList(_relRegNoSecondCharComboId);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppHelper.borderRadiusBtn),
                  ),
                  color: AppColors.txtBgGreyDark),
              height: AppHelper.textBoxHeight,
              width: AppHelper.textBoxHeight,
              child: Center(
                  child: lbl(
                _relRegNoSecondChar,
                alignment: Alignment.center,
              )),
            ),
          ),

          SizedBox(width: 10.0),

          /// Numbers
          Expanded(
            child: txt(
              context: context,
//              margin: EdgeInsets.only(right: AppHelper.margin),
              controller: _relRegNoController,
              maxLength: 13,
              textInputType: TextInputType.text,
              textColor: AppColors.lblDark,
              labelFontWeight: FontWeight.normal,
              bgColor: AppColors.txtBgGreyDark,
//              suffixIcon: !_isRelRegNoValid
//                  ? Container(
//                      child: Icon(Icons.error_outline, color: AppColors.iconScarletRed),
//                      padding: EdgeInsets.only(right: 12.0),
//                    )
//                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showRegNoComboList(String comboId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _cyrillicList.length,
          itemBuilder: (context, i) {
            return _regNoComboListItem(comboId, _cyrillicList[i]);
          },
        );
      },
    );
  }

  Widget _regNoComboListItem(String comboId, String str) {
    return ListTile(
      title: lbl(str),
      onTap: () {
        setState(() {
          if (comboId == _relRegNoFirstCharComboId) {
            _relRegNoFirstChar = str;
          } else {
            _relRegNoSecondChar = str;
          }
        });

        Navigator.pop(context);
      },
    );
  }

  void _validateRegNo() {
    if (Func.isEmpty(_relRegNoFirstChar) || Func.isEmpty(_relRegNoSecondChar)) {
      _isRelRegNoValid = false;
      return;
    }

    if (_relRegNoController.text.isEmpty) {
      _isRelRegNoValid = false;
      return;
    }

    _isRelRegNoValid = true;
  }

  _txtMobile() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 20.0),
      labelText: globals.text.relativeMobile(),
      controller: _relMobileController,
      maxLength: 8,
      textInputType: TextInputType.number,
      prefixText: (_prefixMobile),
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGreyDark,
    );
  }

  Widget _relativeCombo() {
    return _relativeComboItemList.isNotEmpty
        ? FadeInSlow(
            child: CustomCombo(
              comboBloc: _relativeComboBloc,
              label: globals.text.relativeType(),
              margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              list: _relativeComboItemList,
              initialText: _relativeComboItemList[0].txt,
              width: 200.0,
              bgColor: AppColors.txtBgGreyDark,
              onItemSelected: (value) {
                DictionaryData data = value;
                try {
                  _relativeComboValue = data.val;
                } catch (e) {
                  showSnackBar(key: _addRelativeKey, text: globals.text.errorOccurred());
                }
              },
            ),
          )
        : Container(height: 96.0);
  }

  Widget _chkLiveWith() {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: AppColors.chkUnselectedGrey,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        margin: EdgeInsets.only(top: AppHelper.margin + 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /// Checkbox
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                value: _chkLiveWithValue,
                activeColor: AppColors.jungleGreen,
                onChanged: (bool newValue) {
                  setState(() {
                    _chkLiveWithValue = newValue;
                  });
                },
              ),
            ),
            SizedBox(width: 5.0),

            /// Text
            InkWell(
              child: lbl(globals.text.liveWith(), fontSize: AppHelper.fontSizeMedium),
              onTap: () {
                setState(() {
                  _chkLiveWithValue = !_chkLiveWithValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _btnAdd() {
    return CustomButton(
      text: Func.toStr(globals.text.save()),
      context: context,
      margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: _enabledBtnAdd ? _onPressedBtnAdd : null,
    );
  }

  _onPressedBtnAdd() {
    try {
      if (!_validation()) return;

      var req = AddRelativeRequest()
        ..relId = int.parse(_relativeComboValue)
        ..firstName = _relFirstNameController.text
        ..lastName = _relLastNameController.text
        ..regNo = _relRegNoFirstChar + _relRegNoSecondChar + _relRegNoController.text
        ..mobileNo = _relMobileController.text
        ..liveWith = _chkLiveWithValue ? 1 : 0;

      _enabledBtnAdd = false;

      _addRelativeBloc.add(AddRelative(request: req));
    } catch (e) {
      print(e);
    }
  }

  bool _validation() {
    if (!_isRelLastNameValid) {
      showSnackBar(key: _addRelativeKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.lastName()));
      return false;
    }

    if (!_isRelFirstNameValid) {
      showSnackBar(key: _addRelativeKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.firstName()));
      return false;
    }

    if (!_isRelRegNoValid) {
      showSnackBar(key: _addRelativeKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.registerNo()));
      return false;
    }

    if (!_isRelMobileValid) {
      showSnackBar(key: _addRelativeKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.mobile()));
      return false;
    }

    if (Func.isEmpty(_relativeComboValue)) {
      showSnackBar(key: _addRelativeKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.relative()));
      return false;
    }

    return true;
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
