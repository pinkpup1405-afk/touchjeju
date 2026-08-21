import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'feature/pos/presentation/screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: PosApp()));
}

/// 실제 매장 키오스크/폰 규격을 흉내내는 고정 크기 화면. 반응형으로 늘어나지 않고
/// 브라우저 중앙에 고정 사이즈로만 표시한다.
/// Figma 원본 디자인 프레임(1080x1920, 9:16)과 동일한 비율.
const _deviceSize = Size(414, 736);

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS 연습',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) => _DeviceFrame(child: child),
      home: const SplashScreen(),
    );
  }
}

class _DeviceFrame extends StatelessWidget {
  const _DeviceFrame({required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF1B1B1B),
      child: Center(
        // OverflowBox forces the exact device pixel size regardless of the
        // browser window size, instead of Center's loosened constraints
        // silently shrinking the frame to fit a smaller viewport.
        child: OverflowBox(
          minWidth: _deviceSize.width,
          maxWidth: _deviceSize.width,
          minHeight: _deviceSize.height,
          maxHeight: _deviceSize.height,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 24, spreadRadius: 2)],
            ),
            child: MediaQuery(
              data: MediaQueryData(size: _deviceSize),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
