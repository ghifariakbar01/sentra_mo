import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../l10n/l10n.dart';
import '../../../../style/style.dart';
import '../../shared/providers.dart';

class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final showErrorMessages = ref.watch(
      signInFormNotifierProvider.select((state) => state.showErrorMessages),
    );

    return Form(
      autovalidateMode: showErrorMessages
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          TextFormField(
            key: const Key('userID'),
            decoration: Themes.formStyle(hint: 'User ID'),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => ref
                .read(signInFormNotifierProvider.notifier)
                .changeEmail(value),
            validator: (_) =>
                ref.read(signInFormNotifierProvider).userId.value.fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => l10n.validEmailVerificationText,
                        empty: (_) => l10n.emptyStringVerificationText,
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: Themes.formStyle(
                hint: 'Password', icon: const Icon(Icons.lock)),
            obscureText: true,
            onChanged: (value) => ref
                .read(signInFormNotifierProvider.notifier)
                .changePassword(value),
            validator: (_) => ref
                .read(signInFormNotifierProvider)
                .password
                .value
                .fold(
                  (f) => f.maybeMap(
                    shortPassword: (_) => l10n.shortPasswordVerificationText,
                    orElse: () => null,
                  ),
                  (_) => null,
                ),
          ),
        ],
      ),
    );
  }
}
