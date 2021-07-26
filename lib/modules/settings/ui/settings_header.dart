import 'package:flutter/material.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/widgets/labels.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    Key key,
    this.title,
    this.margin = const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 20.0),
  }) : super(key: key);

  final String title;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Тохиргоо
          lbl(title, style: lblStyle.Headline4, color: AppColors.lblDark),

//          /// Profile pic
//          Image.asset(AssetName.profile_pic, width: 37.0, colorBlendMode: BlendMode.modulate),
        ],
      ),
    );
  }
}
