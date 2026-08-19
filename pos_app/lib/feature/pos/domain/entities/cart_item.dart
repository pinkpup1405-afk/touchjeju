import 'product.dart';
import 'product_option.dart';

/// 주문(연습) 화면에 담긴 한 줄. 결제 완료 시 order_items 스냅샷으로 저장될 형태와
/// 동일한 필드(productName, price)를 갖도록 맞춰둔다.
class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    this.selectedOptions = const [],
  });

  final Product product;
  final int quantity;
  final List<SelectedOption> selectedOptions;

  /// 상품id + 선택 옵션 조합이 같아야 장바구니에서 같은 줄로 합쳐진다.
  String get cartKey =>
      '${product.id}::${selectedOptions.map((o) => o.choice.id).join(',')}';

  int get unitPrice =>
      product.price + selectedOptions.fold<int>(0, (sum, o) => sum + o.choice.priceDelta);

  int get subtotal => unitPrice * quantity;

  String? get optionsSummary =>
      selectedOptions.isEmpty ? null : selectedOptions.map((o) => o.choice.label).join(', ');

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions,
    );
  }
}
