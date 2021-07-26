import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class IdBackEvent extends Equatable {
  const IdBackEvent();

  @override
  List<Object> get props => [];
}

class IdBackUploadImage extends IdBackEvent {
  final File file;
  final String userKey;

  IdBackUploadImage({
    @required this.file,
    @required this.userKey,
  });

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'IdBackUploadImage { }';
}
