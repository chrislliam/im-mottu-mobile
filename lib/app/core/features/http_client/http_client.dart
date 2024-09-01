import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/constants.dart';

abstract interface class HttpClient {
  Future<Response> get(
    String path, {
    Map<String, dynamic> body,
    Map<String, dynamic> queryParameters,
  });
}

class DioHttpClient extends HttpClient {
  Dio get _dio => Dio(baseOptions);

  @override
  Future<Response> get(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = _generateHash(timestamp);

    final finalQueryParameters = {
      'ts': timestamp,
      'apikey': Constants.publicKey,
      'hash': hash,
      ...?queryParameters,
    };

    return _requestHandler(
        request: () async => await _dio.get(
              path,
              queryParameters: finalQueryParameters,
              data: body,
            ));
  }

  Future<Response> _requestHandler({required RequestCallback request}) async {
    try {
      final result = await request();
      return result;
    } on DioException {
      rethrow;
    } catch (exception) {
      rethrow;
    }
  }

  Map<String, dynamic> get _getHeaders {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  @mustCallSuper
  BaseOptions get baseOptions => BaseOptions(
        responseDecoder: (response, request, responseBody) {
          if (responseBody.statusCode > 299) {
            if (kDebugMode) print(utf8.decode(response));
          }

          return utf8.decode(response);
        },
        validateStatus: (statusCode) => statusCode! < 600,
        headers: _getHeaders,
        receiveTimeout: const Duration(milliseconds: 15000),
        sendTimeout: const Duration(milliseconds: 3000),
        baseUrl: Constants.baseUrl,
      );
}

/// A type definition for a request callback function.
typedef RequestCallback = Future<Response> Function();

String _generateHash(String timestamp) {
  final hash = md5
      .convert(utf8
          .encode('$timestamp${Constants.privateKey}${Constants.publicKey}'))
      .toString();
  return hash;
}
