import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/containers/rounded_container.dart';
import 'package:netware/modules/settings/ui/history/bonus_history_tab.dart';
import 'package:netware/modules/settings/ui/history/loan_history_tab.dart';
import 'package:netware/modules/settings/ui/settings_header.dart';

/// Түүх
class HistoryRoute extends StatefulWidget {
  @override
  _HistoryRouteState createState() => _HistoryRouteState();
}

class _HistoryRouteState extends State<HistoryRoute> with TickerProviderStateMixin {
  /// UI
  var _historyKey = GlobalKey<ScaffoldState>();

  /// Cupertino segmented control
  TabController _tabController;
  int _selectedIndex = 0;
  Map<int, Widget> _headerList = new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget> _childList = []; //The Widgets that has to be loaded when a tab is selected.

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    // Tab headers
    _headerList = new Map();
    _headerList.putIfAbsent(0, () => Container(child: Text("${globals.text.loan()}")));
    _headerList.putIfAbsent(1, () => Container(child: Text("${globals.text.bonusPoint()}")));

    // Tab children
    _childList.addAll([
      LoanHistoryTab(),
      BonusHistoryTab(),
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _historyKey,
        backgroundColor: AppColors.bgGrey,
        appBar: AppBarSimple(
          context: context,
          brightness: Brightness.light,
          onPressed: () {
            _onBackPressed(context);
          },
          hasBackArrow: true,
        ),
        body: Column(
          children: <Widget>[
            /// Тохиргоо
            SettingsHeader(title: globals.text.history(), margin: const EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 10.0)),

            /// Tab bar
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
                        _tabController.animateTo(value);
                      },
                      groupValue: _selectedIndex,
                      children: <int, Widget>{
                        0: Container(
//                          width: double.infinity,
                          child: Text('${globals.text.loan()}'),
                          alignment: Alignment.center,
                        ),
                        1: Container(
//                          width: double.infinity,
                          child: Text('${globals.text.bonusPoint()}'),
                          alignment: Alignment.center,
                        ),
                      },
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                ],
              ),
            ),

            /// Tab children
//            RoundedContainer(child: _childList[_selectedIndex]),

            Expanded(
              child: RoundedContainer(
                margin: cupertino.EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    LoanHistoryTab(),
                    BonusHistoryTab(),
                  ],
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ),
          ],
        ));
  }

  _onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
