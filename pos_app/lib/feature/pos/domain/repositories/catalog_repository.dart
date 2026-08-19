import '../entities/category.dart';
import '../entities/product.dart';

/// 2단계에서 SupabaseCatalogRepository로 교체된다.
/// Controller/UseCase는 이 인터페이스만 알아야 한다.
abstract interface class CatalogRepository {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProducts();
}
