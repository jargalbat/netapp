import 'package:flutter/material.dart';
import 'dart:math';

const SCALE_FRACTION = 0.7;
const FULL_SCALE = 1.0;
const PAGER_HEIGHT = 200.0;

class ItCrowdPage extends StatefulWidget {
  @override
  _ItCrowdPageState createState() => _ItCrowdPageState();
}

class _ItCrowdPageState extends State<ItCrowdPage> {
  double viewPortFraction = 0.5;

  PageController pageController;

  int currentPage = 2;

  List<Map<String, String>> listOfCharacters = [
    {'image': "assets/img/eye.png", 'name': "Richmond"},
    {'image': "assets/img/eye.png", 'name': "Roy"},
    {'image': "assets/img/eye.png", 'name': "Moss"},
    {'image': "assets/img/eye.png", 'name': "Douglas"},
    {'image': "assets/img/eye.png", 'name': "Jen"}
  ];

  double page = 2.0;

  @override
  void initState() {
    pageController = PageController(
        initialPage: currentPage, viewportFraction: viewPortFraction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text(
          "The IT Crowd",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            height: PAGER_HEIGHT,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollUpdateNotification) {
                  setState(() {
                    page = pageController.page;
                  });
                }
                return false;
              },
              child: PageView.builder(
                onPageChanged: (pos) {
                  setState(() {
                    currentPage = pos;
                  });
                },
                physics: BouncingScrollPhysics(),
                controller: pageController,
                itemCount: listOfCharacters.length,
                itemBuilder: (context, index) {
                  final scale = max(SCALE_FRACTION,
                      (FULL_SCALE - (index - page).abs()) + viewPortFraction);
                  return circleOffer(listOfCharacters[index]['image'], scale);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              listOfCharacters[currentPage]['name'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget circleOffer(String image, double scale) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: PAGER_HEIGHT * scale,
        width: PAGER_HEIGHT * scale,
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          shape: CircleBorder(
              side: BorderSide(color: Colors.grey.shade200, width: 5)),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
