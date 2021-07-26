//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:netware/app/bloc/app_bloc.dart';
//import 'package:netware/app/globals.dart';
//import 'package:netware/app/themes/app_colors.dart';
//import 'package:netware/app/widgets/buttons/buttons.dart';
//
//Widget btnLang({@required BuildContext context, Color color, EdgeInsets padding}) {
//  return Container(
//    padding: padding ?? EdgeInsets.all(0.0),
//    alignment: Alignment.topRight,
//    child: TextButton(
//      text: globals.locale.languageCode == "mn" ? 'EN' : 'MN',
//      onPressed: () {
////        BlocProvider.of<AppBloc>(context)..add(ChangeLang(locale: newLocale(globals.langCode)));
//
////        const String MN = "mn";
////        const String EN = "en";
////globals.langCode == "mn"
//
//        if (globals.locale.languageCode == "mn") {
//          BlocProvider.of<AppBloc>(context)..add(ChangeLangEN(locale: Locale("en")));
//        } else {
//          BlocProvider.of<AppBloc>(context)..add(ChangeLangMN(locale: Locale("mn")));
//        }
//      },
//      padding: EdgeInsets.only(top: 20.0, right: 20.0, bottom: 15.0, left: 20.0),
//      textColor: color ?? AppColors.lblDark,
//      fontWeight: FontWeight.w500,
//      fontSize: 16.0,
//      enabledRippleEffect: false,
//    ),
//  );
//}
