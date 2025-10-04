import 'package:flutter/material.dart';

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF9C6ADE), // tím dịu
    brightness: Brightness.dark,              // nền tối cho ảnh nổi
  );
  return base.copyWith(
    cardTheme: const CardThemeData(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      elevation: 3,
    ),
  );
}
