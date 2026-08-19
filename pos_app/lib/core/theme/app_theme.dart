import 'package:flutter/material.dart';

/// Figma 디자인("메인화면 케이크할인 세트 포팅")의 컬러값 그대로.
class PosColors {
  PosColors._();

  static const chrome = Color(0xFF3E3A39);
  static const chromeLight = Color(0xFF494949);
  static const textOnChrome = Colors.white;
  static const textDark = Color(0xFF3E3A39);
  static const productName = Color(0xFF515151);
  static const cardBorder = Color(0xFFDCDCDC);
  static const danger = Color(0xFFED1925);
  static const pageBackground = Color(0xFFE6E6E6);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: PosColors.chrome),
      scaffoldBackgroundColor: PosColors.pageBackground,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: Colors.black87, displayColor: Colors.black87),
    );
  }
}
