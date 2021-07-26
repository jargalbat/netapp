import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/modules/settings/ui/relative/relative_widget.dart';
import 'package:http/http.dart' as http;

/// Холбоотой хүмүүс
class RelativeRoute extends StatefulWidget {
  @override
  _RelativeRouteState createState() => _RelativeRouteState();
}

class _RelativeRouteState extends State<RelativeRoute> {
  /// UI
  final _relativeKey = GlobalKey<ScaffoldState>();
  var _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
      child: BlurLoadingContainer(
        loading: false,
        child: Scaffold(
          key: _relativeKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarSimple(
            context: context,
            onPressed: _onBackPressed,
            brightness: Brightness.light,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode()); // Hide keyboard
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Хувийн мэдээлэл
                  lbl(globals.text.relative(), style: lblStyle.Headline4, margin: EdgeInsets.only(left: AppHelper.margin)),

                  Container(
                    margin: EdgeInsets.fromLTRB(AppHelper.margin, 20.0, AppHelper.margin, AppHelper.margin),
                    child: RelativeWidget(
                      scaffoldKey: _relativeKey,
                    ),
                  ),

                  SizedBox(height: AppHelper.marginBottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
