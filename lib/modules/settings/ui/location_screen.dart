//import 'dart:async';
//import 'dart:typed_data';
//
//import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
//import 'package:netware/app/app_helper.dart';
//import 'package:netware/app/globals.dart';
//import 'package:netware/app/localization/localization.dart';
//import 'package:netware/app/themes/app_colors.dart';
//import 'package:netware/app/utils/func.dart';
//import 'package:netware/app/widgets/app_bar.dart';
//import 'package:netware/app/widgets/buttons/buttons.dart';
//import 'package:netware/app/widgets/cards/cards.dart';
//import 'package:netware/app/widgets/labels.dart';
//
//class LocationScreen extends StatefulWidget {
//  final Function(String) callBack;
//
//  LocationScreen({this.callBack});
//
//  @override
//  _LocationScreenState createState() => _LocationScreenState();
//}
//
//class _LocationScreenState extends State<LocationScreen> with SingleTickerProviderStateMixin {
//  final _scaffoldKey = GlobalKey<ScaffoldState>();
//  Localization _loc;
//  double _paddingHorizontal = 20.0;
//
//  Completer<GoogleMapController> mapController = Completer();
//  final Map<String, Marker> _markers = {};
//  final LatLng _center = const LatLng(47.918321, 106.9174303);
//  Uint8List markerIcon;
//
//  bool _isYes = false;
//  bool _isNo = false;
//
//  String _currentAddress = '';
//
//  void _onMapCreated(GoogleMapController controller) {
//    mapController.complete(controller);
////    myLocation();
//  }
//
//  @override
//  void initState() {
//    super.initState();
//
//    _currentAddress = 'Сүхбаатар дүүрэг 1-р хороо, Олимпийн гудамж, Шангри-Ла 2201т';
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
//      child: Scaffold(
//        key: _scaffoldKey,
//        backgroundColor: AppColors.bgGrey,
//        appBar: AppBarSimple(
//          context: context,
//          onPressed: _onBackPressed,
//          brightness: Brightness.light,
//        ),
//        body: ListView(
////            crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Container(
//              padding: EdgeInsets.only(
//                right: _paddingHorizontal,
//                left: _paddingHorizontal,
//              ),
//              child: lbl(
//                'Салбарын байршил',
//                style: lblStyle.Headline4,
//                color: AppColors.lblDark,
//                fontWeight: FontWeight.normal,
//              ),
//            ),
//
//            SizedBox(height: 20.0),
//
////              lbl('Coming soon'),
//
//            SizedBox(height: 20.0),
//
//            SizedBox(
//              height: 300.0,
//              child: CustomCard(
//                child: GoogleMap(
//                  onMapCreated: _onMapCreated,
//                  initialCameraPosition: CameraPosition(
//                    target: _center,
//                    zoom: 16.0,
//                  ),
////                    markers: _markers.values.toSet(),
////                    myLocationEnabled: true,
////                    myLocationButtonEnabled: true,
//                ),
//              ),
//            ),
//
////              Flexible(
////                child: Container(),
////              ),
//
////              SizedBox(height: 20.0),
////
////              _confirmLocation(),
////
////              SizedBox(height: 30.0),
////
////              /// Хадгалах
////              _btnSave(),
//
//            SizedBox(height: AppHelper.marginBottom),
//          ],
//        ),
//      ),
//    );
//  }
//
//  void myLocation() async {
//    var currentLocation;
//    var location = new Location();
//    final GoogleMapController controller = await mapController.future;
//
//    try {
//      currentLocation = await location.getLocation();
//
//      setState(() {
//        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currentLocation["latitude"], currentLocation["longitude"]))));
//      });
//    } catch (e) {
//      print(e);
//      currentLocation = null;
//    }
//  }
//
//  _confirmLocation() {
//    return CustomCard(
//        margin: EdgeInsets.only(
//          top: 0.0,
//          right: _paddingHorizontal,
//          bottom: 0.0,
//          left: _paddingHorizontal,
//        ),
//        padding: EdgeInsets.only(
//          top: 15.0,
//          right: 10.0,
//          bottom: 15.0,
//          left: 10.0,
//        ),
//        child: Column(
//          children: <Widget>[
//            lbl(
//              'Энэ таны хаяг мөн үү?',
//              color: AppColors.lblDark,
//              fontSize: 24.0,
//              fontWeight: FontWeight.w500,
//            ),
//            SizedBox(height: 10.0),
//            Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Icon(Icons.location_on),
//                SizedBox(width: 10.0),
//                Flexible(
//                  child: lbl(
//                    _currentAddress,
//                    maxLines: 5,
//                    fontSize: 16.0,
//                  ),
//                ),
//              ],
//            ),
//            SizedBox(height: 10.0),
//            Row(
//              children: <Widget>[
//                Flexible(
//                  child: _btnYes(),
//                ),
//                Flexible(
//                  child: _btnNo(),
//                ),
//              ],
//            ),
//          ],
//        ));
//  }
//
//  _btnYes() {
//    return CustomButton(
//      text: Func.toStr(_loc.yes()).toUpperCase(),
//      context: context,
//      margin: EdgeInsets.only(right: 5.0),
//      color: _isYes ? AppColors.btnBlue : AppColors.btnGrey,
//      disabledColor: _isYes ? AppColors.btnBlue : AppColors.btnGrey,
//      textColor: _isYes ? Colors.white : AppColors.btnBlue,
//      fontSize: 16.0,
//      fontWeight: FontWeight.w500,
//      onPressed: () {
//        setState(() {
//          _isYes = !_isYes;
//          _isNo = !_isYes;
//        });
//      },
//    );
//  }
//
//  _btnNo() {
//    return CustomButton(
//      text: Func.toStr(_loc.no()).toUpperCase(),
//      context: context,
//      margin: EdgeInsets.only(left: 5.0),
//      color: _isNo ? AppColors.btnBlue : AppColors.btnGrey,
//      disabledColor: _isNo ? AppColors.btnBlue : AppColors.btnGrey,
//      textColor: _isNo ? Colors.white : AppColors.btnBlue,
//      fontSize: 16.0,
//      fontWeight: FontWeight.w500,
//      onPressed: () {
//        setState(() {
//          _isNo = !_isNo;
//          _isYes = !_isNo;
//        });
//      },
//    );
//  }
//
//  _btnSave() {
//    return CustomButton(
//      text: Func.toStr(_loc.save()).toUpperCase(),
//      context: context,
//      margin: EdgeInsets.symmetric(horizontal: _paddingHorizontal + 10.0),
//      color: AppColors.bgBlue,
//      disabledColor: AppColors.btnBlue,
//      textColor: Colors.white,
//      fontSize: 16.0,
//      fontWeight: FontWeight.w500,
//      onPressed: () {
//        if (_isYes) {
//          widget.callBack(_currentAddress);
//        }
//
//        Navigator.pop(context);
//      },
//    );
//  }
//
//  _onBackPressed() {
//    Navigator.pop(context);
//  }
//}
