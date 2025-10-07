import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class RangeInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  RangeInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If empty, allow (so user can delete text)
    if (newValue.text.isEmpty) return newValue;

    final value = int.tryParse(newValue.text);
    if (value == null) return oldValue; // Invalid number — reject

    // Enforce range: 1–100
    if (value < min || value > max) {
      return oldValue; // Revert to last valid value
    }
    return newValue;
  }
}