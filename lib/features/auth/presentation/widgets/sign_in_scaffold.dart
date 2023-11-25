import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/v_button.dart';
import '../../../../style/style.dart';
import '../../shared/providers.dart';
import 'sign_in_form.dart';
import 'versioning_widget.dart';

class SignInScaffold extends HookConsumerWidget {
  const SignInScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isBlacklist = ref.watch(blacklistNotifierProvider);
    // log('isBlacklist $isBlacklist');
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: !isDarkMode
            ? AppBar(
                backgroundColor: Palette.primaryColor,
                title: const Text('Sign In',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                elevation: 1,
              )
            : AppBar(
                backgroundColor: Colors.black,
                title: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                elevation: 1,
              ),
        body: Stack(
          children: [
            // Image.asset()
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.primaryContainer),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masuk ke Akun Sentra Teknik',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Palette.primaryColor),
                    ),
                    const Text(
                      'Cek Inventoris Sentra Teknik dengan Sentra Mobile !',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Palette.primaryColor),
                    ),
                    const SizedBox(height: 24),
                    const SignInForm(),
                    const SizedBox(height: 8),
                    VButton(
                      width: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        await ref
                            .read(signInFormNotifierProvider.notifier)
                            .signInWithEmailAndPassword();
                      },
                      label: 'Sign In',
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: VersioningWidget(
                fontSize: 10,
                gitFontSize: 8,
              ),
            )
          ],
        ),
      ),
    );
  }
}
