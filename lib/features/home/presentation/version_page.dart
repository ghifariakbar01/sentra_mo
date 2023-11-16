import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';
import '../../auth/presentation/widgets/versioning_widget.dart';

class VersionPage extends ConsumerWidget {
  const VersionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Palette.primaryColor),
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 200,
                child: Image.asset('assets/images/splash_logo.png'),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const VersioningWidget(),
          ],
        ));
  }
}
