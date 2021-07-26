//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:netware/modules/app/routes/empty_route.dart';
//import 'package:netware/modules/app/routes/splash_route.dart';
//import 'package:netware/modules/home/ui/home_route.dart';
//import 'package:netware/modules/login/login_route.dart';
//
//class Routes {
//  static const SplashScreen = "SplashScreen";
//  static const LoginScreen = "LoginScreen";
//  static const HomeScreen = "HomeScreen";
//}
//
//class Router {
//  final RouteObserver<PageRoute> routeObserver;
//
//  Router() : routeObserver = RouteObserver<PageRoute>();
//  Widget previousWidget;
//
//  Route<dynamic> getRoute(RouteSettings settings) {
////    print('Router.getRoute -> ($settings) ${routeObserver.navigator.widget} ${routeObserver.navigator.widget?.runtimeType}');
//
//    Route<dynamic> route;
//    Widget currentWidget;
//    switch (settings.name) {
//      case Routes.SplashScreen:
//        currentWidget = SplashRoute();
//        break;
//      case Routes.LoginScreen:
//        currentWidget = LoginScreen();
//        break;
//      case Routes.HomeScreen:
//        currentWidget = HomeRoute();
//        break;
//      default:
//        currentWidget = EmptyRoute();
//    }
//
//    route = _buildRouteBuilder(settings, currentWidget);
//
//    /// test
////    route = EnterExitRoute(previousWidget, currentWidget, settings);
//    previousWidget = currentWidget;
//
//    print(
//        'route -> ${route} ${route.navigator} ${route.navigator?.widget} ${route.settings} ${route.isCurrent} ${route.isActive} ${route.isFirst}');
//
//    return route;
//  }
//
//  PageRouteBuilder _buildRouteBuilder(RouteSettings settings, Widget builder) {
//    return PageRouteBuilder(
//      settings: settings,
//      pageBuilder: (BuildContext ctx, _, __) {
//        return builder;
//      },
//      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//        return FadeTransition(opacity: animation, child: child);
//      },
//    );
//  }
//
//  PageRouteBuilder _buildRouteBuilderDropFromTop(RouteSettings settings, Widget builder) {
//    return PageRouteBuilder(
//      settings: settings,
//      pageBuilder: (context, animation, secondaryAnimation) {
//        return builder;
//      },
//      transitionsBuilder: (context, animation, secondaryAnimation, child) {
//        var begin = Offset(0.0, -1.0);
//        var end = Offset.zero;
//        var curve = Curves.easeIn;
//
//        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//        return SlideTransition(
//          position: animation.drive(tween),
//          child: child,
//        );
//      },
//    );
//  }
//}
//
//class SlideRightRoute extends PageRouteBuilder {
//  final Widget w;
//  final RouteSettings settings;
//
//  SlideRightRoute(this.w, this.settings)
//      : super(
//    settings: settings,
//    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//      return w;
//    },
//    transitionsBuilder:
//        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//      return new SlideTransition(
//        position: new Tween<Offset>(
//          begin: const Offset(1.0, 0.0),
//          end: Offset.zero,
//        ).animate(animation),
//        child: child,
//      );
//    },
//  );
//}
//
//class EnterExitRoute extends PageRouteBuilder {
//  final Widget enterPage;
//  final Widget exitPage;
//  final RouteSettings settings;
//
//  EnterExitRoute(this.exitPage, this.enterPage, this.settings)
//      : super(
//    settings: settings,
//    pageBuilder: (
//        BuildContext context,
//        Animation<double> animation,
//        Animation<double> secondaryAnimation,
//        ) =>
//    enterPage,
//    transitionsBuilder: (
//        BuildContext context,
//        Animation<double> animation,
//        Animation<double> secondaryAnimation,
//        Widget child,
//        ) =>
//        Stack(
//          children: <Widget>[
//            SlideTransition(
//              position: new Tween<Offset>(
//                begin: const Offset(0.0, 0.0),
//                end: const Offset(-1.0, 0.0),
//              ).animate(animation),
//              child: exitPage ?? Container(),
//            ),
//            SlideTransition(
//              position: new Tween<Offset>(
//                begin: const Offset(1.0, 0.0),
//                end: Offset.zero,
//              ).animate(animation),
//              child: enterPage,
//            )
//          ],
//        ),
//  );
//}
