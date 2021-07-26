import 'package:equatable/equatable.dart';
import 'package:netware/modules/sign_up/step1_id_front/api/id_front_response.dart';

abstract class IdFrontState extends Equatable {
  const IdFrontState();

  @override
  List<Object> get props => [];
}

class IdFrontInit extends IdFrontState {}

class IdFrontLoading extends IdFrontState {}

class IdFrontSuccess extends IdFrontState {
  final IdFrontResponse idFrontResponse;

  IdFrontSuccess({this.idFrontResponse});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'IdFrontSuccess { }';
}

class IdFrontFailed extends IdFrontState {
  final String resDesc;

  IdFrontFailed({
    this.resDesc,
  });

  @override
  List<Object> get props => [resDesc];

  @override
  String toString() => 'IdFrontFailed { resDesc: $resDesc }';
}

class IdFrontConfirmSuccess extends IdFrontState {}

class IdFrontConfirmFailed extends IdFrontState {
  final String resDesc;

  IdFrontConfirmFailed({this.resDesc});

  @override
  List<Object> get props => [resDesc];

  @override
  String toString() => 'IdFrontConfirmFailed { resDesc: $resDesc }';
}
