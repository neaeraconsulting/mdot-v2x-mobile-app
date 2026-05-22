import 'package:auto_size_text_pro/auto_size_text_pro.dart';
import 'package:flutter/material.dart';

class AutoSizeTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;

  const AutoSizeTextWidget({
    Key? key,
    required this.text,
    this.style,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: style,
      maxLines: maxLines,
    );
  }
}
