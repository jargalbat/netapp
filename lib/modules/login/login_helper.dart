import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/app/bloc/app_bloc.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/widgets/dialogs.dart';

class LoginHelper {
  static const int CODE_PASSWORD_BLOCKED = 91001006; // Нууц үг түгжигдсэн байна
  static const int CODE_PASSWORD_EXPIRED = 91001007; // Нууц үгийн хүчинтэй хугацаа дууссан. Солино уу.
  static const int CODE_CHANGE_PASSWORD = 91001008; // Нууц үгээ солино уу
  static const int CODE_PERMANENT_DEVICE =
      91001065; // Бүртгэлгүй төхөөрөмжөөс хандсан байна. Таны утасны дугаар луу илгээсэн ТАН кодоор баталгаажуулна уу.

  /// Logout
  static showLogoutDialog(BuildContext context) {
    showDefaultDialog(
      context: context,
      title: globals.text.logout(),
      body: globals.text.sureLogout(),
      onPressedBtnPositive: () {
        BlocProvider.of<AppBloc>(context).add(LogoutEvent());
        Navigator.popUntil(context, (route) => route.isFirst);
      },
    );
  }
}
