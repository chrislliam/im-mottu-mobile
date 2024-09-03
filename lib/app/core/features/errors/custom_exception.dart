import 'package:flutter/foundation.dart';

class CustomException implements Exception {
  final String _message;
  final int? code;

  CustomException(this._message, this.code);

  String get message => errorMessage;

  String get errorMessage {
    if (code == null && kReleaseMode) {
      return 'Erro desconhecido';
    } else {
      return _message;
    }
  }
}
