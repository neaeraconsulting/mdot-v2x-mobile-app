import 'package:auto_size_text_pro/auto_size_text_pro.dart';
import 'package:flutter/material.dart';

class AutoSizeTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow? overflow;
  final int minFontSize;

  const AutoSizeTextWidget({
    Key? key,
    required this.text,
    this.style,
    this.maxLines = 1,
    this.overflow,
    this.minFontSize = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // When iOS "Bold Text" is on, words render wider. Lower the minimum
    // font size so AutoSizeText has more room to shrink and fit without
    // wrapping or clipping.
    final bool boldText = MediaQuery.boldTextOf(context);

    return AutoSizeText(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      wrapWords: boldText ? true : false,
      maxFontSize: boldText ? (style!.fontSize! * 0.6).toInt().toDouble() : double.infinity,
      minFontSize: minFontSize.toDouble(),
    );
  }
}
