import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';

class VersioningWidget extends ConsumerWidget {
  const VersioningWidget({
    super.key,
    this.fontSize,
    this.gitFontSize,
  });

  final double? fontSize;
  final double? gitFontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageVersionProvider);

    return Column(
      children: [
        packageInfo.when(
            data: (version) => Text(
                  'V ${version.version}+${version.buildNumber}',
                  style: TextStyle(
                    fontSize: fontSize ?? 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
            error: (error, stack) => Text('error $error $stack'),
            loading: Container.new),
      ],
    );
  }
}
