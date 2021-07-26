import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/routes/new_user_route.dart';
import 'package:netware/app/routes/term_cond/bloc/term_cond_bloc.dart';
import 'package:netware/app/shared_pref_key.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/login/login_route.dart';
import 'package:netware/modules/sign_up/sign_up_helper.dart';

class TermCondRoute extends StatefulWidget {
  @override
  _TermCondRouteState createState() => _TermCondRouteState();
}

class _TermCondRouteState extends State<TermCondRoute> {
  /// UI
  final _privacyKey = GlobalKey<ScaffoldState>();
  final _paddingHorizontal = 20.0;

  /// Data
  TermCondBloc _termCondBloc;

  /// Term cond
  String _termCondStr = '';

  /// Checkbox agree
  bool _chkAgreeVal = false;

  @override
  void initState() {
    _termCondBloc = TermCondBloc()..add(GetTermCond());
    super.initState();
  }

  @override
  void dispose() {
    _termCondBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TermCondBloc>(
      create: (context) => _termCondBloc,
      child: BlocListener<TermCondBloc, TermCondState>(
        listener: _blocListener,
        child: BlocBuilder<TermCondBloc, TermCondState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, TermCondState state) {
    if (state is GetTermCondSuccess) {
      _termCondStr = state.termCondStr;
    } else if (state is ShowSnackBar) {
      showSnackBar(key: _privacyKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, TermCondState state) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _privacyKey,
        appBar: AppBarEmpty(context: context, brightness: Brightness.light, backgroundColor: AppColors.bgGreyLight),
        backgroundColor: AppColors.bgGreyLight,
        body: LoadingContainer(
          loading: state is TermCondLoading,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0),

              /// Үйлчилгээний нөхцөл
              lbl(
                globals.text.termCond(),
                style: lblStyle.Headline4,
                color: AppColors.lblBlue,
                padding: EdgeInsets.only(left: _paddingHorizontal),
              ),

              SizedBox(height: 15.0),

              /// HTML
              Expanded(
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0.0, right: 20.0, bottom: 20.0, left: 20.0),
                      padding: EdgeInsets.only(top: 10.0),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Func.isEmpty(_termCondStr) ? Container() : Html(data: _termCondStr),
                      ),
                    ),
                  ],
                ),
              ),

              /// Check box
              _chkAgree(),

              SizedBox(height: 20.0),

              /// Button - Зөвшөөрөх
              _btnAgree(),

              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  _chkAgree() {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: AppColors.chkUnselectedGrey,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        padding: EdgeInsets.only(left: 5.0, right: _paddingHorizontal),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Checkbox(
              value: _chkAgreeVal,
              activeColor: AppColors.jungleGreen,
              onChanged: (bool newValue) {
                setState(() {
                  _chkAgreeVal = newValue;
                });
              },
            ),
            Flexible(
              child: InkWell(
                child: lbl(
                  globals.text.termCondAgree(),
                  fontSize: AppHelper.fontSizeCaption,
                  maxLines: 2,
                ),
                onTap: () {
                  setState(() => _chkAgreeVal = !_chkAgreeVal);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _btnAgree() {
    return CustomButton(
      text: Func.toStr(globals.text.agree()),
      isUppercase: false,
      context: context,
      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnGreyDisabled,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: _chkAgreeVal //&& !Func.isEmpty(_termCondStr)
          ? () {
              globals.sharedPref.setBool(SharedPrefKey.PrivacyPolicy, true);
              SignUpHelper.isLoginRouteExists = false;
              //todo
              Navigator.pushReplacement(context, FadeRouteBuilder(route: NewUserRoute()));
//              Navigator.pushReplacement(context, FadeRouteBuilder(route: LoginRoute()));
            }
          : null,
    );
  }
}
