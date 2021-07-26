import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/list_item.dart';
import 'package:netware/app/widgets/textbox/text_field.dart';

class UserGuideRoute extends StatefulWidget {
  @override
  _UserGuideRouteState createState() => _UserGuideRouteState();
}

class _UserGuideRouteState extends State<UserGuideRoute> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Localization _loc;
  double _paddingHorizontal = 20.0;

  /// First name
  TextEditingController _searchController = TextEditingController();
  bool _isSearchValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loc = globals.text;

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarSimple(
            context: context,
            onPressed: _onBackPressed,
//            icon: Icon(Icons.close, color: AppColors.iconMirage),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    right: _paddingHorizontal,
                    left: _paddingHorizontal,
                  ),
                  child: lbl(
                    'Гарын авлага',
                    style: lblStyle.Headline4,
                    color: AppColors.lblDark,
                    maxLines: 3,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                /// Хайх
                _txtSearch(),

                SizedBox(height: 20.0),

                /// Гарын авлагууд
                listItemUserGuide(
                  text: '  Test',
                  leadingIcon: Icon(Icons.more_horiz),
//                  leadingIcon: Image.asset(
//                    Img.link,
//                    width: 20.0,
//                    height: 20.0,
//                  ),
                ),
                Divider(height: 2.0, color: AppColors.bgGrey),
                listItemUserGuide(
                  text: '  Test',
                  leadingIcon: Icon(Icons.more_horiz),
//                  leadingIcon: Image.asset(
//                    Img.link,
//                    width: 20.0,
//                    height: 20.0,
//                  ),
                ),
                Divider(height: 2.0, color: AppColors.bgGrey),
                listItemUserGuide(
                  text: '  Test',
                  leadingIcon: Icon(
                    Icons.more_horiz,
                    size: 20.0,
                  ),
//                  leadingIcon: Image.asset(
//                    Img.link,
//                    width: 20.0,
//                    height: 20.0,
//                  ),
                ),
                Divider(height: 2.0, color: AppColors.bgGrey),
                listItemUserGuide(
                  text: '  Test',
                  leadingIcon: Icon(Icons.more_horiz),
//                  leadingIcon: Image.asset(
//                    Img.link,
//                    width: 20.0,
//                    height: 20.0,
//                  ),
                ),
                Divider(height: 2.0, color: AppColors.bgGrey),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _txtSearch() {
    return txt(
      context: context,
      margin: EdgeInsets.only(
          top: 20.0, right: _paddingHorizontal, left: _paddingHorizontal),
      controller: _searchController,
      maxLength: 30,
      textInputType: TextInputType.text,
      textColor: AppColors.lblDark,
      labelFontWeight: FontWeight.normal,
      bgColor: AppColors.txtBgGrey,
      borderRadius: 10.0,
      hintText: globals.text.search(),
      prefixIcon: Icon(Icons.search),
      padding: EdgeInsets.all(0.0),
    );
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
