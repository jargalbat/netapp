/// Created by Jargalbat, 2020

import 'package:flutter/material.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/themes/app_colors.dart';
import '../../app/widgets/labels.dart';

class TransitionImageViewer extends StatefulWidget {
  final String assetName;
  final String title;
  final String text;
  final Widget btn;
  final Color backgroundColor;

  TransitionImageViewer({
    @required this.assetName,
    @required this.title,
    @required this.text,
    this.backgroundColor = Colors.black12,
    this.btn,
  });

  @override
  _TransitionImageViewerState createState() => _TransitionImageViewerState();
}

class _TransitionImageViewerState extends State<TransitionImageViewer> with TickerProviderStateMixin {
  final double _startAlignment = -50.0; // Эхлэх цэг
  final double _endAlignment = -200.0; // Дуусах цэг
  double _currentAlignment; // Одоогийн байрлал
  bool _backwardForward = false; // Хөдлөж буй чиглэл

  @override
  void initState() {
    _currentAlignment = _startAlignment;

    Future.delayed(const Duration(milliseconds: 0), () {
      _moveImage();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        /// Background
        Container(color: widget.backgroundColor),

        /// Image
        AnimatedPositioned(
          duration: Duration(seconds: 15),
          left: _currentAlignment,
          child: Image.asset(widget.assetName, height: MediaQuery.of(context).size.height, fit: BoxFit.fitHeight),
          onEnd: () {
            _moveImage();
          },
        ),

        /// Text
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  /// Title
                  lbl(
                    widget.title,
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lblLightGrey,
                    alignment: Alignment.centerLeft,
                  ),

                  SizedBox(height: 10.0),

                  /// Body
                  lbl(widget.text,
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      style: lblStyle.Medium,
                      color: AppColors.lblLightGrey,
                      alignment: Alignment.centerLeft,
                      maxLines: 3),

                  SizedBox(height: 70.0),

                  /// Button
                  Container(
                    height: 50.0,
                    child: widget.btn ?? Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _moveImage() {
    setState(() {
      _currentAlignment = _backwardForward ? _startAlignment : _endAlignment;
      _backwardForward = !_backwardForward;
    });
  }
}

//class AnimatedView extends StatefulWidget {
//  @override
//  _AnimatedViewState createState() => _AnimatedViewState();
//}
//
//class _AnimatedViewState extends State<AnimatedView>
//    with TickerProviderStateMixin {
//  Animation<Offset> animation;
//  AnimationController animationController;
//
//  double _ironManAlignment = 50;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//
////    animationController =
////        AnimationController(vsync: this, duration: Duration(seconds: 5));
////
////    animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1.2)).animate(animationController);
//
////    animationController.forward();
//    super.initState();
//  }
//
//  void _flyIronMan() {
//    setState(() {
//      _ironManAlignment = 320;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      color: Colors.white,
//      child: Stack(
//        children: <Widget>[
//          AnimatedPositioned(
//            duration: Duration(seconds: 3),
//            bottom: _ironManAlignment,
//            left: 90,
//            child: Container(
////              height: 250,
////              width: 150,
//              child: Image.asset(ImageAsset.test),
//            ),
//          ),
//
//          Image.asset(ImageAsset.test),
//
//          MaterialButton(
//            child: Text("text"),
//            onPressed: () {
//              _flyIronMan();
//            },
//          ),
//        ],
//      ),
//    );
//  }
//
//  @override
//  void dispose() {
//    animationController.dispose();
//    super.dispose();
//  }
//}

//class AnimatedView extends StatefulWidget {
//  AnimatedView({Key key}) : super(key: key);
//
//  @override
//  _AnimatedViewState createState() => _AnimatedViewState();
//}
//
//class _AnimatedViewState extends State<AnimatedView>
//    with SingleTickerProviderStateMixin {
//  AnimationController _controller;
//  Animation<Offset> _offsetAnimation;
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = AnimationController(
//      duration: const Duration(seconds: 2),
//      vsync: this,
//    )..repeat(reverse: false);
//
//    _offsetAnimation = Tween<Offset>(
//      begin: Offset.zero,
//      end: const Offset(1.5, 0.0),
//    ).animate(CurvedAnimation(
//      parent: _controller,
//      curve: Curves.elasticIn,
//    ));
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _controller.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SlideTransition(
//      position: _offsetAnimation,
//      child: Padding(
//        padding: EdgeInsets.all(8.0),
//        child: Image.asset(ImageAsset.test),
//      ),
//    );
//  }
//}
