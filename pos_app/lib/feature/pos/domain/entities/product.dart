import 'product_option.dart';

class Product {
  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.isActive,
    required this.sortOrder,
    this.imageUrl,
    this.description,
    this.optionGroups = const [],
  });

  final String id;
  final String categoryId;
  final String name;
  final int price;
  final String? imageUrl;
  final String? description;
  final bool isActive;
  final int sortOrder;

  /// 비어있으면 탭 즉시 담기, 값이 있으면 옵션 선택 모달을 먼저 띄운다.
  final List<ProductOptionGroup> optionGroups;

  bool get hasOptions => optionGroups.isNotEmpty;
}
