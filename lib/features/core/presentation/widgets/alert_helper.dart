import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../style/style.dart';

class AlertHelper {
  static void showSnackBar(BuildContext context,
      {required String message, Color? color, Function? onDone}) {
    HapticFeedback.vibrate().then((_) => showFlash(
          context: context,
          persistent: true,
          duration: const Duration(seconds: 2),
          // barrierDismissible: true,
          builder: (context, controller) {
            return FlashBar(
              controller: controller,
              backgroundColor: color ?? Palette.red,
              contentTextStyle: Themes.custom(),
              behavior: FlashBehavior.floating,
              content: Text(message),
            );
          },
        ).then((_) => onDone));
  }
}
