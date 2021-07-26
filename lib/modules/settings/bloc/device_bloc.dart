import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/models/settings/bind_fb_request.dart';
import 'package:netware/api/models/settings/device_list_response.dart';
import 'package:netware/api/models/settings/remove_device_request.dart';
import 'package:netware/api/models/settings/update_profile_request.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  @override
  DeviceState get initialState => DeviceInit();

  @override
  Stream<DeviceState> mapEventToState(DeviceEvent event) async* {
    if (event is GetDeviceList) {
      yield* _mapGetDeviceListToState();
    } else if (event is RemoveDevice) {
      yield* _mapRemoveDeviceToState(event.deviceId);
    }
  }

  /// Хувийн мэдээлэл шинэчлэх
  Stream<DeviceState> _mapGetDeviceListToState() async* {
    try {
      yield DeviceLoading();

      var res = await ApiManager.selectUserDevice();

      if (res?.resultCode == 0) {
        if (res.deviceList != null && res.deviceList.length > 0) {
          yield GetDeviceListSuccess(deviceList: res.deviceList);
        }
      } else {
        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield ShowSnackBar(text: globals.text.requestFailed());
    }
  }

  /// Хувийн мэдээлэл шинэчлэх
  Stream<DeviceState> _mapRemoveDeviceToState(int deviceId) async* {
    try {
      yield DeviceLoading();

      var req = RemoveDeviceRequest()..deviceId = deviceId;
      var res = await ApiManager.deleteUserDevice(req);

      if (res?.resultCode == 0) {
        yield RemoveDeviceSuccess(deviceId: deviceId);
      } else {
        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield ShowSnackBar(text: globals.text.requestFailed());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class DeviceEvent extends Equatable {
  DeviceEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Тогтмол ханддаг төхөөрөмжийн жагсаалт авах
class GetDeviceList extends DeviceEvent {}

/// Тогтмол хандах төхөөрөмж жагсаалтаас хасах
class RemoveDevice extends DeviceEvent {
  final int deviceId;

  RemoveDevice({@required this.deviceId})
      : assert(deviceId != null),
        super([deviceId]);

  @override
  List<Object> get props => [deviceId];

  @override
  String toString() {
    return 'RemoveDevice { deviceId: $deviceId }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class DeviceState extends Equatable {
  DeviceState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class DeviceInit extends DeviceState {}

class DeviceLoading extends DeviceState {}

class GetDeviceListSuccess extends DeviceState {
  final List<UserDevice> deviceList;

  GetDeviceListSuccess({this.deviceList}) : super([deviceList]);

  @override
  String toString() {
    return 'GetDeviceListSuccess { deviceList: $deviceList }';
  }
}

class RemoveDeviceSuccess extends DeviceState {
  final int deviceId;

  RemoveDeviceSuccess({this.deviceId}) : super([deviceId]);

  @override
  String toString() {
    return 'RemoveDeviceSuccess { deviceId: $deviceId }';
  }
}

class ShowSnackBar extends DeviceState {
  final String text;

  ShowSnackBar({this.text}) : super([text]);

  @override
  String toString() {
    return 'ShowFailedToast { text: $text }';
  }
}
