import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../core/infrastructure/exceptions.dart';
import '../domain/auth_failure.dart';
import '../domain/value_objects.dart';
import 'auth_remote_service.dart';
import 'credentials_storage/credentials_storage.dart';

class AuthRepository {
  AuthRepository(
    this._credentialsStorage,
    this._credentialsStorageRefresh,
    this._remoteService,
  );

  final CredentialsStorage _credentialsStorage;
  final CredentialsStorage _credentialsStorageRefresh;

  final AuthRemoteService _remoteService;

  Future<bool> isSignedIn() =>
      getSignedInCredentials().then((credentials) => credentials != null);

  Future<Either<AuthFailure, Unit>> signOut() => clearCredentialsStorage();

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required UserId userId,
    required Password password,
  }) async {
    try {
      final userIdStr = userId.getOrCrash();
      final passwordStr = password.getOrCrash();

      final authResponse = await _remoteService.signIn(
        userId: userIdStr,
        password: passwordStr,
      );

      return authResponse.when(
        withToken: (token, refreshToken) async {
          await _credentialsStorage.save(token);
          await _credentialsStorageRefresh.save(refreshToken);

          return right(unit);
        },
        failure: (errorCode, message) => left(AuthFailure.server(
          errorCode,
          message,
        )),
      );
    } on RestApiException catch (e) {
      return left(AuthFailure.server(e.errorCode));
    } on NoConnectionException {
      return left(const AuthFailure.noConnection());
    }
  }

  Future<Either<AuthFailure, Unit>> refreshToken(
      {required Map<String, String> headers}) async {
    try {
      final refresh = await getRefreshCredentials();

      if (refresh != null) {
        log('refresh is $refresh');

        final authResponse =
            await _remoteService.refreshToken(token: refresh, headers: headers);

        return authResponse.when(
          withToken: (token, refreshToken) async {
            await _credentialsStorage.save(token);
            await _credentialsStorageRefresh.save(refreshToken);

            return right(unit);
          },
          failure: (errorCode, message) => left(AuthFailure.server(
            errorCode,
            message,
          )),
        );
      } else {
        debugger(message: 'called');

        return left(const AuthFailure.storage());
      }
    } on RestApiException catch (e) {
      debugger(message: 'called');

      return left(AuthFailure.server(e.errorCode));
    } on NoConnectionException {
      debugger(message: 'called');

      return left(const AuthFailure.noConnection());
    }
  }

  Future<String?> getSignedInCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();

      return storedCredentials;
    } on PlatformException {
      return null;
    }
  }

  Future<String?> getRefreshCredentials() async {
    try {
      final storedCredentials = await _credentialsStorageRefresh.read();

      return storedCredentials;
    } on PlatformException {
      return null;
    }
  }

  Future<Either<AuthFailure, Unit>> clearCredentialsStorage() async {
    try {
      await _credentialsStorage.clear();
      await _credentialsStorageRefresh.clear();

      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }
}
