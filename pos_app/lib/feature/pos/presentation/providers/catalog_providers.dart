import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/mock_catalog_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/catalog_repository.dart';

/// 2단계에서 이 provider의 override 하나만 SupabaseCatalogRepository로 바꾸면
/// 나머지 provider/화면 코드는 그대로 동작한다.
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return MockCatalogRepository();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categories = await ref.watch(catalogRepositoryProvider).getCategories();
  return [...categories]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
});

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(catalogRepositoryProvider).getProducts();
});

/// 메인 화면 카테고리 그리드에서 첫번째 항목("케이크할인")이 기본 선택된다.
final selectedCategoryIdProvider = StateProvider<String?>((ref) => 'cake');

final productsByCategoryProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider).valueOrNull ?? const [];
  final selectedId = ref.watch(selectedCategoryIdProvider);
  final visible = products.where((p) => p.isActive && p.categoryId == selectedId).toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return visible;
});
