import 'package:equatable/equatable.dart';
import 'package:netware/modules/sign_up/step2_id_back/api/id_back_response.dart';

abstract class IdBackState extends Equatable {
  const IdBackState();

  @override
  List<Object> get props => [];
}

class IdBackInit extends IdBackState {}

class IdBackLoading extends IdBackState {}

class IdBackSuccess extends IdBackState {
  final IdBackResponse idBackResponse;

  IdBackSuccess({this.idBackResponse});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'IdBackSuccess { }';
}

class IdBackFailed extends IdBackState {
  final String resDesc;

  IdBackFailed({
    this.resDesc,
  });

  @override
  List<Object> get props => [resDesc];

  @override
  String toString() => 'IdBackFailed { resDesc: $resDesc }';
}
