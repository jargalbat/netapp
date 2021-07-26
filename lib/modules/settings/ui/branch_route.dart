import 'dart:async';
import 'dart:typed_data';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:netware/api/models/settings/branch_list_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/animations.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:location/location.dart' as package_location;
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/containers/rounded_container.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/settings/bloc/branch_bloc.dart';
import 'package:netware/modules/settings/ui/history/bonus_history_tab.dart';
import 'package:netware/modules/settings/ui/history/loan_history_tab.dart';
import 'package:netware/modules/settings/ui/settings_header.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

import 'package:url_launcher/url_launcher.dart';

/// Салбар нэгж
class BranchRoute extends StatefulWidget {
  @override
  _BranchRouteState createState() => _BranchRouteState();
}

class _BranchRouteState extends State<BranchRoute> with TickerProviderStateMixin {
  /// UI
  var _branchKey = GlobalKey<ScaffoldState>();

  /// Data
  final _branchBloc = BranchBloc();
  List<Branch> _branchList = [];
  Branch _selectedBranch;

  /// Cupertino segmented control
  TabController _tabController;
  int _selectedIndex = 0;
  Map<int, Widget> _headerList = new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget> _childList = []; //The Widgets that has to be loaded when a tab is selected.

  /// Map
  Completer<GoogleMapController> mapController = Completer();
  final Map<String, Marker> _markers = {};

//  final LatLng _center = const LatLng(47.918321, 106.9174303); //Sukh
  final LatLng _center = const LatLng(47.913660, 106.921682); // Shangri la

  Uint8List markerIcon;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    // Tab headers
    _headerList = new Map();
    _headerList.putIfAbsent(0, () => Container(child: Text("Газрын зураг")));
    _headerList.putIfAbsent(1, () => Container(child: Text("Жагсаалт")));

//    globals.text.workTime()

    // Tab children
    _childList.addAll([
      LoanHistoryTab(),
      BonusHistoryTab(),
    ]);

    _branchBloc.add(GetBranchList());

    super.initState();
  }

  @override
  void dispose() {
    _branchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BranchBloc>(
      create: (context) => _branchBloc,
      child: BlocListener<BranchBloc, BranchState>(
        listener: _blocListener,
        child: BlocBuilder<BranchBloc, BranchState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, BranchState state) {
    if (state is BranchInit) {
      _checkPermission();
    } else if (state is BranchListSuccess) {
      _branchList = state.branchList;
      _selectedBranch = _branchList[0];
      addMarker();
    } else if (state is BranchFailed) {
      showSnackBar(key: _branchKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, BranchState state) {
    return Scaffold(
      key: _branchKey,
      backgroundColor: AppColors.bgGrey,
      appBar: AppBarSimple(
        context: context,
        onPressed: () {
          _onBackPressed(context);
        },
        brightness: Brightness.light,
        hasBackArrow: true,
//          hasBackArrow: true,
      ),
      body: Column(
        children: <Widget>[
          /// Салбар нэгж
          SettingsHeader(title: globals.text.branch(), margin: const EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 10.0)),

          /// Tab bar
          Container(
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: cupertino.CupertinoSegmentedControl(
                    onValueChanged: (value) {
                      setState(() {
                        _selectedIndex = value;
                      });
                      _tabController.animateTo(value);
                    },
                    groupValue: _selectedIndex,
                    children: <int, Widget>{
                      0: Container(
//                          width: double.infinity,
                        child: Text(globals.text.map()),
                        alignment: Alignment.center,
                      ),
                      1: Container(
//                          width: double.infinity,
                        child: Text(globals.text.list()),
                        alignment: Alignment.center,
                      ),
                    },
                    padding: EdgeInsets.all(10.0),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: RoundedContainer(
              margin: EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
              radius: 0.0,
              child: TabBarView(
                controller: _tabController,
                children: [
                  /// Газрын зураг tab
                  _mapTab(),

                  /// Жагсаалт tab
                  _branchListTab(),
                ],
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapTab() {
    double height = MediaQuery.of(context).size.width - AppHelper.margin;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          /// Google map
          Container(
//            margin: EdgeInsets.symmetric(horizontal: AppHelper.margin),
            height: height,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 13.0,
              ),
              markers: _markers.values.toSet(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
            ),
          ),

          /// Салбарын нэр
          Container(
            margin: EdgeInsets.fromLTRB(AppHelper.margin, AppHelper.margin, AppHelper.margin, 0.0),
            child: (_selectedBranch != null) ? FadeInSlow(child: lbl(Func.toStr(_selectedBranch.getName()), fontSize: 24.0, fontWeight: FontWeight.bold)) : Container(),
          ), // holder

          /// Салбарын хаяг
          Container(
            margin: EdgeInsets.fromLTRB(AppHelper.margin, 5.0, AppHelper.margin, AppHelper.margin),
            child: (_selectedBranch != null)
                ? FadeInSlow(
                    child: lbl(Func.toStr(_selectedBranch.addrName), fontSize: 16.0, color: AppColors.lblGrey, maxLines: 5),
                  )
                : Container(),
          ), // hol

          /// Залгах
          Container(
            margin: EdgeInsets.fromLTRB(AppHelper.margin, 5.0, AppHelper.margin, AppHelper.margin),
            child: (_selectedBranch != null) ? FadeInSlow(child: _btnSave()) : Container(),
          ), //

          SizedBox(height: AppHelper.marginBottom),
        ],
      ),
    );
  }

  _btnSave() {
    return CustomButton(
      text: globals.text.call(),
      context: context,
      color: AppColors.bgBlue,
      disabledColor: AppColors.btnBlue,
      textColor: Colors.white,
      icon: Icon(Icons.phone, color: AppColors.iconWhite),
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      onPressed: () {
        _call();
      },
    );
  }

  void _checkPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.location,
    ]);
    print(permissions);
    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      _myLocation();
    }
  }

  void addMarker() async {
    _markers.clear();

    await getBytesFromAsset(AssetName.branch_red, 80).then((markerIcon) {
      for (final branch in _branchList) {
        if (Func.isNotEmpty(branch.latitude) && Func.isNotEmpty(branch.longitude)) {
          final marker = Marker(
            markerId: MarkerId(branch.name),
            position: LatLng(double.parse(branch.latitude.replaceAll(',', '')), double.parse(branch.longitude.replaceAll(',', ''))),
            infoWindow: InfoWindow(
              title: branch.getName(),
              snippet: Func.toStr(branch.addrName),
              onTap: () async {
                setState(() {
                  _selectedBranch = branch;
                });
              },
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          );

          setState(() {
            _markers[branch.name] = marker;
          });
        }
      }
    });
  }

  void _call() async {
    if (_selectedBranch != null && Func.isNotEmpty(_selectedBranch.phone)) {
      String url = "tel:${_selectedBranch.phone}";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void _myLocation() async {
    var currentLocation;
    var location = new package_location.Location();
    final GoogleMapController controller = await mapController.future;

    try {
      currentLocation = await location.getLocation();

      setState(() {
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currentLocation["latitude"], currentLocation["longitude"]))));
      });
    } catch (e) {
      currentLocation = null;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  Widget _branchListTab() {
    return (_branchList != null && _branchList.length > 0)
        ? SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (var el in _branchList) _listItem(el),
              ],
            ),
          )
        : Container();
  }

  Widget _listItem(Branch branch) {
    return Column(
      children: <Widget>[
        ExpandablePanel(
          theme: ExpandableThemeData(iconRotationAngle: 3.0, iconSize: 20.0, iconPadding: EdgeInsets.all(20.0), expandIcon: Icons.keyboard_arrow_down, collapseIcon: Icons.keyboard_arrow_up, iconColor: AppColors.lblGrey),
          header:

              /// Header
              Container(
            padding: EdgeInsets.only(left: 10.0),
            height: 60.0,
            alignment: Alignment.centerLeft,
            child: lbl(Func.toStr(branch.name), fontSize: AppHelper.fontSizeMedium, alignment: Alignment.centerLeft, textAlign: TextAlign.left),
          ),

          /// Body
          expanded: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: AppColors.lineGreyCard),
              ),
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                /// Салбарын нэр
//                lbl(branch.getName(), style: lblStyle.Caption),
//
//                SizedBox(height: 10.0),

                /// Цагийн хуваарь
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: lbl('${globals.text.workTime()}:', color: AppColors.lblGrey, maxLines: 2)),
                    SizedBox(height: 10.0),
                    Flexible(flex: 2, child: lbl('${Func.toStr(branch.timetable)}', maxLines: 5)),
                  ],
                ),

                SizedBox(height: 10.0),

                /// Хаяг
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: lbl('${globals.text.address()}: ', color: AppColors.lblGrey)),
                    SizedBox(height: 10.0),
                    Flexible(flex: 2, child: lbl('${Func.toStr(branch.addrName)}', maxLines: 5)),
                  ],
                ),

                SizedBox(height: 10.0),

                /// Утас
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: lbl('${globals.text.mobile()}: ', color: AppColors.lblGrey)),
                    SizedBox(height: 10.0),
                    Flexible(flex: 2, child: lbl('${Func.toStr(branch.phone)}', color: AppColors.lblBlue, maxLines: 5)),
                  ],
                ),
              ],
            ),
          ),
          tapHeaderToExpand: true,
          hasIcon: true,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: AppColors.lineGreyCard),
            ),
          ),
        )
      ],
    );
  }

  _onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
}

//import 'package:flutter/cupertino.dart' as cupertino;
//import 'package:flutter/material.dart';
//import 'package:netware/app/app_helper.dart';
//import 'package:netware/app/globals.dart';
//import 'package:netware/app/themes/app_colors.dart';
//import 'package:netware/app/widgets/app_bar.dart';
//import 'package:netware/app/widgets/containers/rounded_container.dart';
//import 'package:netware/app/widgets/loaders/loaders.dart';
//import 'package:netware/modules/settings/ui/history/bonus_history_tab.dart';
//import 'package:netware/modules/settings/ui/history/loan_history_tab.dart';
//import 'package:netware/modules/settings/ui/settings_header.dart';
//
//class BranchRoute extends StatefulWidget {
//  @override
//  _BranchRouteState createState() => _BranchRouteState();
//}
//
//class _BranchRouteState extends State<BranchRoute> with TickerProviderStateMixin {
//  /// UI
//  var _branchKey = GlobalKey<ScaffoldState>();
//
//  /// Cupertino segmented control
//  TabController _tabController;
//  int _selectedIndex = 0;
//  Map<int, Widget> _headerList = new Map(); // Cupertino Segmented Control takes children in form of Map.
//  List<Widget> _childList = []; //The Widgets that has to be loaded when a tab is selected.
//
//  @override
//  void initState() {
//    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
//
//    // Tab headers
//    _headerList = new Map();
//    _headerList.putIfAbsent(0, () => Container(child: Text("${globals.text.map()}")));
//    _headerList.putIfAbsent(1, () => Container(child: Text("${globals.text.list()}")));
//
//    // Tab children
//    _childList.addAll([
//      LoanHistoryTab(),
//      BonusHistoryTab(),
//    ]);
//
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//      onWillPop: () async {
//        _onBackPressed();
//        return Future.value(false);
//      },
//      child: BlurLoadingContainer(
//        isLoading: state is ProfileLoading,
//        child: Scaffold(
//          key: _branchKey,
//          backgroundColor: AppColors.bgGrey,
//          appBar: AppBarSimple(
//            context: context,
//            onPressed: _onBackPressed,
//            brightness: Brightness.light,
//          ),
//          body: GestureDetector(
//            onTap: () {
//              FocusScope.of(context).requestFocus(new FocusNode()); // Hide keyboard
//            },
//            child: SingleChildScrollView(
//              controller: _scrollController,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  /// Хувийн мэдээлэл
//                  lbl(
//                    globals.text.privateInfo(),
//                    style: lblStyle.Headline4,
//                    margin: EdgeInsets.only(left: AppHelper.margin),
//                  ),
//
//                  SizedBox(height: 20.0),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//
//    return Scaffold(
//        key: _branchKey,
//        backgroundColor: AppColors.bgGrey,
//        appBar: AppBarSimple(
//          context: context,
//          onPressed: () {
//            _onBackPressed(context);
//          },
//          hasBackArrow: true,
//        ),
//        body: Column(
//          children: <Widget>[
//            /// Тохиргоо
//            SettingsHeader(title: globals.text.history(), margin: const EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 10.0)),
//
//            /// Tab bar
//            Container(
//              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    child: cupertino.CupertinoSegmentedControl(
//                      onValueChanged: (value) {
//                        setState(() {
//                          _selectedIndex = value;
//                        });
//                        _tabController.animateTo(value);
//                      },
//                      groupValue: _selectedIndex,
//                      children: <int, Widget>{
//                        0: Container(
////                          width: double.infinity,
//                          child: Text('${globals.text.loan()}'),
//                          alignment: Alignment.center,
//                        ),
//                        1: Container(
////                          width: double.infinity,
//                          child: Text('${globals.text.bonusPoint()}'),
//                          alignment: Alignment.center,
//                        ),
//                      },
//                      padding: EdgeInsets.all(10.0),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//
//            /// Tab children
////            RoundedContainer(child: _childList[_selectedIndex]),
//
//            Expanded(
//              child: RoundedContainer(
//                margin: cupertino.EdgeInsets.fromLTRB(AppHelper.margin, 0.0, AppHelper.margin, 0.0),
//                child: TabBarView(
//                  controller: _tabController,
//                  children: [
//                    LoanHistoryTab(),
//                    BonusHistoryTab(),
//                  ],
//                  physics: NeverScrollableScrollPhysics(),
//                ),
//              ),
//            ),
//          ],
//        ));
//  }
//
//  _onBackPressed(BuildContext context) {
//    Navigator.pop(context);
//  }
//}

//Widget _mapTab() {
//  double height = MediaQuery.of(context).size.width - AppHelper.margin;
//
//  return Column(
//    children: <Widget>[
//      /// Google map
//      Container(
//        height: height,
//        child: GoogleMap(
//          onMapCreated: _onMapCreated,
//          initialCameraPosition: CameraPosition(
//            target: _center,
//            zoom: 13.0,
//          ),
//          markers: _markers.values.toSet(),
//          myLocationEnabled: true,
//          myLocationButtonEnabled: true,
//        ),
//      ),
//
//      Expanded(
//        child: ListView(
//          children: <Widget>[
//            /// Салбарын нэр
//            Container(
//              margin: EdgeInsets.fromLTRB(AppHelper.margin, AppHelper.margin, AppHelper.margin, 0.0),
//              child: (_selectedBranch != null)
//                  ? FadeInSlow(child: lbl(Func.toStr(_selectedBranch.getName()), fontSize: 24.0, fontWeight: FontWeight.bold))
//                  : Container(),
//            ), // holder
//
//            /// Салбарын хаяг
//            Container(
//              margin: EdgeInsets.fromLTRB(AppHelper.margin, 5.0, AppHelper.margin, AppHelper.margin),
//              child: (_selectedBranch != null)
//                  ? FadeInSlow(
//                child: lbl(Func.toStr(_selectedBranch.addrName), fontSize: 16.0, color: AppColors.lblGrey, maxLines: 5),
//              )
//                  : Container(),
//            ), // hol
//
//            /// Залгах
//            Container(
//              margin: EdgeInsets.fromLTRB(AppHelper.margin, 5.0, AppHelper.margin, AppHelper.margin),
//              child: (_selectedBranch != null) ? FadeInSlow(child: _btnSave()) : Container(),
//            ), //
//
//            SizedBox(height: AppHelper.marginBottom),
//          ],
//        ),
//      ),
//    ],
//  );
//}
