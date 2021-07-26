import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/bloc/connection_manager.dart';
import 'package:netware/api/models/base_request.dart';
import 'package:netware/api/models/base_response.dart';
import 'package:netware/api/models/dictionary/dictionary_response.dart';
import 'package:netware/api/models/settings/bind_fb_request.dart';
import 'package:netware/api/models/settings/get_profile_response.dart';
import 'package:netware/api/models/settings/update_profile_pic_request.dart';
import 'package:netware/api/models/settings/update_profile_pic_response.dart';
import 'package:netware/api/models/settings/update_profile_request.dart';
import 'package:netware/app/dictionary_manager.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  @override
  ProfileState get initialState => ProfileInit();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetProfile) {
      yield* _mapGetProfileToState();
    } else if (event is UpdateProfile) {
      yield* _mapUpdateProfileToState(event.request);
    } else if (event is GetMartialList) {
      yield* _mapMartialListToState();
    } else if (event is UploadProfilePicture) {
      yield* _mapUploadProfilePictureToState(event.file);
    }
  }

  /// Хувийн мэдээлэл авах
  Stream<ProfileState> _mapGetProfileToState() async* {
    try {
      yield ProfileLoading();

      var res = await ApiManager.getProfile();

      if (res?.resultCode == 0) {
        globals.user.regNo = res.regNo;
        globals.user.lastName = res.lastName;
        globals.user.sex = res.sex;
        globals.user.mobileNo = res.mobileNo;
        globals.user.userId = res.userId;
        globals.user.custCode = res.custCode;
        globals.user.firstName = res.firstName;
        globals.user.loginName = res.loginName;
        globals.user.maritalId = res.maritalId;
        globals.user.fbId = res.fbId;
        globals.user.addrDetail = res.addrDetail;
        globals.user.email = res.email;
        globals.user.fbName = res.fbName;

        yield GetProfileSuccess(profileResponse: res);
      } else {
        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield ShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  /// Хувийн мэдээлэл шинэчлэх
  Stream<ProfileState> _mapUpdateProfileToState(UpdateProfileRequest req) async* {
    try {
      yield ProfileLoading();

      var res = await ApiManager.updateProfile(req);

      if (res?.resultCode == 0) {
        globals.user.regNo = req.regNo;
        globals.user.lastName = req.lastName;
        globals.user.sex = req.sex;
        globals.user.mobileNo = req.mobileNo;
        globals.user.userId = req.userId;
        globals.user.custCode = req.custCode;
        globals.user.firstName = req.firstName;
        globals.user.loginName = req.loginName;
        globals.user.maritalId = req.maritalId;
        globals.user.addrDetail = req.addrDetail;
        globals.user.email = req.email;

        yield UpdateProfileSuccess();
      } else {
        yield UpdateProfileFailed(text: Func.isEmpty(res?.resultDesc) ? globals.text.requestFailed() : res.resultDesc);
      }
    } catch (e) {
      yield ShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  /// Dictionary - Гэрлэлтийн байдал
  Stream<ProfileState> _mapMartialListToState() async* {
    try {
      yield ProfileLoading();

      List<DictionaryData> martialList = await DictionaryManager.getDictionaryData(DictionaryCode.martial);

      if (martialList.isNotEmpty) {
        yield GetMartialListSuccess(martialList: martialList);
      } else {
        yield ShowSnackBar(text: '${globals.text.martial()} ${globals.text.notFound()}.'); // олдсонгүй
      }
    } catch (e) {
      yield ShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  Stream<ProfileState> _mapUploadProfilePictureToState(File file) async* {
    yield ProfileLoading();

    try {
      String fileName;

      if (globals.isTest) {
//        fileName = '61d8a6ea-8080-48ce-8fd6-cc0829a27e13.jpg';
      } else {
        fileName = await connectionManager.postMultipart(file: file);
      }

      if (!Func.isEmpty(fileName)) {
        final req = UpdateProfilePicRequest(imgPath: fileName);
        UpdateProfilePicResponse res = await ApiManager.updateProfilePic(req);
        if (res.resultCode == 0 && Func.isNotEmpty(res.base64Image)) {
          yield UploadProfilePictureSuccess(base64Image: res.base64Image);
        } else {
          yield UploadProfilePictureFailed(text: Func.isNotEmpty(res.resultDesc) ? res.resultDesc : globals.text.requestFailed());
        }
      } else {
        yield UploadProfilePictureFailed(text: globals.text.errorOccurred());
      }
    } catch (e) {
      print(e);
      yield UploadProfilePictureFailed(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class ProfileEvent extends Equatable {
  ProfileEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Get profile data
class GetProfile extends ProfileEvent {}

/// Update profile
class UpdateProfile extends ProfileEvent {
  final UpdateProfileRequest request;

  UpdateProfile({@required this.request}) : assert(request != null);

  @override
  List<Object> get props => [request];

  @override
  String toString() {
    return 'UpdateProfile { request: request }';
  }
}

/// Profile picture upload хийх
class UploadProfilePicture extends ProfileEvent {
  final File file;

  UploadProfilePicture({@required this.file}) : super([file]);

  @override
  String toString() => 'UploadProfilePicture { }';
}

/// Dictionary - Гэрлэлтийн байдал
class GetMartialList extends ProfileEvent {}

/// Facebook холбох
class BindFb extends ProfileEvent {
  final String fbId;
  final String fbName;

  BindFb({@required this.fbId, @required this.fbName})
      : assert(fbId != null),
        assert(fbName != null),
        super([fbId, fbName]);

  @override
  List<Object> get props => [fbId, fbName];

  @override
  String toString() {
    return 'BindFb { fbId: $fbId, fbName: $fbName }';
  }
}

/// Facebook салгах
class UnbindFb extends ProfileEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class ProfileState extends Equatable {
  ProfileState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class ProfileInit extends ProfileState {}

class ProfileLoading extends ProfileState {}

class GetProfileSuccess extends ProfileState {
  final GetProfileResponse profileResponse;

  GetProfileSuccess({this.profileResponse}) : super([profileResponse]);

  @override
  List<Object> get props => [profileResponse];

  @override
  String toString() {
    return 'GetProfileSuccess { profileResponse: $profileResponse }';
  }
}

class UpdateProfileSuccess extends ProfileState {}

class UpdateProfileFailed extends ProfileState {
  final String text;

  UpdateProfileFailed({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'UpdateProfileFailed { text: $text }';
  }
}

class GetMartialListSuccess extends ProfileState {
  final List<DictionaryData> martialList;

  GetMartialListSuccess({this.martialList}) : super([martialList]);

  @override
  List<Object> get props => [martialList];

  @override
  String toString() {
    return 'GetMartialListSuccess { martialList: $martialList }';
  }
}

/// Facebook холболт амжилттай
class BindFbSuccess extends ProfileState {
  final String fbId;
  final String fbName;

  BindFbSuccess({this.fbId, this.fbName}) : super([fbId, fbName]);

  @override
  List<Object> get props => [fbId, fbName];

  @override
  String toString() {
    return 'BindFbSuccess { fbId: $fbId, fbName: $fbName }';
  }
}

/// Facebook холболт амжилтгүй
class BindFbFailed extends ProfileState {
  final String resDesc;

  BindFbFailed({this.resDesc}) : super([resDesc]);

  @override
  List<Object> get props => [resDesc];

  @override
  String toString() {
    return 'BindFbFailed { resDesc: $resDesc }';
  }
}

class UploadProfilePictureSuccess extends ProfileState {
  final String base64Image;

  UploadProfilePictureSuccess({this.base64Image}) : super([base64Image]);

  @override
  String toString() {
    return 'UploadProfilePictureSuccess { base64Image: $base64Image }';
  }
}

class UploadProfilePictureFailed extends ProfileState {
  final String text;

  UploadProfilePictureFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'UploadProfilePictureFailed { text: $text }';
  }
}

class ShowSnackBar extends ProfileState {
  final String text;

  ShowSnackBar({this.text}) : super([text]);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'ShowFailedToast { text: $text }';
  }
}
