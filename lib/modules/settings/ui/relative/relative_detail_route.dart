import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/api/models/settings/relative_list_response.dart';
import 'package:netware/api/models/settings/update_relative_request.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/caption_value.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/combobox/combo_bloc.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/combobox/combobox.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/settings/bloc/relative_detail_bloc.dart';
import 'package:netware/modules/settings/bloc/relative_list_bloc.dart';

class RelativeDetailRoute extends StatefulWidget {
  final Relative relative;

  const RelativeDetailRoute({Key key, this.relative}) : super(key: key);

  @override
  _RelativeDetailRouteState createState() => _RelativeDetailRouteState();
}

class _RelativeDetailRouteState extends State<RelativeDetailRoute> {
  /// UI
  final _relativeDetailKey = GlobalKey<ScaffoldState>();

  // Data
  final RelativeDetailBloc _relativeDetailBloc = RelativeDetailBloc();

  // Last name
  TextEditingController _rdLastNameController = TextEditingController();

  // First name
  TextEditingController _rdFirstNameController = TextEditingController();

  // Register number
  TextEditingController _rdRegNoController = TextEditingController();

  // Mobile
  TextEditingController _rdMobileController = TextEditingController();

  // Таны хэн болох
  final _relativeComboBloc = ComboBloc();
  List<ComboItem> _relativeComboItemList = [];
  String _relativeComboValue;

  // Хамт амьдардаг эсэх
  bool _chkLiveWithValue = false;

  // Button - Хадгалах
  bool _enabledBtnSave = true;

  @override
  void initState() {
    _relativeDetailBloc.add(GetRelativeComboList());

    _rdLastNameController.text = widget.relative.lastName ?? '';
    _rdFirstNameController.text = widget.relative.firstName ?? '';
    _rdRegNoController.text = widget.relative.regNo ?? '';
    _rdMobileController.text = widget.relative.mobileNo ?? '';
    _chkLiveWithValue = (widget.relative.liveWith == 1) ? true : false;
    super.initState();
  }

  @override
  void dispose() {
    _relativeComboBloc.close();
    _relativeDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RelativeDetailBloc>(
      create: (context) => _relativeDetailBloc,
      child: BlocListener<RelativeDetailBloc, RelativeDetailState>(
        listener: _blocListener,
        child: BlocBuilder<RelativeDetailBloc, RelativeDetailState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, RelativeDetailState state) {
    if (state is RemoveRelativeSuccess) {
      BlocProvider.of<RelativeBloc>(context).add(GetRelativeList());
      Navigator.pop(context);
    } else if (state is RemoveRelativeFailed) {
      showSnackBar(key: _relativeDetailKey, text: state.text);
    } else if (state is UpdateRelativeSuccess) {
      BlocProvider.of<RelativeBloc>(context).add(GetRelativeList());
      showSnackBar(key: _relativeDetailKey, text: globals.text.success());
      _enabledBtnSave = true;
    } else if (state is UpdateRelativeFailed) {
      showSnackBar(key: _relativeDetailKey, text: state.text);
    } else if (state is GetRelativeComboListSuccess) {
      _relativeComboItemList = state.relativeComboList;
      _relativeComboValue = Func.toStr(widget.relative.relId);
      String text = ComboHelper.getComboTextByValue(_relativeComboItemList, Func.toStr(_relativeComboValue));
      _relativeComboBloc.add(SelectRelativeItemEvent(text: text));
    }
  }

  Widget _blocBuilder(BuildContext context, RelativeDetailState state) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: BlurLoadingContainer(
        loading: state is RelativeDetailLoading,
        child: Scaffold(
          key: _relativeDetailKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarSimple(context: context, onPressed: _onBackPressed, brightness: Brightness.light),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode()); // Hide keyboard
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Column(
                      children: <Widget>[
                        /// Холбоотой хүмүүс
                        lbl(
                          globals.text.relative(),
                          style: lblStyle.Headline5,
                          margin: EdgeInsets.all(AppHelper.margin),
                        ),

                        /// Line
                        Divider(height: 1.0, color: AppColors.lineGreyCard),

                        /// Овог
                        _lastNameWidget(),

                        /// Нэр
                        _firstNameWidget(),

                        /// Регистрийн дугаар
                        _regNoWidget(),

                        /// Утас
                        _mobileWidget(),

                        /// Хэн болох
                        _relativeNameWidget(),

                        /// Хамт амьдардаг эсэх
                        _chkLiveWith(),

                        SizedBox(height: 80.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            /// Button - Устгах
                            _btnRemove(),

                            SizedBox(width: 10.0),

                            /// Button - Хадгалах
                            _btnUpdate(),
                          ],
                        ),

                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lastNameWidget() {
    return CaptionValue(
      caption: '${globals.text.lastName().toUpperCase()}:',
      valueWidget: TxtClean(controller: _rdLastNameController, fontWeight: FontWeight.w500),
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 5.0, AppHelper.margin, 0.0),
    );
  }

  Widget _firstNameWidget() {
    return CaptionValue(
      caption: '${globals.text.firstName().toUpperCase()}:',
      valueWidget: TxtClean(controller: _rdFirstNameController, fontWeight: FontWeight.w500),
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
    );
  }

  Widget _regNoWidget() {
    return CaptionValue(
      caption: '${globals.text.registerNo().toUpperCase()}:',
      valueWidget: TxtClean(controller: _rdRegNoController, fontWeight: FontWeight.w500),
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
    );
  }

  Widget _mobileWidget() {
    return CaptionValue(
      caption: '${globals.text.mobile().toUpperCase()}:',
      valueWidget: TxtClean(controller: _rdMobileController, fontWeight: FontWeight.w500),
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
    );
  }

  Widget _relativeNameWidget() {
    return CaptionValue(
      caption: '${globals.text.relativeWho().toUpperCase()}:',
      valueWidget: _relativeComboItemList.isNotEmpty
          ? FadeInSlow(
              child: CustomCombo(
                comboBloc: _relativeComboBloc,
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                list: _relativeComboItemList,
                initialText: _relativeComboItemList[0].txt,
                width: 200.0,
                bgColor: AppColors.txtBgGreyDark,
                onItemSelected: (value) {
                  DictionaryData data = value;
                  try {
                    _relativeComboValue = data.val;
                    print(_relativeComboValue);
                  } catch (e) {
                    showSnackBar(key: _relativeDetailKey, text: globals.text.errorOccurred());
                  }
                },
              ),
            )
          : Container(height: 60.0),
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
    );
  }

  Widget _chkLiveWith() {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: AppColors.chkUnselectedGrey,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(10.0, AppHelper.margin, AppHelper.margin, 0.0),
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

  Widget _btnRemove() {
    return Expanded(
      child: CustomButton(
        text: Func.toStr(globals.text.remove()),
        context: context,
        margin: EdgeInsets.only(left: AppHelper.margin),
        color: AppColors.bgWhite,
        textColor: AppColors.lblRed,
        fontSize: AppHelper.fontSizeMedium,
        image: Image.asset(AssetName.trash, color: AppColors.iconRed, width: 20.0, height: 20.0),
        onPressed: () {
          _relativeDetailBloc.add(RemoveRelative(relativeId: widget.relative.relativeId));
        },
      ),
    );
  }

  Widget _btnUpdate() {
    return Expanded(
      child: CustomButton(
        text: globals.text.save(),
        context: context,
        margin: EdgeInsets.only(right: AppHelper.margin),
        color: AppColors.btnBlue,
        textColor: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        onPressed: _enabledBtnSave
            ? () {
                if (!_validation()) return;

                _enabledBtnSave = false;

                var request = UpdateRelativeRequest()
                  ..relativeId = widget.relative.relativeId
                  ..lastName = _rdLastNameController.text
                  ..firstName = _rdFirstNameController.text
                  ..regNo = _rdRegNoController.text
                  ..mobileNo = _rdFirstNameController.text
                  ..relId = int.parse(_relativeComboValue)
                  ..liveWith = _chkLiveWithValue ? 1 : 0;

                _relativeDetailBloc.add(UpdateRelative(request: request));
              }
            : null,
      ),
    );
  }

  bool _validation() {
    if (Func.isEmpty(_rdLastNameController.text)) {
      showSnackBar(key: _relativeDetailKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.lastName()));
      return false;
    }

    if (Func.isEmpty(_rdFirstNameController.text)) {
      showSnackBar(key: _relativeDetailKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.firstName()));
      return false;
    }

    if (Func.isEmpty(_rdRegNoController.text)) {
      showSnackBar(key: _relativeDetailKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.registerNo()));
      return false;
    }

    if (Func.isEmpty(_rdMobileController.text)) {
      showSnackBar(key: _relativeDetailKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.mobile()));
      return false;
    }

    if (Func.isEmpty(_relativeComboValue)) {
      showSnackBar(key: _relativeDetailKey, text: globals.text.pleaseEnter().replaceAll(AppHelper.textHolder, globals.text.relative()));
      return false;
    }

    return true;
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
