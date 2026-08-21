import 'package:flutter/material.dart';

import 'order_type_screen.dart';

/// Figma "1 메인화면" — 매장 브랜딩 풀스크린 이미지. 아무 곳이나 탭하면 주문 방법 선택으로 이동.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2D67F),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OrderTypeScreen()),
        ),
        child: SizedBox.expand(
          child: Image.asset('assets/images/splash_poster.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
