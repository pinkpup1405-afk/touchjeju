import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/currency.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/cart_provider.dart';

/// 주문 바 "펼치기" 상태에서 보여주는 담긴 상품 목록. 다크 배경 전용 배색.
class CartItemsList extends ConsumerWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    if (items.isEmpty) {
      return const Center(
        child: Text('담긴 상품이 없어요', style: TextStyle(fontSize: 16, color: Colors.white54)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.white24),
      itemBuilder: (context, index) => _CartItemTile(item: items[index]),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                if (item.optionsSummary != null)
                  Text(
                    item.optionsSummary!,
                    style: const TextStyle(fontSize: 13, color: Colors.white54),
                  ),
                Text(formatWon(item.subtotal), style: const TextStyle(fontSize: 15, color: Colors.white70)),
              ],
            ),
          ),
          _StepperButton(icon: Icons.remove, onTap: () => notifier.decrementQuantity(item.cartKey)),
          SizedBox(
            width: 32,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
          _StepperButton(icon: Icons.add, onTap: () => notifier.incrementQuantity(item.cartKey)),
          IconButton(
            onPressed: () => notifier.removeItem(item.cartKey),
            icon: const Icon(Icons.delete_outline, color: Colors.white54),
            tooltip: '삭제',
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(backgroundColor: PosColors.chromeLight),
      iconSize: 18,
    );
  }
}
