import 'dart:developer';

import 'package:http_interceptor/http_interceptor.dart';

import '../auth_repository.dart';

class ExpiredTokenInterceptor extends RetryPolicy {
  final AuthRepository repository;
  final Future<void> Function() signOut;
  final Future<void> Function() signOutWithoutBlacklist;
  final Future<void> Function() getNewlyUpdatedToken;

  ExpiredTokenInterceptor({
    required this.repository,
    required this.signOut,
    required this.signOutWithoutBlacklist,
    required this.getNewlyUpdatedToken,
  });

  @override
  Future<bool> shouldAttemptRetryOnException(
      Exception reason, BaseRequest request) {
    log('response.statusCode shouldAttemptRetryOnException reason.runtimeType ${reason.runtimeType}');

    if (reason.runtimeType is ClientException) {
      return Future.value(true);
    }

    return Future.value(false);
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    log('response.statusCode shouldAttemptRetryOnResponse ${response.statusCode}');

    if (response.statusCode == 401) {
      final token = await repository.getSignedInCredentials();

      // If a 401 response is received, refresh the access token with refreshToken
      final tokenEither = await repository.refreshToken(headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive',
      });

      // Get newly saved access token
      await tokenEither.fold((error) {
        log('EXPIRED INTERCEPTOR: $error');

        error.maybeWhen(
            server: (errorCode, message) async {
              log('EXPIRED INTERCEPTOR CODE: $errorCode $error');

              final isBlacklist = errorCode == 403;
              final isInvalid = errorCode == 401;

              if (isBlacklist) {
                await signOut();

                return false;
              }

              if (isInvalid) {
                await signOutWithoutBlacklist();

                return false;
              }
            },
            orElse: () => true);
      }, (_) async {
        final newCredentials = await repository.getSignedInCredentials();

        if (newCredentials != null) {
          log('BEARER NEW: $newCredentials');

          // Repeat the request with the updated header

          await getNewlyUpdatedToken();

          return false;
        } else {
          // If error during refresh token

          await getNewlyUpdatedToken();

          return true;
        }
      });

      // If error during refresh token
      return true;
    }

    return false;
  }
}
