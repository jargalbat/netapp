import 'package:flutter/material.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/tab_bar.dart';
import 'package:netware/app/widgets/tab_bar.dart';

import 'bond_offering_screen.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  TabController _tabController;
  List<Tab> _tabList;

  double _paddingHorizontal = 20.0;
  Localization _loc;

  @override
  void initState() {
    super.initState();

    _tabList = [
      Tab(text: 'Хэрэглэгч 1'),
      Tab(text: 'Хэрэглэгч 2'),
      Tab(text: 'Хэрэглэгч 3'),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loc = globals.text;

    List<Widget> tabItemList = List<Widget>();

    tabItemList.add(_tabView1());

    tabItemList.add(_tabView2());

    tabItemList.add(_tabView3());

    return new WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return Future.value(false);
      },
      child: DefaultTabController(
        length: tabItemList.length,
        child: Scaffold(
          backgroundColor: AppColors.bgGrey,
          appBar: AppBarSimple(
            backgroundColor: AppColors.bgBlue,
            context: context,
            onPressed: _onBackPressed,
            iconColor: AppColors.iconWhite,
          ),
          body: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(
                    right: _paddingHorizontal,
                    left: _paddingHorizontal,
                  ),
                  color: AppColors.bgBlue,
                  child: Column(
                    children: <Widget>[
                      lbl(
                        'Судалгаа',
                        style: lblStyle.Headline4,
                        color: AppColors.lblWhite,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      lbl(
                        'Өөрийг тань хамгийн сайн илэрхийлж чадах нэг профайлыг сонгоно уу.  Бид танд хамгийн сайн тохирох бондыг санал болгоно.',
                        fontSize: 16.0,
                        maxLines: 5,
                        color: AppColors.lblWhite,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  )),

              /// Tab bar header
              tabBar(
                context: context,
                backgroundColor: AppColors.bgBlue,
                tabItems: _tabList,
                tabController: _tabController,
                padding: EdgeInsets.only(
                    top: 0.0, right: 20.0, bottom: 0.0, left: 20.0),
              ),

              ///Tab bar items

              Expanded(
                child: Container(
                  color: AppColors.bgGrey,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    color: AppColors.bgWhite,
                    child: TabBarView(
                      controller: _tabController,
                      children: tabItemList,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ),
//              Container(
//                  color: AppColors.bgGrey,
//                  child: TabBarView(
//                    controller: _tabController,
//                    children: tabItemList,
//                    physics: NeverScrollableScrollPhysics(),
//                  ),
              ),

              Container(
                color: AppColors.bgGrey,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  color: AppColors.bgWhite,
                  child: _btnChoose(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabView1() {
    return ListView(
      children: <Widget>[
        _tabItem(
          icon: Image.asset(
            AssetName.survey_key,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Эрсдэлд дургуй хөрөнгө оруулагч',
          body:
              'Зах зээлийн хэлбэлзлийг хүлээж авч чадахгүй, тогтвортой хөрөнгө оруулалт сонирхож байна.',
        ),
        _tabItem(
          icon: Image.asset(
            AssetName.survey_time,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Богино хугацаат хөрөнгө оруулалт',
          body: '1-6 сарын хугацаанд хөрөнгө оруулах сонирхолтой.',
        ),
        _tabItem(
          icon: Image.asset(
            AssetName.survey_hand,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Тогтмол өгөөж',
          body:
              'Банкны хадгаламжийг орлохуйц баталгаатай өгөөжийг эрэлхийлж байгаа.',
        ),
        _tabItem(
          icon: Image.asset(
            AssetName.survey_board,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Хөрөнгийн зах зээлийн талаар анхан шатны мэдлэгтэй.',
          body:
              'Хөрөнгийн зах зээл гэж мэднэ. Гэхдээ яаж ажилладагыг нь мэдэхгүй.',
        ),
      ],
    );
  }

  Widget _tabView2() {
    return ListView(
      children: <Widget>[
        _tabItem(
          icon: Image.asset(
            AssetName.survey_sound,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Эрсдэлд саармаг хөрөнгө оруулагч',
          body: 'Ямар ч эрсдэлтэй байсан өндөр өгөөжийг шаарддаг.',
        ),
        _tabItem(
          icon: Image.asset(
            AssetName.survey_time_2,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Дунд хугацаанд хөрөнгө оруулах сонирхолтой',
          body: '6-12 сарын хугацаанд хөрөнгө оруулах сонирхолтой.',
        ),
        _tabItem(
          icon: Image.asset(
            AssetName.survey_graph,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Инфляцийн төвшнөөс хамгаалагдсан өгөөж',
          body: 'Инфляциас хамгаалсан өгөөжийг сонирхож байгаа.',
        ),
        _tabItem(
          icon: Image.asset(
            AssetName.survey_board,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Хөрөнгийн зах зээлийн талаар зохих шатны мэдлэгтэй.',
          body: 'Хөрөнгийн зах зээл гэж юу болохыг мэднэ.',
        ),
      ],
    );
  }

  Widget _tabView3() {
    return ListView(
      children: <Widget>[
        _tabItem(
          icon: Image.asset(
            AssetName.survey_foot,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Эрсдэлд дуртай хөрөнгө оруулагч',
          body: 'Зах зээлийн хэлбэлзэлд төдийлэн санаа зовдоггүй.',
        ),
        _tabItem(
          icon: Image.asset(
            AssetName.survey_flag,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Урт хугацаат хөрөнгө оруулалт',
          body: '1 жилээс дээш хугацаанд хөрөнгө оруулах боломжтой.',
        ),
        _tabItem(
          icon: Image.asset(
            AssetName.survey_hand_2,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Өндөр өгөөж',
          body: 'Боломжит хамгийн өндөр өгөөжийг авахыг хүсдэг.',
        ),
        _tabItem(
          icon: Image.asset(
            AssetName.survey_board,
            height: 65.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'Хөрөнгийн зах зээлийн талаар сайн мэдлэгтэй.',
          body: 'Хөрөнгийн зах зээлийн талаар сайн мэдлэгтэй, түүнд оролцдог.',
        ),
      ],
    );
  }

  _tabItem({Widget icon, String title, String body}) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon,
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                lbl(
                  title,
                  fontSize: 16,
                  color: AppColors.lblDark,
                  maxLines: 5,
                  fontWeight: FontWeight.bold,
                ),
                lbl(
                  body,
                  fontSize: 12,
                  maxLines: 5,
                  color: AppColors.lblGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _btnChoose() {
    return CustomButton(
      text: Func.toStr('СОНГОХ').toUpperCase(),
      context: context,
      margin: EdgeInsets.only(
          top: 20.0,
          right: _paddingHorizontal + 10.0,
          bottom: 20.0,
          left: _paddingHorizontal + 10.0),
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: () {
        Future.delayed(const Duration(milliseconds: 700), () {
          Navigator.pop(context);
        });

        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            Navigator.of(context).push(
              new PageRouteBuilder(
                pageBuilder: (BuildContext context, _, __) {
                  return new BondOfferingScreen();
                },
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return new FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          });
        });

        showCustomDialog(
          barrierDismissible: false,
          context: context,
          img: Image.asset(
            AssetName.success_blue,
            height: 74.0,
            colorBlendMode: BlendMode.modulate,
          ),
          title: 'БОЛОВСРУУЛЖ БАЙНА...',
          body: 'Та түр хүлээнэ үү.',
          buttons: Container(),
          bodyHeight: 110.0,
        );
      },
    );
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
