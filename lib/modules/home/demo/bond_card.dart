import 'package:flutter/material.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/labels.dart';

enum CardSide { FRONT, BACK }

class BondCard extends StatefulWidget {
  @override
  _BondCardState createState() => _BondCardState();
}

class _BondCardState extends State<BondCard> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _frontScale;
  Animation<double> _backScale;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _frontScale = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    _backScale = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return new Center(
      child: new Stack(
        children: <Widget>[
          new AnimatedBuilder(
            child: new BondCardSide(
              cardSide: CardSide.BACK,
              colors: Colors.orange,
              onPressed: _onPressed,
            ),
            animation: _backScale,
            builder: (BuildContext context, Widget child) {
              final Matrix4 transform = new Matrix4.identity()
                ..scale(_backScale.value, 1.0, 1.0);
              return new Transform(
                transform: transform,
                alignment: FractionalOffset.center,
                child: child,
              );
            },
          ),
          new AnimatedBuilder(
            child: new BondCardSide(
              cardSide: CardSide.FRONT,
              colors: Colors.blue,
              onPressed: _onPressed,
            ),
            animation: _frontScale,
            builder: (BuildContext context, Widget child) {
              final Matrix4 transform = new Matrix4.identity()
                ..scale(_frontScale.value, 1.0, 1.0);
              return new Transform(
                transform: transform,
                alignment: FractionalOffset.center,
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }

  _onPressed() {
    setState(() {
      if (_controller.isCompleted || _controller.velocity > 0)
        _controller.reverse();
      else
        _controller.forward();
    });
  }
}

class BondCardSide extends StatelessWidget {
  BondCardSide({this.cardSide, this.colors, this.onPressed});

  final MaterialColor colors;
  final Function onPressed;
  final CardSide cardSide;

  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        onPressed();
      },
      child: CustomCard(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10.0),
        gradient: new LinearGradient(
            colors: [Color(0XFF010247), Color(0XFF2094C3)],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.8, 0.8),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        child: Container(
          height: 300,
          padding:
              EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0, left: 15.0),
          child: cardSide == CardSide.FRONT ? _frontSide() : _backSide(),
        ),
      ),
    );
  }

  _frontSide() {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            lbl(
              'НЭТБОНД',
              color: Color(0XFF8D98AB),
              fontSize: 11.0,
            ),
            lbl(
              '15,000,000₮',
              color: Color(0XFFE4E7EC),
              fontSize: 24.0,
            ),
            lbl(
              '106 206 686 / MNT',
              color: Color(0XFFE4E7EC),
              fontSize: 18.0,
            ),
            lbl(
              '01/20      01/21',
              color: Color(0XFF8D98AB),
              fontSize: 11.0,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Image.asset(
            AssetName.card_img,
            width: 200.0,
            colorBlendMode: BlendMode.modulate,
          ),
        ),
      ],
    );
  }

  _backSide() {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            lbl(
              'НЭТБОНД',
              color: Color(0XFF8D98AB),
              fontSize: 11.0,
            ),
            Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    lbl(
                      'Үндсэн дүн:',
                      color: Color(0XFFE4E7EC),
                      fontSize: 12.0,
                    ),
                    SizedBox(height: 15.0),
                    lbl(
                      'Хүү / Өгөөж:' + '   ',
                      color: Color(0XFFE4E7EC),
                      fontSize: 12.0,
                    ),
                    SizedBox(height: 15.0),
                    lbl(
                      'Төлөв:',
                      color: Color(0XFFE4E7EC),
                      fontSize: 12.0,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    lbl(
                      '15,000₮',
                      color: Color(0XFFE4E7EC),
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        lbl(
                          '17.5%' + ' / ',
                          color: Color(0XFFE4E7EC),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        lbl(
                          '115,068₮',
                          color: Color(0XFF29B35A),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        lbl(
                          'Идэвхтэй ' + ' / ',
                          color: Color(0XFFE4E7EC),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        lbl(
                          'Барьцаалсан',
                          color: Color(0XFF8D98AB),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xFF8D98AB),
//              valueColor: Color(0xFF8D98AB),
                    value: 0.1,
                  ),
                ),
                SizedBox(height: 5.0),
                lbl(
                  '01/20      01/21',
                  color: Color(0XFF8D98AB),
                  fontSize: 11.0,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
