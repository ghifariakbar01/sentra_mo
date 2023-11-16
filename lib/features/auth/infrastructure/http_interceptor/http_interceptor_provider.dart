import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../shared/providers.dart';
import 'expired_token_interceptor.dart';
import 'header_interceptor.dart';

// HTTP Interceptor Providers

final retryInterceptorProvider = Provider((ref) => ExpiredTokenInterceptor(
    repository: ref.watch(authRepositoryProvider),
    signOut: () async {
      await ref.read(signOutNotifierProvider.notifier).signOut();
      await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();

      // await ref.read(blacklistNotifierProvider.notifier).blacklist();
      // await ref
      //     .read(blacklistNotifierProvider.notifier)
      //     .checkAndUpdateBlacklistStatus();
    },
    signOutWithoutBlacklist: () async {
      await ref.read(signOutNotifierProvider.notifier).signOut();
      await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
    },
    getNewlyUpdatedToken: () =>
        ref.read(tokenNotifierProvider.notifier).checkAndUpdateTokenStatus()));

final headerInterceptorProvider = Provider((ref) => HeaderInterceptor(
      ref.watch(
        authRepositoryProvider,
      ),
    ));

final httpProvider = Provider<InterceptedClient>((ref) {
  final interceptor = ref.watch(headerInterceptorProvider);
  final retryInterceptor = ref.watch(retryInterceptorProvider);

  return InterceptedClient.build(
      interceptors: [interceptor], retryPolicy: retryInterceptor);
});
