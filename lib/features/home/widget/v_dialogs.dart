import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';

Future<void> showVAlertDialog({
  required String label,
  required BuildContext context,
  required String labelDescription,
  required Future<void> Function() onPressed,
  //
  final String? pressedLabel,
  final String? backPressedLabel,
}) async {
  return showDialog(
    context: context,
    builder: (_) => VAlertDialog(
      label: label,
      onPressed: onPressed,
      pressedLabel: pressedLabel,
      backPressedLabel: backPressedLabel,
      labelDescription: labelDescription,
    ),
  );
}

class VAlertDialog extends ConsumerWidget {
  const VAlertDialog({
    super.key,
    required this.label,
    required this.labelDescription,
    required this.onPressed,
    this.onBackPressed,
    this.backPressedLabel,
    this.pressedLabel,
  });

  final String label;
  final String labelDescription;
  final String? backPressedLabel;
  final String? pressedLabel;

  final Future<void> Function() onPressed;
  final Future<void> Function()? onBackPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: AlertDialog(
        backgroundColor: Palette.primaryColor,
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.spaceAround,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          labelDescription,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: Text(
              pressedLabel ?? 'YA',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          TextButton(
            onPressed: onBackPressed ?? () => context.pop(),
            child: Text(
              backPressedLabel ?? 'TIDAK',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
