//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:netware/app/assets/image_asset.dart';
//import 'package:netware/app/globals.dart';
//import 'package:netware/app/localization/localization.dart';
//import 'package:netware/app/themes/app_colors.dart';
//import 'package:netware/app/utils/func.dart';
//import 'package:netware/app/widgets/app_bar.dart';
//import 'package:netware/app/widgets/buttons/buttons.dart';
//import 'package:netware/app/widgets/dialogs.dart';
//import 'package:netware/app/widgets/labels.dart';
//
//class FeedbackRoute extends StatefulWidget {
//  @override
//  _FeedbackRouteState createState() => _FeedbackRouteState();
//}
//
//class _FeedbackRouteState extends State<FeedbackRoute> {
//  final _scaffoldKey = GlobalKey<ScaffoldState>();
//  Localization _loc;
//  double _paddingHorizontal = 20.0;
//
//  /// Feedback
//  final TextEditingController _feedbackController = TextEditingController();
//  FocusNode _passwordNewFocusNode;
//  bool _isFeedbackValid = false;
//
//  int selectedEmojiIndex = -1;
//
//  bool _chkBugValue = false;
//  bool _chkFeedbackValue = false;
//  bool _chkOthersValue = false;
//
//  @override
//  void initState() {
//    super.initState();
//
//    _feedbackController.addListener(() {
//      if (_feedbackController.text.length > 0) {
//        setState(() {
//          _isFeedbackValid = true;
//        });
//      } else {
//        setState(() {
//          _isFeedbackValid = false;
//        });
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    _loc = globals.text;
//
//    return WillPopScope(
//      onWillPop: () async {
//        _onBackPressed();
//        return Future.value(false);
//      },
//      child: SafeArea(
//        child: Scaffold(
//          key: _scaffoldKey,
//          backgroundColor: AppColors.bgGrey,
//          appBar: appBarSimple(
//            context: context,
//            onPressed: _onBackPressed,
////            icon: Icon(Icons.close, color: AppColors.iconMirage),
//          ),
//          body: SingleChildScrollView(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(
//                    right: _paddingHorizontal,
//                    left: _paddingHorizontal,
//                  ),
//                  child: lbl(
//                    'Санал хүсэлт',
//                    style: lblStyle.Headline4,
//                    color: AppColors.lblDark,
//                    fontWeight: FontWeight.normal,
//                  ),
//                ),
//
//                lbl(
//                  'Та системтэй холбоотой санал хүсэлтээ доор үлдээнэ үү.',
//                  fontSize: 16.0,
//                  margin: EdgeInsets.only(
//                    top: 10.0,
//                    right: _paddingHorizontal,
//                    bottom: 0.0,
//                    left: _paddingHorizontal,
//                  ),
//                  maxLines: 3,
//                  color: AppColors.lblDark,
//                  fontWeight: FontWeight.normal,
//                ),
//
//                _iconButtons(),
//
//                /// Санал хүсэлт
//                _txtFeedback(),
//
//                /// Checkboxes
//                _checkBoxes(),
//
//                SizedBox(height: 30.0),
//
////                Expanded(
////                  flex: 1,
////                  child: Container(),
////                ),
//
//                /// Хадгалах
//                _btnSend(),
//
//                SizedBox(height: 20.0),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  _iconButtons() {
//    return Container(
//      padding: EdgeInsets.only(
//        top: 20.0,
//        right: 20.0,
//        bottom: 20.0,
//        left: 20.0,
//      ),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Container(),
//          Column(
//            children: <Widget>[
//              InkWell(
//                child: Image.asset(
//                  ImageAsset.emoji_smile,
//                  width: 35.0,
//                  height: 35.0,
//                  color: selectedEmojiIndex == 0
//                      ? AppColors.iconBlue
//                      : AppColors.regentGray,
//                ),
//                onTap: () {
//                  setState(() {
//                    selectedEmojiIndex = 0;
//                  });
//                },
//              ),
//              lbl(
//                'Сайн',
//                fontSize: 16.0,
//                color: AppColors.lblDark,
//              ),
//            ],
//          ),
//          Column(
//            children: <Widget>[
//              InkWell(
//                child: Image.asset(
//                  ImageAsset.emoji_meh,
//                  width: 35.0,
//                  height: 35.0,
//                  color: selectedEmojiIndex == 1
//                      ? AppColors.iconBlue
//                      : AppColors.regentGray,
//                ),
//                onTap: () {
//                  setState(() {
//                    selectedEmojiIndex = 1;
//                  });
//                },
//              ),
//              lbl(
//                'Дунд',
//                fontSize: 16.0,
//                color: AppColors.lblDark,
//              ),
//            ],
//          ),
//          Column(
//            children: <Widget>[
//              InkWell(
//                child: Image.asset(
//                  ImageAsset.emoji_frown,
//                  width: 35.0,
//                  height: 35.0,
//                  color: selectedEmojiIndex == 2
//                      ? AppColors.iconBlue
//                      : AppColors.regentGray,
//                ),
//                onTap: () {
//                  setState(() {
//                    selectedEmojiIndex = 2;
//                  });
//                },
//              ),
//              lbl(
//                'Муу',
//                fontSize: 16.0,
//                color: AppColors.lblDark,
//              ),
//            ],
//          ),
//          Container(),
//        ],
//      ),
//    );
//  }
//
//  _txtFeedback() {
//    return Stack(
//      children: <Widget>[
//        Container(
//          height: 300.0,
//          margin: EdgeInsets.only(
//            top: 0.0,
//            right: _paddingHorizontal,
//            left: _paddingHorizontal,
//            bottom: 0.0,
//          ),
//          padding: EdgeInsets.only(left: 15.0),
////            height: 50.0,
//          decoration: new BoxDecoration(
//            color: AppColors.txtBgGrey,
//            borderRadius: BorderRadius.all(
//              Radius.circular(8.0),
//            ),
//          ),
//          child: TextField(
//            controller: _feedbackController,
//            expands: true,
//            keyboardType: TextInputType.multiline,
//            maxLines: null,
////              minLines: 6,
//            decoration: InputDecoration(
////                    contentPadding: const EdgeInsets.only(top:0.0,right: 5.0, bottom: 0.0, left: 0.0),
//              border: InputBorder.none,
//              counterText: "",
//              hintText: 'Энд санал сэтгэгдлээ бичиж үлдээнэ үү...',
//            ),
//            style: TextStyle(fontSize: 16.0, color: AppColors.lblDark),
//          ),
//        ),
//      ],
//    );
//  }
//
//  _checkBoxes() {
//    return Container(
//      padding: EdgeInsets.only(
//        top: 0.0,
//        right: 30.0,
//        bottom: 20.0,
//        left: 20.0,
//      ),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          _chkBug(),
//          _chkFeedback(),
//          _chkOthers(),
//        ],
//      ),
//    );
//  }
//
//  Widget _chkBug() {
//    return Theme(
//      data: Theme.of(context).copyWith(
//        unselectedWidgetColor: AppColors.chkUnselectedGrey,
//        splashColor: Colors.transparent,
//        highlightColor: Colors.transparent,
//      ),
//      child: Container(
//        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Checkbox(
//              value: _chkBugValue,
//              activeColor: AppColors.jungleGreen,
//              onChanged: (bool newValue) {
//                setState(() {
//                  _chkBugValue = newValue;
//                });
//              },
//            ),
//            InkWell(
//              child: lbl(
//                'Алдаа',
//                fontSize: 16.0,
//                color: AppColors.lblGrey,
//              ),
//              onTap: () {
//                setState(() {
//                  _chkBugValue = !_chkBugValue;
//                });
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _chkFeedback() {
//    return Theme(
//      data: Theme.of(context).copyWith(
//        unselectedWidgetColor: AppColors.chkUnselectedGrey,
//        splashColor: Colors.transparent,
//        highlightColor: Colors.transparent,
//      ),
//      child: Container(
//        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Checkbox(
//              value: _chkFeedbackValue,
//              activeColor: AppColors.jungleGreen,
//              onChanged: (bool newValue) {
//                setState(() {
//                  _chkFeedbackValue = newValue;
//                });
//              },
//            ),
//            InkWell(
//              child: lbl(
//                'Санал',
//                fontSize: 16.0,
//                color: AppColors.lblGrey,
//              ),
//              onTap: () {
//                setState(() {
//                  _chkFeedbackValue = !_chkFeedbackValue;
//                });
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _chkOthers() {
//    return Theme(
//      data: Theme.of(context).copyWith(
//        unselectedWidgetColor: AppColors.chkUnselectedGrey,
//        splashColor: Colors.transparent,
//        highlightColor: Colors.transparent,
//      ),
//      child: Container(
//        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Checkbox(
//              value: _chkOthersValue,
//              activeColor: AppColors.jungleGreen,
//              onChanged: (bool newValue) {
//                setState(() {
//                  _chkOthersValue = newValue;
//                });
//              },
//            ),
//            InkWell(
//              child: lbl(
//                'Бусад',
//                fontSize: 16.0,
//                color: AppColors.lblGrey,
//              ),
//              onTap: () {
//                setState(() {
//                  _chkOthersValue = !_chkOthersValue;
//                });
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
////  bool _chkBugValue = false;
////  bool _chkFeedbackValue = false;
////  bool _chkOthersValue = false;
////
//  _btnSend() {
//    return btn(
//      text: Func.toStr('ИЛГЭЭХ').toUpperCase(),
//      context: context,
//      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
//      color: AppColors.bgBlue,
//      disabledColor: AppColors.btnBlue,
//      textColor: Colors.white,
//      fontSize: 16.0,
//      fontWeight: FontWeight.w500,
//      onPressed: () {
//        FocusScope.of(context).requestFocus(new FocusNode());
//
//        _feedbackController.clear();
//
//        dlg(
//          context: context,
//          img: Image.asset(
//            ImageAsset.success_blue,
//            height: 74.0,
//            colorBlendMode: BlendMode.modulate,
//          ),
//          title: 'АЖИЛТТАЙ ИЛГЭЭГДЛЭЭ!',
//          body: 'Дараагийн алхам руу шилжих бол дуусгах товчийг дарна уу.',
//          btnText: Func.toStr('ДУУСГАХ').toUpperCase(),
//          onPressedBtn: () {
//            SystemChannels.textInput
//                .invokeMethod('TextInput.hide'); // hide keyboard
//
//            Navigator.pop(context);
//            Navigator.pop(context);
//          },
//        );
//      },
//    );
//  }
//
//  _onBackPressed() {
//    Navigator.pop(context);
//  }
//}
