import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/models/settings/device_list_response.dart';
import 'package:netware/app/app_helper.dart';
import 'package:netware/app/assets/image_asset.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/localization/localization.dart';
import 'package:netware/app/route_transitions.dart';
import 'package:netware/app/themes/app_colors.dart';
import 'package:netware/app/utils/func.dart';
import 'package:netware/app/widgets/app_bar.dart';
import 'package:netware/app/widgets/buttons/buttons.dart';
import 'package:netware/app/widgets/cards/cards.dart';
import 'package:netware/app/widgets/dialogs.dart';
import 'package:netware/app/widgets/labels.dart';
import 'package:netware/app/widgets/list_item.dart';
import 'package:netware/app/widgets/loaders/loaders.dart';
import 'package:netware/app/widgets/snack_bar.dart';
import 'package:netware/modules/settings/bloc/device_bloc.dart';
import 'package:netware/modules/settings/ui/settings_header.dart';

class DeviceListRoute extends StatefulWidget {
  @override
  _DeviceListRouteState createState() => _DeviceListRouteState();
}

class _DeviceListRouteState extends State<DeviceListRoute> {
  var _deviceKey = GlobalKey<ScaffoldState>();
  DeviceBloc _deviceBloc;
  var _deviceList = <UserDevice>[];

  @override
  void initState() {
    _deviceBloc = DeviceBloc()..add(GetDeviceList());
    super.initState();
  }

  @override
  void dispose() {
    _deviceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceBloc>(
      create: (context) => _deviceBloc,
      child: BlocListener<DeviceBloc, DeviceState>(
        listener: _blocListener,
        child: BlocBuilder<DeviceBloc, DeviceState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, DeviceState state) {
    if (state is GetDeviceListSuccess) {
      _deviceList = state.deviceList;
    } else if (state is RemoveDeviceSuccess) {
      _deviceList.removeWhere((element) => element.deviceId == state.deviceId);
    } else if (state is ShowSnackBar) {
      showSnackBar(key: _deviceKey, text: state.text);
    }
  }

  Widget _blocBuilder(BuildContext context, DeviceState state) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        key: _deviceKey,
        appBar: AppBarSimple(
          context: context,
          brightness: Brightness.light,
          onPressed: () {
            _onBackPressed();
          },
          hasBackArrow: true,
        ),
        backgroundColor: AppColors.bgGrey,
        body: LoadingContainer(
          loading: state is DeviceLoading,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /// Тохиргоо
                SettingsHeader(title: globals.text.settings()),

                /// Төхөөрөмжүүд
                _deviceListWidget(),

                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deviceListWidget() {
    return CustomCard(
      margin: EdgeInsets.only(right: AppHelper.margin, left: AppHelper.margin),
      child: Column(
        children: <Widget>[
          /// Төхөөрөмжүүд
          Container(
            margin: EdgeInsets.all(0.0),
            padding: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0, left: 10.0),
            child: lbl(globals.text.devices(), style: lblStyle.Headline5),
          ),

          /// List
          for (int i = 0; i < _deviceList.length; i++) _listItem(i),
        ],
      ),
    );
  }

  Widget _listItem(int index) {
    return MenuListItem(
      decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0, color: AppColors.bgGrey))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /// Icon
          lbl('●',
              fontSize: 16.0,
              color: (Func.toStr(globals.deviceCode).toUpperCase() == Func.toStr(_deviceList[index].deviceCode).toUpperCase())
                  ? AppColors.jungleGreen
                  : Colors.transparent),

          SizedBox(width: 10.0),

          /// Text
          Expanded(
              child: Column(
            children: <Widget>[
              /// Device name
              lbl(Func.toStr(_deviceList[index].name), fontSize: AppHelper.fontSizeMedium),

              /// Created date time
              lbl(Func.toDateTimeStr(_deviceList[index].createdDatetime), fontSize: AppHelper.fontSizeCaption, color: AppColors.lblGrey),
            ],
          )),

          SizedBox(width: 10.0),

          /// Delete button
          InkWell(
            child: Icon(Icons.close, color: AppColors.iconRed),
            onTap: () {
              _onPressedBtnRemove(index);
            },
          ),
        ],
      ),
    );
  }

  _onPressedBtnRemove(int index) {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: ScaleDialog(
          margin: EdgeInsets.all(AppHelper.margin),
          padding: EdgeInsets.all(AppHelper.margin),
          child: Container(
            height: 350.0,
            width: MediaQuery.of(this.context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20.0),

                Image.asset(
                  AssetName.delete_blue,
                  height: 74.0,
                  colorBlendMode: BlendMode.modulate,
                ),

                SizedBox(height: 30.0),

                lbl(
                  '${globals.text.sureDelete()}?'.toUpperCase(),
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                  color: AppColors.lblDark,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                  fontSize: 16.0,
                ),

                SizedBox(height: 30.0),

                /// Хөндлөн зураас
                Container(
                  height: 0.5,
                  color: AppColors.athensGray,
                  margin: EdgeInsets.only(
                    top: 10.0,
                    right: 30.0,
                    bottom: 15.0,
                    left: 30.0,
                  ),
                ),

                lbl(
                  _deviceList[index].name,
                  margin: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  textAlign: TextAlign.end,
                  color: AppColors.lblDark,
                  fontWeight: FontWeight.normal,
                  maxLines: 3,
                  fontSize: 16.0,
                ),

                SizedBox(height: 10.0),

                Expanded(child: Container()),

                /// BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        text: globals.text.cancel(),
                        context: context,
                        margin: EdgeInsets.only(right: 5.0),
                        color: AppColors.btnGrey,
                        disabledColor: AppColors.btnGrey,
                        textColor: AppColors.lblBlue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        height: 44.0,
                        text: globals.text.yes(),
                        context: context,
                        margin: EdgeInsets.only(left: 5.0),
                        color: AppColors.bgBlue,
                        disabledColor: AppColors.btnBlue,
                        textColor: AppColors.lblWhite,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        onPressed: () {
                          _deviceBloc.add(RemoveDevice(deviceId: _deviceList[index].deviceId));
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onBackPressed() {
    Navigator.pop(context);
  }
}
