import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Color lightBackgroundColor = dotenv.env["LIGHT_BACKGROUND_COLOR"] != null ? Color(int.parse(dotenv.env["LIGHT_BACKGROUND_COLOR"]!)) : const Color(0xFFF0F3F7);
Color darkBackgroundColor = dotenv.env["DARK_BACKGROUND_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_BACKGROUND_COLOR"]!)) : const Color(0xFF010E1F);

Color primaryColor = dotenv.env["PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["PRIMARY_COLOR"]!)) : const Color(0xFF0F2F76);
Color darkPrimaryColor = dotenv.env["DARK_PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_PRIMARY_COLOR"]!)) : const Color(0xFF0F2F76);

Color selectedColor = dotenv.env["SELECTED_COLOR"] != null ? Color(int.parse(dotenv.env["SELECTED_COLOR"]!)) : const Color(0xFF2D4A8A);
Color darkSelectedColor = dotenv.env["DARK_SELECTED_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_SELECTED_COLOR"]!)) : const Color(0xFF2D4A8A);
Color disabledColor = dotenv.env["DISABLED_COLOR"] != null ? Color(int.parse(dotenv.env["DISABLED_COLOR"]!)) : const Color(0xFF868686);
Color darkDisabledColor = dotenv.env["DARK_DISABLED_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_DISABLED_COLOR"]!)) : const Color(0xFF333333);

Color textPrimaryColor = dotenv.env["TEXT_PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["TEXT_PRIMARY_COLOR"]!)) : const Color(0xFF000000);
Color darkTextPrimaryColor = dotenv.env["DARK_TEXT_PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_TEXT_PRIMARY_COLOR"]!)) : const Color(0xFFFFFFFF);

Color primaryTransparentColor = dotenv.env["PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["PRIMARY_COLOR"]!)).withValues(alpha: 0.5) : const Color(0xFF2D4A8A).withValues(alpha: 0.5);
Color darkPrimaryTransparentColor = dotenv.env["DARK_PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_PRIMARY_COLOR"]!)).withValues(alpha: 0.5) : const Color(0xFF2D4A8A).withValues(alpha: 0.5);

Color lightGrey = dotenv.env["LIGHT_GREY"] != null ? Color(int.parse(dotenv.env["LIGHT_GREY"]!)) : const Color(0xFFD1D7E0);
Color mediumGrey = dotenv.env["MEDIUM_GREY"] != null ? Color(int.parse(dotenv.env["MEDIUM_GREY"]!)) : const Color(0xFF909EB0);
Color darkGrey = dotenv.env["DARK_GREY"] != null ? Color(int.parse(dotenv.env["DARK_GREY"]!)) : const Color(0xFF4B5D75);
