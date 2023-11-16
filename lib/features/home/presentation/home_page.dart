import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/application/sign_out/sign_out_notifier.dart';
import '../../auth/shared/providers.dart';
import '../../core/presentation/widgets/alert_helper.dart';
import '../../core/presentation/widgets/loading_overlay.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignOutState>(
      signOutNotifierProvider,
      (_, state) => state.maybeWhen(
        orElse: () => null,
        success: () =>
            ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus(),
        failure: (failure) => AlertHelper.showSnackBar(
          context,
          message: failure.map(
            storage: (_) => 'Error Storage',
            server: (value) => value.message ?? 'Error Server',
            noConnection: (_) => 'No Connection',
          ),
        ),
      ),
    );

    final signOutState = ref.watch(signOutNotifierProvider);

    return Stack(
      children: [
        // const HomeScaffold(),
        LoadingOverlay(
          isLoading: signOutState.maybeWhen(
            inProgress: () => true,
            orElse: () => false,
          ),
        ),
      ],
    );
  }
}
