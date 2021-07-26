import 'package:flutter/material.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import 'bond_card_offering.dart';

const SCALE_FRACTION = 0.7;
const FULL_SCALE = 1.0;
const PAGER_HEIGHT = 200.0;

class BondOfferingScreen extends StatefulWidget {
  @override
  _BondOfferingScreenState createState() => _BondOfferingScreenState();
}

class _BondOfferingScreenState extends State<BondOfferingScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Localization _loc;
  double _paddingHorizontal = 20.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loc = globals.text;

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarSimple(
            context: context,
            onPressed: _onBackPressed,
//            icon: Icon(Icons.close, color: AppColors.iconMirage),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(
                    right: _paddingHorizontal,
                    left: _paddingHorizontal,
                  ),
                  child: Column(
                    children: <Widget>[
                      lbl(
                        'Санал болгох',
                        style: lblStyle.Headline4,
                        color: AppColors.lblBlue,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(height: 10.0),
                      lbl(
                        'Та доорх бондуудаас сонголт хийх боломжтой.',
                        fontSize: 16.0,
                        color: AppColors.lblDark,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  )),

              SizedBox(height: 30.0),

              _bonds(),

              _bondDetail(),

              _bondDetail2(),

              Expanded(
                child: Container(),
              ),

              SizedBox(height: 30.0),

              /// Авах
              _btnBuy(),

              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  final _pageController = PageController(viewportFraction: 0.9);
  final _currentPageNotifier = ValueNotifier<int>(0);

  _bonds() {
    return Column(
      children: <Widget>[
        SizedBox(height: 0.0),
        Container(
          color: Colors.transparent,
          height: PAGER_HEIGHT,
          child: PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
            physics: BouncingScrollPhysics(),
//            itemCount: listOfCharacters.length,
//            itemBuilder: (context, index) {
//              final scale =
//              max(SCALE_FRACTION, (FULL_SCALE - (index - page).abs()) + viewPortFraction);
//              return circleOffer(
//                  listOfCharacters[index]['image'], scale);
//            },
            children: <Widget>[
              BondCardOffering(),
              BondCardOffering(),
              BondCardOffering(),
            ],
          ),
        ),
        SizedBox(height: 5.0),
        CirclePageIndicator(
          selectedDotColor: AppColors.imgActive,
          dotColor: Colors.grey,
          itemCount: 3,
          currentPageNotifier: _currentPageNotifier,
        ),
      ],
    );
  }

  _bondDetail() {
    return CustomCard(
      margin: EdgeInsets.only(
          top: 10.0,
          right: _paddingHorizontal,
          bottom: 10.0,
          left: _paddingHorizontal),
      child: Container(
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    lbl(
                      "₮15.0 сая",
                      color: Color(0XFF162B75),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      padding: EdgeInsets.only(left: _paddingHorizontal),
                    ),
                    lbl(
                      "Бондын үнэ",
                      color: Color(0XFF8D98AB),
                      fontSize: 12.0,
                      padding: EdgeInsets.only(left: _paddingHorizontal),
                    ),
                  ],
                ),

                /// Хөндлөн зураас
                Container(
                  width: 1.0,
                  height: 50.0,
                  color: Color(0XFF8D98AB),
                  margin: EdgeInsets.only(
                    top: 10.0,
                    right: 15.0,
                    bottom: 10.0,
                    left: 15.0,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    lbl(
                      "Хүү",
                      color: Color(0XFF8D98AB),
                      fontSize: 12.0,
                    ),
                    lbl(
                      "Хугацааны эцэст",
                      color: Color(0XFF8D98AB),
                      fontSize: 12.0,
                      maxLines: 2,
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      lbl(
                        "   17.5%",
                        color: AppColors.lblDark,
                        fontSize: 16.0,
//                      padding: EdgeInsets.only(left: _paddingHorizontal),
                      ),
                      lbl(
                        "   1,930,000₮",
                        color: Color(0XFF29B35A),
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
//                          padding: EdgeInsets.only(right: _paddingHorizontal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _bondDetail2() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, right: 40.0, bottom: 0.0, left: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              lbl(
                'Нэрлэсэн үнэ:',
                color: AppColors.lblDark.withOpacity(0.7),
                fontSize: 16.0,
              ),
              lbl(
                'Хүү:',
                color: AppColors.lblDark.withOpacity(0.7),
                alignment: Alignment.centerLeft,
                textAlign: TextAlign.start,
                fontSize: 16.0,
              ),
              lbl(
                'Хугацаа:',
                color: AppColors.lblDark.withOpacity(0.7),
                fontSize: 16.0,
              ),
              lbl(
                'Бусад нөхцөл:',
                color: AppColors.lblDark.withOpacity(0.7),
                fontSize: 16.0,
              ),
            ],
          ),
          Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              lbl(
                '1,000,000₮',
                color: AppColors.lblDark,
                fontSize: 16.0,
              ),
              lbl(
                '17.5%',
                color: AppColors.lblDark,
                fontSize: 16.0,
              ),
              lbl(
                '12 сар',
                color: AppColors.lblDark,
                fontSize: 16.0,
              ),
              lbl(
                'Энгийн',
                color: AppColors.lblDark,
                fontSize: 16.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _btnBuy() {
    return CustomButton(
      text: Func.toStr('АВАХ').toUpperCase(),
      context: context,
      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: () {
        showCustomDialog(
          context: context,
          img: Image.asset(
            AssetName.success_blue,
            height: 74.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'АЖИЛТТАЙ!',
          body: 'Дараагийн алхам руу шилжих бол дуусгах товчийг дарна уу.',
          btnText: Func.toStr('ДУУСГАХ').toUpperCase(),
          onPressedBtn: () {
//            SystemChannels.textInput
//                .invokeMethod('TextInput.hide'); // hide keyboard

            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
