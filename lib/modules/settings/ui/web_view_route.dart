import 'dart:io';

import 'package:flutter/material.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/containers/rounded_container.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/modules/settings/ui/settings_header.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewRoute extends StatefulWidget {
  const WebViewRoute({Key key, this.url, this.title}) : super(key: key);

  final String url;
  final String title;

  @override
  _WebViewRouteState createState() => _WebViewRouteState();
}

class _WebViewRouteState extends State<WebViewRoute> {
  /// UI
  final _webKey = GlobalKey<ScaffoldState>();

  /// Web view
  bool _isInit = true;
  bool _loading = true;
  WebViewController controller;

  @override
  void initState() {
    super.initState();
//    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        key: _webKey,
        backgroundColor: AppColors.bgGrey,
        appBar: AppBarSimple(context: context, onPressed: _onBackPressed, brightness: Brightness.light),
        body: LoadingContainer(
          loading: _loading,
          child: RoundedContainer(
            child: WebView(
              initialUrl: widget.url,
//                  initialUrl: 'https://www.google.mn',
//                  initialUrl: 'http://www.netcapital.mn',
//                  initialUrl: 'http://www.netcapital.mn',
              javascriptMode: JavascriptMode.unrestricted,

              onWebViewCreated: (WebViewController webViewController) {
                controller = webViewController;
                controller.clearCache();
              },
              onPageFinished: (String url) async {
                setState(() {
                  _loading = false;
                });
                print('page loaded url: ' + Func.toStr(url));
              },
//                  javascriptChannels: <JavascriptChannel>[
//                    _toasterJavascriptChannel(context),
//                  ].toSet(),
            ),
          ),
        ),

//        Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
////            /// Header
////            SettingsHeader(title: widget.title),
//
//            /// Web view
//            Expanded(
//              child: RoundedContainer(
//                child: WebView(
//                  initialUrl: widget.url,
////                  initialUrl: 'http://www.netcapital.mn',
//                  javascriptMode: JavascriptMode.unrestricted,
//                  onWebViewCreated: (WebViewController webViewController) {
//                    controller = webViewController;
//                  },
//                  onPageFinished: (String url) async {
//                    print(Func.toStr(url));
//                  },
////                  javascriptChannels: <JavascriptChannel>[
////                    _toasterJavascriptChannel(context),
////                  ].toSet(),
//                ),
//              ),
//            )
//          ],
//        ),
      ),
    );
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
