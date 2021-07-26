import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/notification/notif_list_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/containers/rounded_container.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/notification/bloc/notif_bloc.dart';
import 'package:flutter/cupertino.dart' as cupertino;

class NotifRoute extends StatefulWidget {
  @override
  _NotifRouteState createState() => _NotifRouteState();
}

class _NotifRouteState extends State<NotifRoute> with TickerProviderStateMixin {
  /// UI
  var _notifKey = GlobalKey<ScaffoldState>();

  /// Data
  var _notifList = <Notif>[];

  /// Cupertino segmented control
  TabController _notifTabController;
  int _selectedIndex = 0;
  List<Widget> _childList = []; //The Widgets that has to be loaded when a tab is selected.

  @override
  void initState() {
    _notifTabController = TabController(initialIndex: 0, length: 2, vsync: this);

    BlocProvider.of<NotifBloc>(context).add(GetNotifList());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotifBloc, NotifState>(
      listener: _blocListener,
      child: BlocBuilder<NotifBloc, NotifState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _blocListener(BuildContext context, NotifState state) {
    if (state is GetNotifListSuccess) {
      _notifList = state.notifListResponse.notifList;
    } else if (state is ShowSnackBar) {
      showSnackBar(key: _notifKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, NotifState state) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBarSimple(
          context: context,
          brightness: Brightness.light,
          hasBackArrow: true,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.bgGrey,
        key: _notifKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: <Widget>[
              lbl(
                globals.text.notification(),
                style: lblStyle.Headline4,
                color: AppColors.lblDark,
                margin: EdgeInsets.only(left: 20.0),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: cupertino.CupertinoSegmentedControl(
                        onValueChanged: (value) {
                          setState(() {
                            _selectedIndex = value;
                          });
                          _notifTabController.animateTo(value);
                        },
                        groupValue: _selectedIndex,
                        children: <int, Widget>{
                          0: Container(
//                          width: double.infinity,
                            child: Text(globals.text.notification()),
                            alignment: Alignment.center,
                          ),
                          1: Container(
//                          width: double.infinity,
                            child: Text(globals.text.news()),
                            alignment: Alignment.center,
                          ),
                        },
                        padding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RoundedContainer(
//                  margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
                  radius: 20.0,
                  child: TabBarView(
                    controller: _notifTabController,
                    children: [
                      /// Мэдэгдэл tab
                      _notificationTab(state),

                      /// Мэдээ tab
                      Container(),
                    ],
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationTab(NotifState state) {
    return LoadingContainer(
      loading: state is NotifLoading,
      child: (_notifList != null && _notifList.isNotEmpty)
          ? SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(AppHelper.margin, AppHelper.margin, AppHelper.margin, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// Мэдэгдлийн түүх
                        lbl(globals.text.notifHistory(), color: AppColors.lblGrey),

                        /// Бүгдийг уншсан
                        TextButton(
                          text: globals.text.readAll(),
                          textColor: AppColors.lblBlue,
                          onPressed: () {
                            //todo
                          },
                        ),
                      ],
                    ),
                  ),

                  /// Тусгаарлагч зураас
                  Divider(color: AppColors.lineLightGrey),

                  /// Children
                  for (var el in _notifList) _listItem(el),
                ],
              ),
            )
          : Container(),
    );
  }

  Widget _listItem(Notif notif) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppHelper.margin, 10.0, AppHelper.margin, AppHelper.margin),
      child: Row(
        children: <Widget>[
          /// Changes
          ///

          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  /// Title
                  lbl(notif.title, maxLines: 3),

                  Expanded(child: Container()),

                  /// Date
                  lbl(Func.toDateStr(notif.sentDatetime), color: AppColors.lblGrey),
                ],
              ),

              SizedBox(height: 5.0),

              /// Body
              lbl(notif.body, color: AppColors.lblGrey, maxLines: 10),
            ],
          ),
        ],
      ),
    );
  }

//  showModalBottomSheet(
//  context: context,
//  builder: (BuildContext context) {
//  return ListView.builder(
//  itemCount: _bankList.length,
//  itemBuilder: (context, i) {
//  return _listItem(i);
//  },
//  );
//  },
//  );
}
