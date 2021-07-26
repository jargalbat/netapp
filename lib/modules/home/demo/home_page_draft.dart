//_packetDetail() {
//  return card(
//    margin: EdgeInsets.only(top: 10.0, right: _cardMargin, bottom: 10.0, left: _cardMargin),
//    child: Container(
//      child: Stack(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  lbl(
//                    "Нийт бонд",
//                    color: Color(0XFF8D98AB),
//                    fontSize: 12.0,
//                    padding: EdgeInsets.only(left: _cardMargin),
//                  ),
//                  lbl(
//                    "₮35.0 сая",
//                    color: Color(0XFF162B75),
//                    fontSize: 20.0,
//                    fontWeight: FontWeight.w500,
//                    padding: EdgeInsets.only(left: _cardMargin),
//                  ),
//                ],
//              ),
//
//              /// Хөндлөн зураас
//              Container(
//                width: 1.0,
//                height: 50.0,
//                color: Color(0XFF8D98AB),
//                margin: EdgeInsets.only(
//                  top: 10.0,
//                  right: 30.0,
//                  bottom: 10.0,
//                  left: 30.0,
//                ),
//              ),
//
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  lbl(
//                    "Багцын хүү / Өгөөж",
//                    color: Color(0XFF8D98AB),
//                    fontSize: 12.0,
////                      padding: EdgeInsets.only(left: _paddingHorizontal),
//                  ),
//                  Row(
//                    children: <Widget>[
//                      lbl(
//                        "15.7%",
//                        color: Color(0XFF162B75),
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.normal,
//                      ),
//                      lbl(
//                        " / 1,930,000₮",
//                        color: Color(0XFF29B35A),
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.normal,
////                          padding: EdgeInsets.only(right: _paddingHorizontal),
//                      ),
//                    ],
//                  )
//                ],
//              ),
//            ],
//          ),
//
//          /// Logo
//          Align(
//            alignment: Alignment.topRight,
//            child: Container(
//              padding: EdgeInsets.only(top: 10.0, right: 10.0),
//              child: Image.asset(
//                ImageAsset.eye,
//                width: 25.0,
//                colorBlendMode: BlendMode.modulate,
//              ),
//            ),
//          ),
//        ],
//      ),
//    ),
//  );
//}
//
//_packetDetail2() {
//  return card(
//    margin: EdgeInsets.only(top: 10.0, right: _cardMargin, bottom: 10.0, left: _cardMargin),
//    gradient: new LinearGradient(
//        colors: [Color(0XFF162B75), Color(0XFF009286)],
//        begin: const FractionalOffset(0.0, 0.0),
//        end: const FractionalOffset(0.8, 0.8),
//        stops: [0.0, 1.0],
//        tileMode: TileMode.clamp),
//    child: Container(
//      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0, left: 15.0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Expanded(
//            flex: 5,
//            child: lbl(
//              "Та одоогоор ямар нэг\nбонд эзэмшээгүй байна",
//              fontWeight: FontWeight.normal,
//              fontSize: 16.0,
//              maxLines: 2,
//              color: Colors.white,
//            ),
//          ),
//          btn(
//            isUppercase: false,
//            text: 'Бонд авах',
//            borderRadius: 5.0,
//            height: 30.0,
//            width: 100.0,
//            context: context,
//            margin: EdgeInsets.all(0.0),
//            color: AppColors.bgBlue,
//            disabledColor: AppColors.btnBlue,
//            textColor: Colors.white,
//            fontSize: 16.0,
//            fontWeight: FontWeight.normal,
//            onPressed: () {
//              Navigator.of(context).push(
//                new PageRouteBuilder(
//                  pageBuilder: (BuildContext context, _, __) {
//                    return new SurveyScreen();
//                  },
//                  transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//                    return new FadeTransition(opacity: animation, child: child);
//                  },
//                ),
//              );
//            },
//          ),
//        ],
//      ),
//    ),
//  );
//}
//
//final _pageController = PageController(viewportFraction: 0.9);
//final _currentPageNotifier = ValueNotifier<int>(0);
//
//_myBonds() {
//  return Column(
//    children: <Widget>[
//      SizedBox(height: 0.0),
//      Container(
//        color: Colors.transparent,
//        height: PAGER_HEIGHT,
//        child: PageView(
//          controller: _pageController,
//          onPageChanged: (int index) {
//            _currentPageNotifier.value = index;
//          },
//          physics: BouncingScrollPhysics(),
////            itemCount: listOfCharacters.length,
////            itemBuilder: (context, index) {
////              final scale =
////              max(SCALE_FRACTION, (FULL_SCALE - (index - page).abs()) + viewPortFraction);
////              return circleOffer(
////                  listOfCharacters[index]['image'], scale);
////            },
//          children: <Widget>[
//            BondCard(),
//            BondCard(),
//            BondCard(),
//          ],
//        ),
//      ),
//      SizedBox(height: 5.0),
//      CirclePageIndicator(
//        selectedDotColor: AppColors.imgActive,
//        dotColor: Colors.grey,
//        itemCount: 3,
//        currentPageNotifier: _currentPageNotifier,
//      ),
//    ],
//  );
//}
//
//_promotion() {
//  return card(
//    margin: EdgeInsets.only(top: 10.0, right: _cardMargin, bottom: 10.0, left: _cardMargin),
//    child: Column(
//      children: <Widget>[
//        SizedBox(
//          height: 10.0,
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            lbl(
//              "Урамшуулал",
//              color: Color(0XFF8D98AB),
//              fontSize: 16.0,
//              padding: EdgeInsets.only(left: _cardMargin),
//            ),
//            lbl(
//              "15h:37m:28s",
//              color: Color(0XFF162B75),
//              fontSize: 16.0,
//              padding: EdgeInsets.only(right: _cardMargin),
//            ),
//          ],
//        ),
//        Container(
//          height: 1.0,
//          color: Color(0XFFE4E7EC),
//          margin: EdgeInsets.only(
//            top: 10.0,
//            right: 0.0,
//            bottom: 10.0,
//            left: 0.0,
//          ),
//        ),
//
//        /// Хөндлөн зураас
//        ExpandablePanel(
//          theme: ExpandableThemeData(
//            iconRotationAngle: 1.0,
//            iconSize: 40.0,
//            expandIcon: Icons.keyboard_arrow_right,
//            collapseIcon: Icons.keyboard_arrow_down,
//          ),
//          header: Container(
//            padding: EdgeInsets.only(bottom: 10.0),
//            height: 60.0,
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(left: _cardMargin),
//                  child: new Image.asset(
//                    ImageAsset.gift,
//                    width: 43.0,
//                    height: 43.0,
//                    fit: BoxFit.fill,
//                  ),
//                ),
//                SizedBox(width: 10.0),
//                lbl(
//                  '18%',
//                  fontSize: 32.0,
//                  fontWeight: FontWeight.bold,
//                  color: Color(0XFF29B35A),
//                ),
//                SizedBox(
//                  width: 10.0,
//                ),
//                Flexible(
//                  child: lbl(
//                    'онцгой урамшууллыг\nзөвхөн танд'.toUpperCase(),
//                    maxLines: 2,
//                    color: Color(0XFF1B2330),
//                    fontSize: 13.0,
//                  ),
//                ),
//              ],
//            ),
//          ),
//          expanded: Column(
//            children: <Widget>[
//              Row(
//                children: <Widget>[
//                  Column(
//                    children: <Widget>[
//                      lbl(
//                        "Нийт бонд",
//                        color: Color(0XFF8D98AB),
//                        fontSize: 12.0,
//                        padding: EdgeInsets.only(left: _cardMargin),
//                      ),
//                      lbl(
//                        "₮35.0 сая",
//                        color: Color(0XFF162B75),
//                        fontSize: 20.0,
//                        fontWeight: FontWeight.w500,
//                        padding: EdgeInsets.only(left: _cardMargin),
//                      ),
//                    ],
//                  ),
//
//                  /// Хөндлөн зураас
//                  Container(
//                    width: 1.0,
//                    height: 50.0,
//                    color: Color(0XFF8D98AB),
//                    margin: EdgeInsets.only(
//                      top: 10.0,
//                      right: 30.0,
//                      bottom: 10.0,
//                      left: 30.0,
//                    ),
//                  ),
//
//                  Column(
//                    children: <Widget>[
//                      lbl(
//                        "Багцын хүү / Өгөөж",
//                        color: Color(0XFF8D98AB),
//                        fontSize: 12.0,
//                        padding: EdgeInsets.only(left: _cardMargin),
//                      ),
//                      Row(
//                        children: <Widget>[
//                          lbl(
//                            "15.7%",
//                            color: Color(0XFF162B75),
//                            fontSize: 16.0,
//                            fontWeight: FontWeight.normal,
//                          ),
//                          lbl(
//                            " / 1,930,000₮",
//                            color: Color(0XFF29B35A),
//                            fontSize: 16.0,
//                            fontWeight: FontWeight.normal,
//                            padding: EdgeInsets.only(right: _cardMargin),
//                          ),
//                        ],
//                      )
//                    ],
//                  ),
//                ],
//              ),
//              SizedBox(
//                height: 10.0,
//              ),
//              Container(
//                padding: EdgeInsets.only(bottom: 15.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    btn(
//                      isUppercase: false,
//                      text: 'Дэлгэрэнгүй',
//                      borderRadius: 20.0,
//                      height: 30.0,
//                      width: 130.0,
//                      context: context,
//                      margin: EdgeInsets.symmetric(horizontal: 15.0),
//                      color: AppColors.athensGray,
//                      disabledColor: AppColors.athensGray,
//                      textColor: AppColors.lblDark,
//                      fontSize: 16.0,
//                      fontWeight: FontWeight.normal,
//                      onPressed: () {
//                        //
//                      },
//                    ),
//                    btn(
//                      isUppercase: false,
//                      text: 'Авах',
//                      borderRadius: 5.0,
//                      height: 30.0,
//                      width: 100.0,
//                      context: context,
//                      margin: EdgeInsets.symmetric(horizontal: 15.0),
//                      color: AppColors.bgBlue,
//                      disabledColor: AppColors.btnBlue,
//                      textColor: Colors.white,
//                      fontSize: 16.0,
//                      fontWeight: FontWeight.normal,
//                      onPressed: () {
//                        //
//                      },
//                    ),
//                  ],
//                ),
//              )
//            ],
//          ),
//          tapHeaderToExpand: true,
//          hasIcon: true,
//        ),
//      ],
//    ),
//  );
//}
//

//
//_news() {
//  return card(
////      borderRadius: 20.0,
//    margin: EdgeInsets.only(top: 10.0, right: _cardMargin, bottom: 10.0, left: _cardMargin),
//    child: Stack(
//      children: <Widget>[
//        Center(
////            child: ColorFiltered(
////              colorFilter: ColorFilter.mode(
////                  Colors.black.withOpacity(0.3), BlendMode.srcOver),
////              child:
////            ),
//
//          child: new Image.asset(
//            ImageAsset.news_bg1,
//            width: double.infinity,
//            height: 130.0,
//            fit: BoxFit.fill,
//          ),
//        ),
//        Container(
//          padding: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0, left: 10.0),
//          child: Column(
//            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  lbl(
//                    "Мөнгөө хуримтлуулах \nаргууд",
//                    fontWeight: FontWeight.w500,
//                    fontSize: 16.0,
//                    maxLines: 2,
//                    color: Colors.white,
//                  ),
//                  btn(
//                    isUppercase: false,
//                    text: 'Унших',
//                    borderRadius: 5.0,
//                    height: 30.0,
//                    width: 80.0,
//                    context: context,
//                    margin: EdgeInsets.all(0.0),
//                    color: AppColors.bgBlue,
//                    disabledColor: AppColors.btnBlue,
//                    textColor: Colors.white,
//                    fontSize: 16.0,
//                    fontWeight: FontWeight.normal,
//                    onPressed: () {
//                      //
//                    },
//                  ),
//                ],
//              ),
//              SizedBox(
//                height: 30.0,
//              ),
//              lbl("4 минут унших", fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white),
//
//              SizedBox(height: 5.0),
//
//              /// Хөндлөн зураас
//              ClipRRect(
//                borderRadius: BorderRadius.circular(8),
//                child: LinearProgressIndicator(
//                  backgroundColor: Color(0XFFE4E7EC),
////                      valueColor: Animation<Color> Color(0xFF8D98AB),
//                  value: 0.1,
//                ),
//              ),
//            ],
//          ),
//        ),
//      ],
//    ),
//  );
//}