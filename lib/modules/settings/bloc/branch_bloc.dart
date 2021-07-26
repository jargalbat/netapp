import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netware/api/bloc/api_manager.dart';
import 'package:netware/api/models/settings/branch_list_response.dart';
import 'package:netware/app/globals.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  @override
  BranchState get initialState => BranchInit();

  @override
  Stream<BranchState> mapEventToState(BranchEvent event) async* {
    if (event is GetBranchList) {
      yield* _mapGetBranchListToState();
    }
  }

  Stream<BranchState> _mapGetBranchListToState() async* {
    try {
      yield BranchLoading();

      BranchListResponse res = await ApiManager.getBranchList();

      if (res.resultCode == 0) {
        yield BranchListSuccess(branchList: res.branchList);
      } else {
        yield BranchFailed(text: globals.text.noData());
      }
    } catch (e) {
      yield BranchFailed(text: globals.text.errorOccurred());
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class BranchEvent extends Equatable {
  BranchEvent([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

// Салбарын жагсаалт авах
class GetBranchList extends BranchEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

@immutable
abstract class BranchState extends Equatable {
  BranchState([this.obj]);

  final List<Object> obj;

  @override
  List<Object> get props => obj;
}

class BranchInit extends BranchState {}

class BranchLoading extends BranchState {}

class BranchListSuccess extends BranchState {
  final List<Branch> branchList;

  BranchListSuccess({@required this.branchList}) : super([branchList]);

  @override
  String toString() {
    return 'BranchListSuccess { branchList: $branchList }';
  }
}

class BranchFailed extends BranchState {
  final String text;

  BranchFailed({this.text}) : super([text]);

  @override
  String toString() {
    return 'BranchFailed { text: $text }';
  }
}
