import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/api/bloc/connection_manager2.dart';
import 'package:netware/app/bloc/fee_score_bloc.dart';
import 'package:netware/app/bloc/push_notif_bloc.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/themes.dart';
import 'package:netware/app/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/modules/home/bloc/home_bloc.dart';
import 'package:netware/modules/notification/bloc/notif_bloc.dart';
import 'package:netware/modules/settings/bloc/relative_list_bloc.dart';
import 'app/bloc/acnt_bloc.dart';
import 'app/bloc/app_bloc.dart';
import 'app/routes/splash_route.dart';

void main() {
  /// Binds the framework to flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  /// Bloc event
  BlocSupervisor.delegate = SimpleBlocDelegate();

  /// Run flutter application
  runApp(NetwareApp());
}

final pushNotifBloc = PushNotificationBloc(); //todo

class NetwareApp extends StatelessWidget {
  final _acntBloc = AcntBloc();
  final _relativeBloc = RelativeBloc();
  final _limitFeeScoreBloc = FeeScoreBloc();
  final _homeBloc = HomeBloc();
  final _notifBloc = NotifBloc();

//  Router _router;

  NetwareApp() {
    /// Global params
    globals = Globals();

    /// Route manager
//    _router = Router();

    /// Blocs
    appBloc.add(InitGlobals());

    /// Api
    connectionManager = ConnectionManager();
//    connectionManager2 = ConnectionManager2();
  }

  void dispose() {
    appBloc.close();
    _acntBloc.close();
    _relativeBloc.close();
    _limitFeeScoreBloc.close();
    _homeBloc.close();
    _notifBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(appBloc));

    return MultiBlocProvider(
      /// Providers
      providers: [
        BlocProvider<AppBloc>(create: (BuildContext context) => appBloc),
        BlocProvider<AcntBloc>(create: (BuildContext context) => _acntBloc),
        BlocProvider<RelativeBloc>(create: (BuildContext context) => _relativeBloc),
        BlocProvider<FeeScoreBloc>(create: (BuildContext context) => _limitFeeScoreBloc),
        BlocProvider<HomeBloc>(create: (BuildContext context) => _homeBloc),
        BlocProvider<NotifBloc>(create: (BuildContext context) => _notifBloc),
      ],

      /// Listeners
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppBloc, AppState>(
            listener: _blocListener,
          ),
//            BlocListener<BlocB, BlocBState>(
//              listener: (context, state) {},
//            ),
        ],
        child: BlocBuilder<AppBloc, AppState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AppState state) {
    if (state is LangENState) {
      print('EN');
    }

//    else if (state is LogoutState) {
////      Navigator.popUntil(context, (route) => route.isFirst);
//    }
  }

  Widget _blocBuilder(BuildContext context, AppState state) {
    return Listener(
      // TODO
      /// Session timeout listener
      onPointerDown: ([_]) => _handleUserInteraction(state),
      onPointerMove: ([_]) => _handleUserInteraction(state),

      /// Material app
      child: MaterialApp(
        theme: Themes.appTheme,
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        showSemanticsDebugger: false,
        title: "Netware",
        onGenerateTitle: (BuildContext context) => "Netware",
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: globals.supportedLocales(),
        locale: globals.locale,
//        onGenerateRoute: _router.getRoute,
//        navigatorObservers: [_router.routeObserver],
        home: SplashRoute(),

//        BlocProvider<AppBloc>(
//          create: (context) {
//            return _appBloc;
//          },
//          child: BlocBuilder<AppBloc, AppState>(
//            builder: (context, state) {
//              return SplashScreen();

//              if (state is AppInitial) {
//                SystemChrome.setEnabledSystemUIOverlays([]);
//
//                return Container(color: AppColors.bgBlue);
//              } else if (state is ShowSplash) {
//                /// Splash screen
//                return SplashScreen();
//              } else {
//                SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
//
////                FlutterStatusbarcolor.setStatusBarColor(AppColors.statusBarBlue);
//
//                /// Login Screen
//                return SplashScreen();
////                return HomeScreen();
//              }
//            },
//          ),
//        ),
      ),
    );
  }

  // todo
  static Timer _appTimer;

  void _initializeTimer() {
//    print(' $runtimeType _initializeTimer tick:${_appTimer?.tick}');
    _appTimer?.cancel();
    _appTimer = Timer.periodic(
      Duration(seconds: globals.appIdleTimeOutSec),
      (_) => _timeOut(),
    );
  }

  void _timeOut() {
    _appTimer.cancel();
    appBloc.add(LogoutEvent());
  }

  void _handleUserInteraction(AppState state) {
    if (!(state is AppInitState) && !(state is LoggedSuccessState)) {
      if (_appTimer == null) return;

      // User has been logged out
      if (!_appTimer.isActive) return;

      _initializeTimer();
    }
  }
}

/// Bloc events
class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AppBloc appBloc;

  LifecycleEventHandler(this.appBloc);

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        onPaused();
        break;
      case AppLifecycleState.resumed:
        onResume();
        break;
    }
  }

  void onResume() {}

  void onResumeDone(bool done) {}

  void onPaused() {}
}
