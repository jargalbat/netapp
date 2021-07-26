import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/notification/notif_list_response.dart';
import 'package:netware/app/globals.dart';
import 'package:netware/app/utils/func.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class NotifBloc extends Bloc<NotifEvent, NotifState> {
  @override
  NotifState get initialState => NotifInit();

  @override
  Stream<NotifState> mapEventToState(NotifEvent event) async* {
    if (event is GetNotifList) {
      yield* _mapGetNotifToState();
    } else if (event is ChangeNotifCount) {
      yield* _mapChangeNotifCountToState(event.notifCount);
    }
  }

  Stream<NotifState> _mapGetNotifToState({String fbId, String fbName}) async* {
    try {
      yield NotifLoading();

      var res = await ApiManager.getNotifList();
      if (res.resultCode == 0) {
        if (res.notifList != null && res.notifList.isNotEmpty) {
          yield GetNotifListSuccess(notifListResponse: res);
        } else {
          yield ShowSnackBar(text: globals.text.noData());
        }
      } else {
        // Мэдэгдэл олдсонгүй
        yield ShowSnackBar(text: Func.isEmpty(res?.resultDesc) ? '${globals.text.notification()} ${globals.text.notFound()}.' : res.resultDesc);
      }
    } catch (e) {
      print(e);
      yield ShowSnackBar(text: globals.text.errorOccurred());
    }
  }

  Stream<NotifState> _mapChangeNotifCountToState(int notifCount) async* {
    yield NotifCountChanged(notifCount: notifCount);
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class NotifEvent extends Equatable {
  NotifEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Мэдэгдлийн жагсаалт авах
class GetNotifList extends NotifEvent {}

/// Мэдэгдлийн тоо өөрчлөх
class ChangeNotifCount extends NotifEvent {
  final int notifCount;

  ChangeNotifCount({this.notifCount}) : super([notifCount]);

  @override
  String toString() {
    return 'ChangeNotifCount { notifCount: $notifCount }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class NotifState extends Equatable {
  NotifState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class NotifInit extends NotifState {}

class NotifLoading extends NotifState {}

/// Мэдэгдлийн жагсаалт амжилттай авсан
class GetNotifListSuccess extends NotifState {
  final NotifListResponse notifListResponse;

  GetNotifListSuccess({@required this.notifListResponse}) : super([notifListResponse]);

  @override
  String toString() {
    return 'GetNotifListSuccess { res: $notifListResponse }';
  }
}

/// Мэдэгдлийн жагсаалт амжилттай авсан
class NotifCountChanged extends NotifState {
  final int notifCount;

  NotifCountChanged({@required this.notifCount}) : super([notifCount]);

  @override
  String toString() {
    return 'NotifCountChanged { notifCount: $notifCount }';
  }
}

class ShowSnackBar extends NotifState {
  final String text;

  ShowSnackBar({this.text}) : super([text]);

  @override
  String toString() {
    return 'ShowSnackBar { text: $text }';
  }
}
