import 'package:flutter/material.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/modules/intro/provider/offset_notifier.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class Page4 extends StatelessWidget {
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
//                  return Transform.scale(
//                    scale: math.max(0, 1 - (1 - (4 * notifier.page - 7))),
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

                  if (notifier.page <= 3.0) {
                    multiplier = math.max(0, 4 * notifier.page - 11); //2.1 (-2.6), 2.9 (0.6)
                  } else {
                    multiplier = math.max(0, 1 - (4 * notifier.page - 12)); //3.1 (0.6), 3.9 (-2.6)
                  }

                  return Opacity(
                    opacity: multiplier,
                    child: child,
                  );
                },
                child: Image.asset(AssetName.intro_page4, height: 240.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
