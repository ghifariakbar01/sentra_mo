import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/strings.dart';
import '../../../l10n/l10n.dart';
import '../../../style/style.dart';
import '../../auth/shared/providers.dart';

final initializationProvider =
    FutureProvider.family<Unit, BuildContext>((ref, context) async {
  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.checkAndUpdateAuthStatus();

  final tokenNotifier = ref.read(tokenNotifierProvider.notifier);
  await tokenNotifier.checkAndUpdateTokenStatus();

  // final blacklistNotifier = ref.read(blacklistNotifierProvider.notifier);
  // await blacklistNotifier.checkAndUpdateBlacklistStatus();

  return unit;
});

class AppWidget extends HookConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initializationProvider(context), (_, __) {});

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      title: Strings.appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: Themes.lightTheme(context),
      darkTheme: Themes.darkTheme(context),
      themeMode: ThemeMode.light,
    );
  }
}
