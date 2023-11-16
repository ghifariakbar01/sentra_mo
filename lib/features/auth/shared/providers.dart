import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/application/routes/route_notifier.dart';

import '../application/auth/auth_notifier.dart';
import '../application/sign_in_form/sign_in_form_notifier.dart';
import '../application/sign_out/sign_out_notifier.dart';
import '../application/token/token_notifier.dart';
import '../infrastructure/auth_remote_service.dart';
import '../infrastructure/auth_repository.dart';
import '../infrastructure/blacklist/blacklist_repository.dart';
import '../infrastructure/blacklist/blacklist_state.dart';
import '../infrastructure/blacklist/blacklist_storage.dart';
import '../infrastructure/credentials_storage/credentials_storage.dart';
import '../infrastructure/credentials_storage/refresh_credentials_refresh_storage.dart';
import '../infrastructure/credentials_storage/secure_credentials_storage.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    redirect: router.redirectLogic,
    refreshListenable: router,
    routes: router.routes,
  );
});

final packageVersionProvider = FutureProvider((ref) async {
  final package = await PackageInfo.fromPlatform();

  return package;
});

final flutterSecureStorageProvider = Provider(
  (ref) => const FlutterSecureStorage(),
);

final credentialsStorageProvider = Provider<CredentialsStorage>(
  (ref) => SecureCredentialsStorage(ref.watch(flutterSecureStorageProvider)),
);

final refreshStorageProvider = Provider<CredentialsStorage>(
  (ref) => RefreshCredentialsStorage(ref.watch(flutterSecureStorageProvider)),
);

final authRemoteServiceProvider = Provider(
  (ref) => AuthRemoteService(),
);

final blacklistStorageProvider = Provider<CredentialsStorage>(
    (ref) => BlacklistStorage(ref.watch(flutterSecureStorageProvider)));

final blacklistRepositoryProvider =
    Provider((ref) => BlacklistRepository(ref.watch(blacklistStorageProvider)));

final authRepositoryProvider = Provider((ref) => AuthRepository(
    ref.watch(credentialsStorageProvider),
    ref.watch(refreshStorageProvider),
    ref.watch(authRemoteServiceProvider)));

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authRepositoryProvider)),
);

final tokenNotifierProvider = StateNotifierProvider<TokenNotifier, TokenState>(
  (ref) => TokenNotifier(ref.watch(authRepositoryProvider)),
);

final signInFormNotifierProvider =
    StateNotifierProvider.autoDispose<SignInFormNotifier, SignInFormState>(
  (ref) => SignInFormNotifier(ref.watch(authRepositoryProvider)),
);

final signOutNotifierProvider =
    StateNotifierProvider<SignOutNotifier, SignOutState>(
  (ref) => SignOutNotifier(ref.watch(authRepositoryProvider)),
);
