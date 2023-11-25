import 'package:flutter/material.dart';

import '../../../../style/style.dart';

class VButton extends StatelessWidget {
  const VButton({
    super.key,
    this.isEnabled,
    this.color,
    this.width,
    this.height,
    this.textAlign,
    this.fontSize,
    this.textStyle,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final Color? color;
  final double? width;
  final double? height;
  final bool? isEnabled;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return isEnabled ?? true
        ? TextButton(
            onPressed: onPressed,
            child: Container(
              height: height ?? 50,
              width: width ?? 200,
              decoration: BoxDecoration(
                  color: color ?? Palette.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 1.5),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.3),
                    )
                  ]),
              child: Center(
                child: Text(label,
                    style: textStyle ??
                        TextStyle(
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
                width: width ?? 200,
                decoration: BoxDecoration(
                    color: Palette.greyDisabled,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    label,
                    style: textStyle ??
                        TextStyle(
                          color: Palette.greyDisabled,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize ?? 12,
                        ),
                    textAlign: textAlign ?? TextAlign.start,
                  ),
                )),
          );
  }
}
