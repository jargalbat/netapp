import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/api/models/settings/update_profile_request.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/combobox/combo_bloc.dart';
import 'package:netware/app/widgets/combobox/combo_helper.dart';
import 'package:netware/app/widgets/combobox/combobox.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';
import 'package:netware/modules/settings/bloc/profile_bloc.dart';
import 'package:netware/modules/settings/bloc/profile_helper.dart';
import 'package:netware/modules/settings/ui/relative/relative_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ComingSoonRoute extends StatefulWidget {
  @override
  _ComingSoonRouteState createState() => _ComingSoonRouteState();
}

class _ComingSoonRouteState extends State<ComingSoonRoute> {
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
      child: Scaffold(
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
          child: Center(
            child: lbl(
              'Тун удахгүй...',
              margin: EdgeInsets.only(left: AppHelper.margin),
              style: lblStyle.Headline4,
              fontSize: 24.0,
              color: AppColors.blue,
              alignment: Alignment.center,
              textAlign: TextAlign.center,
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
