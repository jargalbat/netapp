import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/bloc/app_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/bloc/acnt_bloc.dart';
import 'package:netware/modules/home/bloc/home_bloc.dart';
import 'package:netware/modules/login/login_helper.dart';
import 'package:netware/modules/net_point/ui/net_point_tab.dart';
import 'package:netware/modules/settings/ui/settings_tab.dart';

import 'home_tab.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with SingleTickerProviderStateMixin {
  // UI
  final _homeRouteKey = GlobalKey<ScaffoldState>();

  // Bottom navigation bar
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Bloc listener
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is ChangeTabState) {
              _tabController.index = state.tabIndex;
            }
          },
        ),
        BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            if (state is LogoutState) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
      ],

      /// Bloc builder
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: _blocBuilder,
      ),
    );

//    return BlocListener<HomeBloc, HomeState>(
//      listener: _blocListener,
//      child: BlocBuilder<HomeBloc, HomeState>(
//        builder: _blocBuilder,
//      ),
//    );
  }

//  void _blocListener(BuildContext context, HomeState state) {
//    if (state is ChangeTabState) {
//      _tabController.index = state.tabIndex;
//    }
//  }

  Widget _blocBuilder(BuildContext context, HomeState state) {
    return WillPopScope(
      onWillPop: () async {
        if (_tabController.index == 0) {
          LoginHelper.showLogoutDialog(context);
        } else {
          BlocProvider.of<HomeBloc>(context).add(ChangeTab(tabIndex: 0));
        }

        return Future.value(false);
      },
      child: Scaffold(
        key: _homeRouteKey,
//        appBar: AppBarEmpty(context: context, brightness: Brightness.light, backgroundColor: AppColors.bgGreyLight),
        backgroundColor: AppColors.bgGrey,

        /// Main body
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            /// Нүүр
//            _tabController.index == 0 ? HomeTab() : Container(),
            HomeTab(scaffoldKey: _homeRouteKey),

            /// NET point
            _tabController.index == 1 ? NetPointTab(scaffoldKey: _homeRouteKey) : Container(),

            /// Тохиргоо
            _tabController.index == 2 ? SettingsTab() : Container(),
          ],
          physics: NeverScrollableScrollPhysics(),
        ),

        /// Bottom navigation bar
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: AppColors.bgWhite,
      child: Container(
        height: 70.0,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: AppColors.bgGrey),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            /// Нүүр
            _bottomNavigationBarItem(assetImage: AssetName.packet, index: 0, text: globals.text.home()),

            /// NET point
            _bottomNavigationBarItem(assetImage: AssetName.wallet, index: 1, text: globals.text.netPoint()),

            /// Тохиргоо
            _bottomNavigationBarItem(assetImage: AssetName.settings, index: 2, text: globals.text.settings()),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigationBarItem({String assetImage, int index, String text}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        /// Icon
        IconButton(
          icon: Image.asset(
            assetImage,
            width: 30.0,
            height: 30.0,
            color: _tabController.index == index ? AppColors.imgActive : AppColors.imgInactive,
          ),
          onPressed: () {
            if (index == 0) {
              BlocProvider.of<AcntBloc>(context).add(GetOnlineLoanList());
              setState(() {
                _tabController.index = index;
              });
//              BlocProvider.of<HomeBloc>(context).add(ChangeTab(tabIndex: index));
            } else if (index == 1) {
              /// Net point хуудас рүү шилжихээс өмнө серверээс мэдээлэлээ бүрэн татсан байх шаардлагатай
              if (globals.onlineLoanList != null) {
                setState(() {
                  _tabController.index = index;
                });
//                BlocProvider.of<HomeBloc>(context).add(ChangeTab(tabIndex: index));
              } else {
                print('test');
              }
            } else {
              /// Үндсэн tab шилжих үйлдэл

              setState(() {
                _tabController.index = index;
              });
//              BlocProvider.of<HomeBloc>(context).add(ChangeTab(tabIndex: index));
            }
          },
        ),

        /// Text
        lbl(text, fontSize: 10.0, color: _tabController.index == index ? AppColors.iconBlue : AppColors.imgInactive),
      ],
    );
  }
}
