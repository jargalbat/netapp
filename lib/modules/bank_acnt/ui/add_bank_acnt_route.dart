import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/switch.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/bank_acnt/bloc/add_bank_acnt_bloc.dart';

class AddBankAcntRoute extends StatefulWidget {
  AddBankAcntRoute({Key key}) : super(key: key);

  @override
  _AddBankAcntRouteState createState() => _AddBankAcntRouteState();
}

class _AddBankAcntRouteState extends State<AddBankAcntRoute> {
  final _addBankListKey = GlobalKey<ScaffoldState>();
  double _paddingHorizontal = 20.0;
  AddBankAcntBloc _addBankListBloc;

  /// Банк
  List<DictionaryData> _bankList;
  DictionaryData _selectedBank;

  /// Дансны дугаар
  TextEditingController _acntNoController = TextEditingController();
  FocusNode _acntNoFocusNode;
  bool _isValidAcntNo = false;

  /// Үндсэн данс
  bool _switchMainAcntValue = false;

  @override
  void initState() {
    super.initState();
    _addBankListBloc = AddBankAcntBloc()..add(GetBankList());
  }

  @override
  void dispose() {
    _addBankListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddBankAcntBloc>(
      create: (context) => _addBankListBloc,
      child: BlocListener<AddBankAcntBloc, AddBankAcntState>(
        listener: _blocListener,
        child: BlocBuilder<AddBankAcntBloc, AddBankAcntState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AddBankAcntState state) {
    if (state is GetBankListSuccess) {
      _bankList = state.bankList;
      _selectedBank = _bankList.first;
    } else if (state is ShowSnackBar) {
      showSnackBar(key: _addBankListKey, text: state.text);
    } else if (state is AddBankAcntSuccess) {
      Navigator.pop(context);
      BlocProvider.of<AcntBloc>(context).add(GetBankAcntList());
    }
  }

  Widget _blocBuilder(BuildContext context, AddBankAcntState state) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBarSimple(
          context: context,
          brightness: Brightness.light,
          onPressed: () {
            _onBackPressed(context);
          },
          hasBackArrow: true,
        ),
        backgroundColor: AppColors.bgGrey,
        key: _addBankListKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode()); // Keyboard хаах
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: _paddingHorizontal, left: _paddingHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// Миний данс
                      lbl(globals.text.myAcnt(), style: lblStyle.Headline4, color: AppColors.lblDark, fontWeight: FontWeight.normal),

                      /// Profile pic
//                        Image.asset(AssetName.profile_pic, width: 37.0, colorBlendMode: BlendMode.modulate),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

                /// Зээл хүлээн авах данс
                CustomCard(
                  margin: EdgeInsets.only(top: 0.0, right: _paddingHorizontal, bottom: 20.0, left: _paddingHorizontal),
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      /// Данс нэмэх
                      lbl(globals.text.addAcnt(), style: lblStyle.Headline5),

                      SizedBox(height: 15.0),

                      /// Та зөвхөн өөрийн нэр дээр бүртгэлтэй дансаа бүртгүүлнэ үү.
                      lbl(
                        globals.text.addAcntHint(),
                        style: lblStyle.Medium,
                        maxLines: 2,
                      ),

                      SizedBox(height: 20.0),

                      /// Банк сонгох
                      lbl(
                        globals.text.chooseBank(),
                        style: lblStyle.Caption,
                        color: AppColors.lblDark,
                        margin: EdgeInsets.only(top: 0.0, right: 10.0, left: 10.0),
                      ),
                      SizedBox(height: 15.0),

                      /// Combo
                      _bankCombo(),

                      SizedBox(height: 15.0),

                      /// Дансны дугаар
                      _txtAcntNo(),

                      SizedBox(height: 15.0),

                      /// Үндсэн данс
                      _switchMainAcnt(),

                      SizedBox(height: 30.0),

                      /// Button Баталгаажуулах
                      _btnSave(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bankCombo() {
    return GestureDetector(
      onTap: (_bankList != null && _bankList.isNotEmpty) ? _settingModalBottomSheet : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        padding: const EdgeInsets.only(left: 15.0, right: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(AppHelper.borderRadiusBtn),
            ),
            color: AppColors.bgGrey),
        height: 50.0,
        child: _selectedBank != null
            ? FadeInSlow(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
//                    /// Image
//                    Func.isNotEmpty(_assetImageName)
//                        ? Container(
//                      child: Image.asset(_assetImageName, height: AppHelper.heightComboImage),
//                      margin: EdgeInsets.only(left: 12.0),
//                    )
//                        : Container(),

                    /// Text
                    Expanded(
                      child: lbl(_selectedBank.txt),
                    ),

                    /// Suffix icon
                    Align(
                      child: Container(
                        padding: EdgeInsets.only(right: 5.0),
//                        child: Icon(Icons.keyboard_arrow_down, size: AppHelper.iconSize),
                        child: Image.asset(
                          AssetName.down_arrow,
                          height: 20.0,
                          width: 20.0,
                          color: AppColors.iconMirage,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  void _settingModalBottomSheet() {
    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext bc) {
    //       return ListView(
    //         children: <Widget>[
    //           for (var el in _bankList) _listItem(el),
    //         ],
    //       );
    //     });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _bankList.length,
          itemBuilder: (context, i) {
            return _listItem(i);
          },
        );
      },
    );
  }

  Widget _listItem(int i) {
    return ListTile(
      leading: Image.asset(DictionaryManager.getAssetNameByCode(_bankList[i].val), height: AppHelper.heightComboImage),
      title: lbl(_bankList[i].txt),
      onTap: () {
        setState(() => _selectedBank = _bankList[i]);

        Navigator.pop(context);
      },
    );
  }

  Widget _txtAcntNo() {
    return txt(
      context: context,
      margin: EdgeInsets.only(top: 0.0, right: 10.0, left: 10.0),
      labelText: globals.text.acntNo(),
      controller: _acntNoController,
      maxLength: 20,
      textInputType: TextInputType.number,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGreyDark,
    );
  }

  Widget _switchMainAcnt() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Үндсэн данс болгох
          Expanded(
            child: lbl(globals.text.makeMainAcnt(), style: lblStyle.Medium),
          ),

          /// Switch
          CustomSwitch(
            value: _switchMainAcntValue,
            onChanged: (val) {
              _switchMainAcntValue = val;
            },
          ),
        ],
      ),
    );
  }

  Widget _btnSave() {
    return CustomButton(
      text: Func.toStr(globals.text.save()),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: () {
        FocusScope.of(context).requestFocus(new FocusNode());

        // Validation
        if (!_validation()) return;

        _addBankListBloc.add(
          AddBankAcnt(
            bankCode: _selectedBank.val,
            acntNo: _acntNoController.text,
            isMain: _switchMainAcntValue ? 1 : 0,
          ),
        );
      },
    );
  }

  bool _validation() {
    bool isValidated = true;
    try {
      if (_selectedBank == null) {
        showSnackBar(key: _addBankListKey, text: globals.text.msgChooseBank());
        return false;
      }

      if (_acntNoController.text.isEmpty) {
        showSnackBar(key: _addBankListKey, text: globals.text.msgEnterAcntNo());
        return false;
      }
    } catch (e) {
      print(e);
    }

    return isValidated;
  }

  _onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
