import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/acnt/bank_acnt_list_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/caption_value.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/switch.dart';

class BankAcntDetailRoute extends StatefulWidget {
  const BankAcntDetailRoute({Key key, this.bankAcnt}) : super(key: key);

  final BankAcnt bankAcnt;

  @override
  _BankAcntDetailRouteState createState() => _BankAcntDetailRouteState();
}

class _BankAcntDetailRouteState extends State<BankAcntDetailRoute> {
  var _bankAcntDetailKey = GlobalKey<ScaffoldState>();
  double _paddingHorizontal = 20.0;

  /// Үндсэн данс
  bool _switchMainAcntValue = false;

  bool _enabledBtnDelete = true;

  @override
  void initState() {
    _switchMainAcntValue = (widget.bankAcnt.isMain == 1) ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AcntBloc, AcntState>(
      listener: _blocListener,
      child: BlocBuilder<AcntBloc, AcntState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _blocListener(BuildContext context, AcntState state) {
    if (state is RemoveBankAcntSuccess) {
      BlocProvider.of<AcntBloc>(context).add(GetBankAcntList());
      Navigator.pop(context);
    } else if (state is RemoveBankAcntFailed) {
      _enabledBtnDelete = true;
      showSnackBar(key: _bankAcntDetailKey, text: state.text);
    } else if (state is UpdateBankAcntSuccess) {
      BlocProvider.of<AcntBloc>(context).add(GetBankAcntList());
    } else if (state is UpdateBankAcntFailed) {
      showSnackBar(key: _bankAcntDetailKey, text: state.text);
      _switchMainAcntValue = !_switchMainAcntValue;
    }
  }

  Widget _blocBuilder(BuildContext context, AcntState state) {
    return BlurLoadingContainer(
      loading: state is BankAcntLoading,
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
        key: _bankAcntDetailKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              /// Миний данс
              Container(
                padding: EdgeInsets.only(right: _paddingHorizontal, left: _paddingHorizontal),
                child: lbl(globals.text.myAcnt(), style: lblStyle.Headline4, color: AppColors.lblDark, fontWeight: FontWeight.normal),
              ),

              SizedBox(height: 20.0),

              CustomCard(
                margin: EdgeInsets.only(right: AppHelper.margin, left: AppHelper.margin),
                child: Column(
                  children: <Widget>[
                    /// Дансны мэдээлэл
                    lbl(globals.text.acntDetail(), style: lblStyle.Headline5, margin: EdgeInsets.all(AppHelper.margin)),

                    /// Line
                    Divider(height: 1.0, color: AppColors.lineGreyCard),

                    SizedBox(height: 17.0),

                    /// Банк
                    _bankNameWidget(),

                    SizedBox(height: 17.0),

                    /// Дансны дугаар
                    _bankAcntNoWidget(),

                    SizedBox(height: 17.0),

                    /// Дансны нэр
                    _bankAcntNameWidget(),

                    SizedBox(height: 17.0),

                    /// Үндсэн данс
                    _switchMainAcnt(),

                    SizedBox(height: 80.0),

                    _btnRemove(),

//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Expanded(child: _btnRemove(), flex: 1),
//                        Expanded(child: Container(), flex: 1),
//                      ],
//                    ),

                    SizedBox(height: 20.0),
                  ],
                ),
              ),

              SizedBox(height: AppHelper.marginBottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bankNameWidget() {
    return CaptionValue(
      caption: '${globals.text.bank()}:',
      value: widget.bankAcnt.bankName,
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
    );
  }

  Widget _bankAcntNoWidget() {
    return CaptionValue(
      caption: '${globals.text.acntNo()}:',
      value: widget.bankAcnt.acntNo,
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
    );
  }

  Widget _bankAcntNameWidget() {
    return CaptionValue(
      caption: '${globals.text.acntName()}:',
      value: widget.bankAcnt.acntName,
      margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
    );
  }

  Widget _btnRemove() {
    return CustomButton(
      text: Func.toStr(globals.text.remove()),
      context: context,
      margin: EdgeInsets.only(left: AppHelper.margin),
      color: AppColors.bgWhite,
      disabledColor: AppColors.bgWhite,
      textColor: AppColors.lblRed,
      disabledTextColor: AppColors.lblRed,
      fontSize: AppHelper.fontSizeMedium,
      image: Image.asset(AssetName.trash, color: AppColors.iconRed, width: 20.0, height: 20.0),
      onPressed: _enabledBtnDelete
          ? () {
              setState(() {
                _enabledBtnDelete = false;
              });
              BlocProvider.of<AcntBloc>(context).add(RemoveBankAcntEvent(bankCode: widget.bankAcnt.bankCode));
            }
          : null,
    );
  }

  Widget _switchMainAcnt() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Үндсэн данс
          Expanded(
            child: lbl(globals.text.mainAcnt(), style: lblStyle.Medium),
          ),

          /// Switch
          CustomSwitch(
            value: _switchMainAcntValue,
            onChanged: (val) {
              _switchMainAcntValue = val;

              BlocProvider.of<AcntBloc>(context).add(UpdateBankAcntEvent(
                custCode: globals.user.custCode,
                bankCode: widget.bankAcnt.bankCode,
                isMain: _switchMainAcntValue ? 1 : 0,
              ));
            },
          ),
        ],
      ),
    );
  }

  _onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
