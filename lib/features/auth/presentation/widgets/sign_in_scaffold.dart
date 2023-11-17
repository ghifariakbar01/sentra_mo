import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/assets.dart';

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

    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign In',
            style: Themes.custom(fontSize: 20),
          ),
          elevation: 1,
        ),
        backgroundColor: Palette.primaryColor,
        body: Stack(
          children: [
            // Image.asset()
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Masuk ke Akun Sentra Teknik',
                      style: Themes.custom(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Palette.primaryColor),
                    ),
                    Text(
                      'Cek Inventoris Sentra Teknik dengan Sentra Teknik Mobile !',
                      style: Themes.custom(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Palette.primaryColor),
                    ),
                    const SizedBox(height: 24),
                    const SignInForm(),
                    const SizedBox(height: 8),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Palette.primaryColor),
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          ref
                              .read(signInFormNotifierProvider.notifier)
                              .signInWithEmailAndPassword();
                        },
                        child: Text(
                          'Sign In',
                          style: Themes.custom(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: VersioningWidget(
                color: Palette.secondaryTextColor,
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
