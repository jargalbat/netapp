import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:netware/modules/sign_up/step1_id_front/api/id_front_response.dart';

abstract class IdFrontEvent extends Equatable {
  const IdFrontEvent();

  @override
  List<Object> get props => [];
}

class IdFrontUploadImage extends IdFrontEvent {
  final File file;

  IdFrontUploadImage({@required this.file});

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'IdFrontUploadImage { }';
}

class IdFrontConfirm extends IdFrontEvent {
  final IdFrontResponse idFrontResponse;

  IdFrontConfirm({@required this.idFrontResponse});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'IdFrontConfirm { }';
}
