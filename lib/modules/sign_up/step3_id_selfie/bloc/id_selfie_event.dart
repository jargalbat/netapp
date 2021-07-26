import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class IdSelfieEvent extends Equatable {
  const IdSelfieEvent();

  @override
  List<Object> get props => [];
}

class IdSelfieUploadImage extends IdSelfieEvent {
  final File file;
  final String userKey;

  IdSelfieUploadImage({
    @required this.file,
    @required this.userKey,
  });

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'IdSelfieUploadImage { }';
}
