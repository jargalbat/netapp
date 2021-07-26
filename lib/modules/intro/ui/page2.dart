import 'package:flutter/material.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/modules/intro/provider/offset_notifier.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              /// Background
//              Consumer<OffsetNotifier>(
//                builder: (context, notifier, child) {
//                  double multiplier;
//
//                  if (notifier.page <= 1.0) {
//                    multiplier = math.max(0, 4 * notifier.page - 3);
//                  } else {
//                    multiplier = math.max(0, 1 - (4 * notifier.page - 4));
//                  }
//
//                  return Transform.scale(
//                    scale: multiplier,
//                    child: child,
//                  );
//                },
//                child: Container(
//                  width: 340,
//                  height: 340,
//                  decoration: BoxDecoration(
//                    color: AppColors.bgWhite,
//                    shape: BoxShape.circle,
//                  ),
//                  child: Container(),
//                ),
//              ),

              /// Icon
              Consumer<OffsetNotifier>(
                builder: (context, notifier, child) {
                  double multiplier;

                  if (notifier.page <= 1.0) {
                    multiplier = math.max(0, 4 * notifier.page - 3);
                  } else {
                    multiplier = math.max(0, 1 - (4 * notifier.page - 4));
                  }

                  return Transform.translate(
                    offset: Offset(0, -50 * (1 - multiplier)),
//                    offset: Offset(-50 * (1 - multiplier), 0),
//                    offset: Offset(50 * (1 + multiplier), 0),
                    child: Opacity(
                      opacity: multiplier,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(AssetName.intro_page2, height: 240.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
