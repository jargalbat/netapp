import 'package:flutter/material.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/routes/term_cond/ui/term_cond_route.dart';
import 'package:netware/app/shared_pref_key.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/modules/login/login_route.dart';
import '../../app/assets/image_asset.dart';
import '../../app/themes/app_colors.dart';
import '../../app/widgets/buttons/buttons.dart';
import 'plugin/controller/story_controller.dart';
import 'plugin/widgets/story_view.dart';
import 'transition_image_viewer.dart';

class StoryRoute extends StatefulWidget {
  @override
  _StoryRouteState createState() => _StoryRouteState();
}

class _StoryRouteState extends State<StoryRoute> {
  final storyController = StoryController();
  final Color _bgColor = Colors.black12;

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarEmpty(context: context, brightness: Brightness.dark, backgroundColor: _bgColor),
      backgroundColor: _bgColor,
      body: StoryView(
        storyItems: [
          /// iPhone image
          StoryItem.customItem(
            controller: storyController,
            index: 0,
            child: TransitionImageViewer(
              assetName: AssetName.story_iphone,
              title: globals.text.story1Title(),
              text: globals.text.story1Text(),
            ),
          ),

          /// Lion image
          StoryItem.customItem(
            controller: storyController,
            index: 1,
            child: TransitionImageViewer(
              assetName: AssetName.story_lion,
              title: globals.text.story2Title(),
              text: globals.text.story2Text(),
            ),
          ),

          /// Road image
          StoryItem.customItem(
            controller: storyController,
            index: 2,
            child: TransitionImageViewer(
              assetName: AssetName.story_road,
              title: globals.text.story3Title(),
              text: globals.text.story3Text(),
              btn: _btnNavigateToTermCond(),
            ),
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story ${s.index}");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
        backgroundColor: _bgColor, // custom code
//        inline: true,
//        onVerticalSwipeComplete:,
      ),
    );
  }

  Widget _btnNavigateToTermCond() {
    return CustomButton(
//      text: globals.text.termCond(),
      text: globals.text.login(),
      isUppercase: false,
      context: context,
      margin: EdgeInsets.zero,
      color: AppColors.btnGreyLight,
      disabledColor: AppColors.btnGreyDisabled,
      textColor: AppColors.lblBlue,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: () {
//        Navigator.pushReplacement(this.context, FadeRouteBuilder(route: TermCondRoute()));
        globals.sharedPref.setBool(SharedPrefKey.PrivacyPolicy, true); //todo delete
        Navigator.pushReplacement(this.context, FadeRouteBuilder(route: LoginRoute()));
      },
    );
  }
}
