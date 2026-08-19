import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_provider.dart';
import '../providers/order_type_provider.dart';

class PaymentCompleteScreen extends ConsumerWidget {
  const PaymentCompleteScreen({super.key, required this.methodLabel});

  final String methodLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 120),
                const SizedBox(height: 32),
                const Text(
                  '결제가 완료되었어요',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  '$methodLabel · 연습용 화면입니다',
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(cartProvider.notifier).clear();
                      ref.read(orderTypeProvider.notifier).state = null;
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('처음으로'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
