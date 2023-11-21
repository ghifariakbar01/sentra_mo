import 'package:flutter/material.dart';

import '../../../../style/style.dart';

class VButton extends StatelessWidget {
  const VButton({
    super.key,
    this.isEnabled,
    this.color,
    this.height,
    this.textAlign,
    this.fontSize,
    this.textStyle,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final Color? color;
  final double? height;
  final bool? isEnabled;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return isEnabled ?? true
        ? TextButton(
            onPressed: onPressed,
            child: Container(
              height: height ?? 50,
              width: 200,
              decoration: BoxDecoration(
                  color: color ?? Palette.primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(label,
                    style: textStyle ??
                        Themes.custom(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize ?? 12,
                        ),
                    textAlign: textAlign ?? TextAlign.start),
              ),
            ),
          )
        : TextButton(
            onPressed: () {},
            child: Container(
                height: height ?? 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Palette.greyDisabled,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    label,
                    style: textStyle ??
                        Themes.custom(
                          color: Palette.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize ?? 12,
                        ),
                    textAlign: textAlign ?? TextAlign.start,
                  ),
                )),
          );
  }
}
