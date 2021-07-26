import 'package:flutter/material.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/modules/intro/provider/offset_notifier.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            /// Background
//            Consumer<OffsetNotifier>(
//              builder: (context, notifier, child) {
//                return Transform.scale(
//                  scale: math.max(0, 1 - notifier.page),
//                  child: Opacity(
//                    opacity: math.max(0, math.max(0, 1 - notifier.page)),
//                    child: child,
//                  ),
//                );
//              },
//              child: Center(
//                child: Center(
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Container(
//                      width: 300,
//                      height: 300,
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        shape: BoxShape.circle,
//                      ),
//                      child: Container(),
//                    ),
//                  ),
//                ),
//              ),
//            ),

            /// Icon
            Consumer<OffsetNotifier>(
                builder: (context, notifier, child) {
                  return Opacity(
                    opacity: math.max(0, 1 - 2 * notifier.page),
                    child: child,
                  );
//                  return Transform.rotate(
//                    angle: math.max(0, (math.pi / 2) * 4 * notifier.page),
//                    child: Opacity(
//                      opacity: math.max(0, math.max(0, 1 - notifier.page)),
//                      child: child,
//                    ),
//                  );
                },
                child: Image.asset(AssetName.intro_page1, height: 240.0)),
          ],
        ),
      ],
    );
  }
}
