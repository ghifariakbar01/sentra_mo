import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';
import '../../shared/providers.dart';

class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            decoration: Themes.formStyle('User ID',
                color: Theme.of(context).colorScheme.tertiary,
                icon: const Icon(Icons.person)),
            style: Themes.greyHint(FontWeight.normal, 14,
                color: Theme.of(context).colorScheme.tertiary),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => ref
                .read(signInFormNotifierProvider.notifier)
                .changeEmail(value),
            validator: (_) =>
                ref.read(signInFormNotifierProvider).userId.value.fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => 'Invalid Email',
                        empty: (_) => 'Empty',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            // style: TextStyle(
            //     color: Theme.of(context).colorScheme.tertiary,
            //     fontSize: 14,
            //     fontWeight: FontWeight.normal),
            decoration: Themes.formStyle('Password',
                color: Theme.of(context).colorScheme.tertiary,
                icon: const Icon(Icons.lock)),
            style: Themes.greyHint(FontWeight.normal, 14,
                color: Theme.of(context).colorScheme.tertiary),
            obscureText: true,
            onChanged: (value) => ref
                .read(signInFormNotifierProvider.notifier)
                .changePassword(value),
            validator: (_) =>
                ref.read(signInFormNotifierProvider).password.value.fold(
                      (f) => f.maybeMap(
                        shortPassword: (_) => 'Password Short',
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
