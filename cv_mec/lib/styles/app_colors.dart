import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Color lightBackgroundColor = dotenv.env["LIGHT_BACKGROUND_COLOR"] != null ? Color(int.parse(dotenv.env["LIGHT_BACKGROUND_COLOR"]!)) : const Color(0xFFFFFFFF);
Color darkBackgroundColor = dotenv.env["DARK_BACKGROUND_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_BACKGROUND_COLOR"]!)) : const Color(0xFF000000);

Color primaryColor = dotenv.env["PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["PRIMARY_COLOR"]!)) : const Color.fromARGB(255, 102, 186, 255);
Color darkPrimaryColor = dotenv.env["DARK_PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_PRIMARY_COLOR"]!)) : const Color.fromARGB(255, 0, 87, 157);

Color selectedColor = dotenv.env["SELECTED_COLOR"] != null ? Color(int.parse(dotenv.env["SELECTED_COLOR"]!)) : const Color.fromARGB(255, 164, 214, 255);
Color darkSelectedColor = dotenv.env["DARK_SELECTED_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_SELECTED_COLOR"]!)) : const Color.fromARGB(255, 0, 63, 114);
Color disabledColor = dotenv.env["DISABLED_COLOR"] != null ? Color(int.parse(dotenv.env["DISABLED_COLOR"]!)) : const Color(0xFF868686);
Color darkDisabledColor = dotenv.env["DARK_DISABLED_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_DISABLED_COLOR"]!)) : const Color(0xFF333333);

Color textPrimaryColor = dotenv.env["TEXT_PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["TEXT_PRIMARY_COLOR"]!)) : const Color(0xFF000000);
Color darkTextPrimaryColor = dotenv.env["DARK_TEXT_PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_TEXT_PRIMARY_COLOR"]!)) : const Color(0xFFFFFFFF);
Color textSecondaryColor = dotenv.env["TEXT_SECONDARY_COLOR"] != null ? Color(int.parse(dotenv.env["TEXT_SECONDARY_COLOR"]!)) : const Color(0xFF868686);
Color darkTextSecondaryColor = dotenv.env["DARK_TEXT_SECONDARY_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_TEXT_SECONDARY_COLOR"]!)) : const Color.fromARGB(255, 202, 202, 202);

Color primaryTransparentColor = dotenv.env["PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["PRIMARY_COLOR"]!)).withValues(alpha: 0.5) : const Color.fromARGB(128, 102, 186, 255);
Color darkPrimaryTransparentColor = dotenv.env["DARK_PRIMARY_COLOR"] != null ? Color(int.parse(dotenv.env["DARK_PRIMARY_COLOR"]!)).withValues(alpha: 0.5) : const Color.fromARGB(128, 0, 87, 157);

Color lightGrey = dotenv.env["LIGHT_GREY"] != null ? Color(int.parse(dotenv.env["LIGHT_GREY"]!)) : const Color.fromARGB(255, 211, 211, 211);
Color mediumGrey = dotenv.env["MEDIUM_GREY"] != null ? Color(int.parse(dotenv.env["MEDIUM_GREY"]!)) : const Color.fromARGB(255, 137, 137, 137);
Color darkGrey = dotenv.env["DARK_GREY"] != null ? Color(int.parse(dotenv.env["DARK_GREY"]!)) : const Color.fromARGB(255, 54, 54, 54);
