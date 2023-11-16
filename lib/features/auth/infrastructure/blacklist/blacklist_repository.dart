import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../domain/auth_failure.dart';
import '../credentials_storage/credentials_storage.dart';

class BlacklistRepository {
  BlacklistRepository(
    this._credentialsStorage,
  );

  final CredentialsStorage _credentialsStorage;

  Future<bool> isBlacklist() =>
      getSignedInCredentials().then((credentials) => credentials != null);

  Future<Either<AuthFailure, Unit>> signOut() {
    return clearCredentialsStorage();
  }

  Future<String?> getSignedInCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();

      return storedCredentials;
    } on PlatformException {
      return null;
    }
  }

  Future<Either<AuthFailure, Unit>> clearCredentialsStorage() async {
    try {
      await _credentialsStorage.clear();

      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<void> save() async {
    await _credentialsStorage.save('${DateTime.now()}');
  }
}
