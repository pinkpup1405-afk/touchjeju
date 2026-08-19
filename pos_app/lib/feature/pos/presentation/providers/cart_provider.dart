import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_option.dart';

/// 현재 주문(연습) 장바구니. 1단계는 메모리에만 존재하며 앱 재시작 시 소멸된다.
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => const [];

  void addProduct(Product product, {List<SelectedOption> options = const []}) {
    final newItem = CartItem(product: product, quantity: 1, selectedOptions: options);
    final index = state.indexWhere((item) => item.cartKey == newItem.cartKey);
    if (index == -1) {
      state = [...state, newItem];
      return;
    }
    state = [
      for (final item in state)
        if (item.cartKey == newItem.cartKey) item.copyWith(quantity: item.quantity + 1) else item,
    ];
  }

  void incrementQuantity(String cartKey) {
    state = [
      for (final item in state)
        if (item.cartKey == cartKey) item.copyWith(quantity: item.quantity + 1) else item,
    ];
  }

  void decrementQuantity(String cartKey) {
    final index = state.indexWhere((item) => item.cartKey == cartKey);
    if (index == -1) return;
    final current = state[index];
    if (current.quantity <= 1) {
      removeItem(cartKey);
      return;
    }
    state = [
      for (final item in state)
        if (item.cartKey == cartKey) item.copyWith(quantity: item.quantity - 1) else item,
    ];
  }

  void removeItem(String cartKey) {
    state = state.where((item) => item.cartKey != cartKey).toList();
  }

  void clear() {
    state = const [];
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

final cartTotalProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<int>(0, (sum, item) => sum + item.subtotal);
});

final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<int>(0, (sum, item) => sum + item.quantity);
});
