import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/settings/settings_link_response.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/routes/coming_soon_route.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/list_item.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/settings/bloc/help_bloc.dart';
import 'package:netware/modules/settings/ui/web_view_route.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings_header.dart';

class HelpRoute extends StatefulWidget {
  @override
  _HelpRouteState createState() => _HelpRouteState();
}

class _HelpRouteState extends State<HelpRoute> {
  /// UI
  final _helpKey = GlobalKey<ScaffoldState>();
  final double _cardMargin = 15.0;

  /// Data
  HelpBloc _helpBloc;
  SettingsLinkResponse _settingsLinkResponse;

  @override
  void initState() {
    _helpBloc = HelpBloc()..add(GetSettingsLinks());
    super.initState();
  }

  @override
  void dispose() {
    _helpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HelpBloc>(
      create: (context) => _helpBloc,
      child: BlocListener<HelpBloc, HelpState>(
        listener: _blocListener,
        child: BlocBuilder<HelpBloc, HelpState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, HelpState state) {
    if (state is GetSettingsLinksSuccess) {
      _settingsLinkResponse = state.settingsLinkResponse;
    } else if (state is ShowSnackBar) {
      showSnackBar(key: _helpKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, HelpState state) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: BlurLoadingContainer(
        loading: state is HelpLoading,
        child: Scaffold(
          key: _helpKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarSimple(context: context, onPressed: _onBackPressed, brightness: Brightness.light),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Header
                SettingsHeader(title: globals.text.help()),

                CustomCard(
                  margin: EdgeInsets.only(right: _cardMargin, left: _cardMargin),
                  child: Column(
                    children: <Widget>[
                      /// Гарын авлага
                      MenuListItem(
                          text: globals.text.userGuide(),
                          onPressed: () {
//                            Navigator.push(context, FadeRouteBuilder(route: ComingSoonRoute()));

                            Navigator.push(context,
                                FadeRouteBuilder(route: WebViewRoute(title: globals.text.userGuide(), url: _settingsLinkResponse.userGuide)));
                          }),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Түгээмэл асуулт
                      MenuListItem(
                          text: globals.text.faq(),
                          onPressed: () {
//                            Navigator.push(context, FadeRouteBuilder(route: ComingSoonRoute()));
                            Navigator.push(context, FadeRouteBuilder(route: WebViewRoute(title: globals.text.faq(), url: _settingsLinkResponse.faq)));
                          }),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Оператортай холбогдох
                      MenuListItem(
                          text: globals.text.callOperator(),
                          textColor: AppColors.lblBlue,
                          onPressed: () {
                            _callToOperator();
                          }),

                      Divider(height: 2.0, color: AppColors.bgGrey),

                      /// Вэбсайт
                      MenuListItem(
                        text: globals.text.webSite(),
                        textColor: AppColors.lblBlue,
                        onPressed: () => Navigator.push(
                            context, FadeRouteBuilder(route: WebViewRoute(title: globals.text.webSite(), url: _settingsLinkResponse.web))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _callToOperator() async {
    if (_settingsLinkResponse == null) {
      showSnackBar(key: _helpKey, text: globals.text.noData());
      return;
    }

    String url = "tel:${_settingsLinkResponse.contact}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showSnackBar(key: _helpKey, text: globals.text.errorOccurred());
    }
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
