import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pos_app/main.dart';

void main() {
  testWidgets('스플래시 → 주문방법 → 메인 주문화면까지 이동한다', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PosApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PosApp));
    await tester.pumpAndSettle();

    expect(find.text('매장'), findsOneWidget);
    expect(find.text('포장'), findsOneWidget);

    await tester.tap(find.text('매장'));
    await tester.pumpAndSettle();

    expect(find.text('케이크할인'), findsOneWidget);
    expect(find.text('클래식 치즈케이크'), findsOneWidget);
  });

  testWidgets('상품을 탭하면 주문 수량이 올라간다', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PosApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PosApp));
    await tester.pumpAndSettle();
    await tester.tap(find.text('매장'));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('클래식 치즈케이크'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });
}
