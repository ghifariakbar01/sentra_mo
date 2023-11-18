import 'dart:developer';

import 'package:http_interceptor/http_interceptor.dart';

import '../auth_repository.dart';

class HeaderInterceptor implements InterceptorContract {
  final AuthRepository _repository;

  HeaderInterceptor(this._repository);

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final token = await _repository.getSignedInCredentials();

    log('[interceptRequest] HEADER IS $token');

    try {
      request.headers.addAll({
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive',
      });
    } catch (e) {
      log('HEADER INTERCEPTOR: $e');
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }
}
