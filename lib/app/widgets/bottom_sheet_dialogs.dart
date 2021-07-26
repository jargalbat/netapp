import 'package:flutter/material.dart';
import 'package:netware/app/themes/app_colors.dart';

/// Дээд талаараа дугуйрсан ирмэгтэй bottom sheet dialog харуулах
class DialogHelper {
  static void showBottomSheetDialog({
    @required BuildContext context,
    @required double height,
    @required Widget child,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: height ?? MediaQuery.of(context).size / 2,
          decoration: new BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: new BorderRadius.only(topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0)),
          ),
          child: child,
        );
      },
    );
  }
}
