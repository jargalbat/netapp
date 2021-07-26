import 'package:equatable/equatable.dart';
import 'package:netware/modules/sign_up/step3_id_selfie/api/id_selfie_response.dart';

abstract class IdSelfieState extends Equatable {
  const IdSelfieState();

  @override
  List<Object> get props => [];
}

class IdSelfieInit extends IdSelfieState {}

class IdSelfieLoading extends IdSelfieState {}

class IdSelfieSuccess extends IdSelfieState {
  final IdSelfieResponse idSelfieResponse;

  IdSelfieSuccess({this.idSelfieResponse});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'IdSelfieSuccess { }';
}

class IdSelfieFailed extends IdSelfieState {
  final String resDesc;

  IdSelfieFailed({
    this.resDesc,
  });

  @override
  List<Object> get props => [resDesc];

  @override
  String toString() => 'IdSelfieFailed { resDesc: $resDesc }';
}
