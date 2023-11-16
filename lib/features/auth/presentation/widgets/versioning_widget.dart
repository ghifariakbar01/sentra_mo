import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';
import '../../shared/providers.dart';

class VersioningWidget extends ConsumerWidget {
  const VersioningWidget({
    super.key,
    this.color,
    this.fontSize,
    this.gitFontSize,
  });

  final Color? color;
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
                  style: Themes.custom(
                      color: color ?? const Color(0xff999999),
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize ?? 20),
                ),
            error: (error, stack) => Text('error $error $stack'),
            loading: Container.new),
        // FutureBuilder<String>(
        //   future: getGitInfo(),
        //   builder: (context, snapshot) {
        //     return Center(
        //       child: Text(
        //         snapshot.data ?? '',
        //         style: Themes.custom(
        //             color: color ?? const Color(0xff999999),
        //             fontWeight: FontWeight.normal,
        //             fontSize: gitFontSize ?? 15),
        //         textAlign: TextAlign.center,
        //       ),
        //     );
        //   },
        // )
      ],
    );
  }

  // Future<String> getGitInfo() async {
  //   final head = await rootBundle.loadString('.git/HEAD');
  //   final commitId = await rootBundle.loadString('.git/ORIG_HEAD');

  //   final branch = head.split('/').last;

  //   return commitId.substring(0, 7);
  // }
}
