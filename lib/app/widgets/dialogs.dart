import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';

/// Default dialog
class MainDialog extends StatefulWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;

  MainDialog({@required this.child, this.margin, this.padding});

  @override
  State<StatefulWidget> createState() => MainDialogState();
}

class MainDialogState extends State<MainDialog> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      padding: mediaQuery.padding,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: widget.margin,
            padding: widget.padding,
            decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
            child: widget.child ?? Container(),
          ),
        ),
      ),
    );
  }
}

/// RESPONSIVE DIALOG
class ResponsiveDialog extends StatelessWidget {
  final Widget child;

  ResponsiveDialog({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AlertDialog(
      content: AnimatedContainer(
//        margin: EdgeInsets.all(20.0),
//        padding: EdgeInsets.all(20.0),
//      height: 450,
        width: mediaQuery.size.width,
        padding: mediaQuery.padding,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }
}

class ResponsiveDialog2 extends StatelessWidget {
  final Widget child;

  ResponsiveDialog2({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
//        margin: EdgeInsets.all(20.0),
//        padding: EdgeInsets.all(20.0),
//      height: 450,
//      width: mediaQuery.size.width,
          padding: mediaQuery.padding,
          duration: const Duration(milliseconds: 300),
          child: child,
        ),
      ),
    );
  }
}

/// Scale animated dialog
class ScaleDialog extends StatefulWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;

  ScaleDialog({@required this.child, this.margin, this.padding});

  @override
  State<StatefulWidget> createState() => ScaleDialogState();
}

class ScaleDialogState extends State<ScaleDialog> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            margin: widget.margin,
            padding: widget.padding,
            decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
            child: widget.child ?? Container(),
          ),
        ),
      ),
    );
  }
}

/// Scale animated dialog
class FadeDialog extends StatefulWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;

  FadeDialog({@required this.child, this.margin, this.padding});

  @override
  State<StatefulWidget> createState() => FadeDialogState();
}

class FadeDialogState extends State<FadeDialog> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> fadeInAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: fadeInAnimation,
          child: Container(
            margin: widget.margin,
            padding: widget.padding,
            decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
            child: widget.child ?? Container(),
          ),
        ),
      ),
    );
  }
}

class DialogInsetDefeat extends StatelessWidget {
  final BuildContext context;
  final Widget child;
  final deInset = EdgeInsets.symmetric(horizontal: -40, vertical: -24);
  final EdgeInsets edgeInsets;

  DialogInsetDefeat({@required this.context, @required this.child, this.edgeInsets});

  @override
  Widget build(BuildContext context) {
    var netEdgeInsets = deInset + (edgeInsets ?? EdgeInsets.zero);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: netEdgeInsets),
      child: child,
    );
  }
}

/// Displays a Material dialog using the above DialogInsetDefeat class.
/// Meant to be a drop-in replacement for showDialog().
///
/// See also:
///
///  * [Dialog], on which [SimpleDialog] and [AlertDialog] are based.
///  * [showDialog], which allows for customization of the dialog popup.
///  * <https://material.io/design/components/dialogs.html>
Future<T> showDialogWithInsets<T>({
  @required BuildContext context,
  bool barrierDismissible = true,
  @required WidgetBuilder builder,
  EdgeInsets edgeInsets,
}) {
  return showDialog(
    context: context,
    builder: (_) => DialogInsetDefeat(
      context: context,
      edgeInsets: edgeInsets,
      child: Builder(builder: builder),
    ),
    barrierDismissible: barrierDismissible = true,
  );
}

/// Main dialog
void showCustomDialog({
  @required BuildContext context,
  Widget child,
  EdgeInsets paddingChild,
  String title,
  String body,
  String btnText,
  Function onPressedBtn,
  Widget img,
  Widget buttons,
  bool barrierDismissible = false,
  double bodyHeight = 160.0,
}) {
  FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard
  Localization _loc = globals.text;

  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      // return object of type Dialog
      return child != null
          ? AlertDialog(
              content: child,
              contentPadding: paddingChild ?? EdgeInsets.all(0.0),
            )
          : AlertDialog(
              /// TITLE
              title: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    img ??
                        Image.asset(
                          AssetName.success,
                          height: 74.0,
                          colorBlendMode: BlendMode.modulate,
                        ),
                    SizedBox(height: 40.0),
                    new Text(
                      title ?? _loc.success(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.lblDark, fontWeight: FontWeight.w500, fontSize: 16.0),
                    ),
                  ],
                ),
              ),

              /// BODY
              content: Container(
                height: bodyHeight,
                child: Column(
                  children: <Widget>[
                    /// Хөндлөн зураас
                    if (body != null)
                      Container(
                        height: 0.5,
                        color: Color(0XFFE4E7EC),
                        margin: EdgeInsets.only(
                          top: 10.0,
                          right: 30.0,
                          bottom: 10.0,
                          left: 30.0,
                        ),
                      ),

                    SizedBox(height: 20.0),

                    if (body != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: new Text(
                          body,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0XFF8D98AB)),
                        ),
                      ),

                    if (body != null)
                      SizedBox(
                        height: 20.0,
                      ),

                    buttons ??
                        CustomButton(
                          text: btnText ?? 'OK',
                          context: context,
                          margin: EdgeInsets.symmetric(horizontal: 20.0 + 10.0),
                          color: AppColors.bgBlue,
                          disabledColor: AppColors.btnBlue,
                          textColor: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            onPressedBtn();
                          },
                        ),
                  ],
                ),
              ),
            );
    },
  );
}

/// Dialog with text
void showDefaultDialog({
  @required BuildContext context,
  String title,
  String body,
  String btnNegativeText,
  String btnPositiveText,
  Function onPressedBtnNegative,
  Function onPressedBtnPositive,
}) {
  FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard

  showDialog(
//    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Func.isNotEmpty(title)
            ? Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.lblDark, fontWeight: FontWeight.w500, fontSize: 16.0),
              )
            : null,
        content: new Text(
          body ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.lblDark),
        ),
        contentPadding: EdgeInsets.fromLTRB(AppHelper.margin, Func.isNotEmpty(title) ? AppHelper.margin : 30.0, AppHelper.margin, 0.0),
        actions: <Widget>[
          /// Үгүй
          new FlatButton(
            child: new Text(btnNegativeText ?? Func.toStr(globals.text.no()).toUpperCase()),
            onPressed: () {
              if (onPressedBtnNegative != null) {
                onPressedBtnPositive();
              } else {
                Navigator.pop(context);
              }
            },
          ),

          /// Тийм
          new FlatButton(
            child: new Text(Func.toStr(globals.text.yes()).toUpperCase()),
            onPressed: () {
              if (onPressedBtnPositive != null) {
                onPressedBtnPositive();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}
