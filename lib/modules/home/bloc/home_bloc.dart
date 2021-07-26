import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => HomeInit();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is ChangeTab) {
      yield* _mapChangeTabToState(event.tabIndex);
    }
  }

  Stream<HomeState> _mapChangeTabToState(int tabIndex) async* {
    yield ChangeTabState(tabIndex: tabIndex);
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class HomeEvent extends Equatable {
  HomeEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

/// Tab солих
class ChangeTab extends HomeEvent {
  ChangeTab({@required this.tabIndex}) : super([tabIndex]);

  final int tabIndex;

  @override
  String toString() {
    return 'ChangeTab { tabIndex: $tabIndex }';
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class HomeState extends Equatable {
  HomeState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class HomeInit extends HomeState {}

class HomeLoading extends HomeState {}

class HomeFailed extends HomeState {
  final String text;

  HomeFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'HomeFailed { text: $text }';
  }
}

class ChangeTabState extends HomeState {
  final int tabIndex;

  ChangeTabState({this.tabIndex}) : super([tabIndex]);

  @override
  String toString() {
    return 'ChangeTabState { tabIndex: $tabIndex }';
  }
}
