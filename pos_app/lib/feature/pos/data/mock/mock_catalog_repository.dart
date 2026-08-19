import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_option.dart';
import '../../domain/repositories/catalog_repository.dart';

const _cakeImage = 'assets/images/cake_placeholder.png';

/// 1단계 전용 목데이터 구현체. 2단계에서 SupabaseCatalogRepository로 교체 후 삭제한다.
class MockCatalogRepository implements CatalogRepository {
  static final _categories = <Category>[
    Category(id: 'cake', name: '케이크할인', sortOrder: 0),
    Category(id: 'new_best', name: 'NEW/BEST', sortOrder: 1),
    Category(id: 'set', name: '세트/포팩', sortOrder: 2),
    Category(id: 'coffee', name: '커피', sortOrder: 3),
    Category(id: 'decaf', name: '디카페인', sortOrder: 4),
    Category(id: 'latte', name: '라떼', sortOrder: 5),
    Category(id: 'smoothie', name: '스무디', sortOrder: 6),
    Category(id: 'ade', name: '주스/에이드', sortOrder: 7),
    Category(id: 'tea', name: '제주말차&티', sortOrder: 8),
    Category(id: 'dessert', name: '디저트', sortOrder: 9),
  ];

  static final _hotAmericanoOptions = <ProductOptionGroup>[
    const ProductOptionGroup(
      id: 'temp',
      title: '선택 옵션',
      defaultChoiceId: 'less_hot',
      choices: [
        ProductOptionChoice(id: 'own_tumbler', label: '개인 텀블러 사용(450ml 이상)'),
        ProductOptionChoice(id: 'less_hot', label: '덜 뜨겁게'),
      ],
    ),
    ProductOptionGroup(
      id: 'shot',
      title: '에스프레소 및 휘핑 옵션',
      defaultChoiceId: 'shot_extra_strong',
      choices: const [
        ProductOptionChoice(id: 'shot_extra', label: '1샷 추가', priceDelta: 500),
        ProductOptionChoice(id: 'shot_extra_strong', label: '1샷 추가(진하게)', priceDelta: 1000),
        ProductOptionChoice(id: 'shot_less', label: '1샷 빼고'),
      ],
    ),
    const ProductOptionGroup(
      id: 'syrup',
      title: '시럽 옵션',
      defaultChoiceId: 'hazelnut',
      choices: [
        ProductOptionChoice(id: 'hazelnut', label: '헤이즐넛시럽추가(2펌프)', priceDelta: 500),
      ],
    ),
    const ProductOptionGroup(
      id: 'side',
      title: '샐러드&샌드위치&쿠키',
      defaultChoiceId: 'side_none',
      choices: [
        ProductOptionChoice(id: 'side_none', label: '담지 않음'),
        ProductOptionChoice(id: 'side_salad', label: '그릴드 치킨 샐러드', priceDelta: 4900),
        ProductOptionChoice(id: 'side_bbq', label: '제주 흑돼지 BBQ 샌드위치', priceDelta: 3900),
        ProductOptionChoice(id: 'side_egg', label: '반숙에그샌드위치', priceDelta: 3900),
      ],
    ),
  ];

  static final _products = <Product>[
    // 케이크할인
    const Product(
      id: 'cake1',
      categoryId: 'cake',
      name: '클래식 치즈케이크',
      price: 4900,
      imageUrl: _cakeImage,
      description: '진하고 부드러운 치즈 풍미가 느껴지는 클래식 케이크',
      isActive: true,
      sortOrder: 0,
    ),
    const Product(id: 'cake2', categoryId: 'cake', name: '우유크림카스테라', price: 4720, imageUrl: _cakeImage, isActive: true, sortOrder: 1),
    const Product(id: 'cake3', categoryId: 'cake', name: '제주한라산녹차케이크', price: 4900, imageUrl: _cakeImage, isActive: true, sortOrder: 2),
    const Product(id: 'cake4', categoryId: 'cake', name: '오레오크림치즈케이크', price: 4900, imageUrl: _cakeImage, isActive: true, sortOrder: 3),
    const Product(id: 'cake5', categoryId: 'cake', name: '돌체밀크케이크', price: 4900, imageUrl: _cakeImage, isActive: true, sortOrder: 4),
    const Product(id: 'cake6', categoryId: 'cake', name: '초코블로썸케이크', price: 4900, imageUrl: _cakeImage, isActive: true, sortOrder: 5),

    // 커피 (옵션 있는 대표 상품 포함)
    Product(
      id: 'coffee1',
      categoryId: 'coffee',
      name: 'HOT아메리카노',
      price: 3500,
      isActive: true,
      sortOrder: 0,
      optionGroups: _hotAmericanoOptions,
    ),
    const Product(id: 'coffee2', categoryId: 'coffee', name: 'ICE아메리카노', price: 4000, isActive: true, sortOrder: 1),
    const Product(id: 'coffee3', categoryId: 'coffee', name: '카페라떼', price: 4500, isActive: true, sortOrder: 2),

    // 디카페인
    const Product(id: 'decaf1', categoryId: 'decaf', name: '디카페인 아메리카노', price: 4000, isActive: true, sortOrder: 0),

    // 라떼
    const Product(id: 'latte1', categoryId: 'latte', name: '바닐라라떼', price: 5000, isActive: true, sortOrder: 0),
    const Product(id: 'latte2', categoryId: 'latte', name: '카푸치노', price: 5000, isActive: true, sortOrder: 1),

    // 스무디
    const Product(id: 'smoothie1', categoryId: 'smoothie', name: '딸기스무디', price: 5500, isActive: true, sortOrder: 0),

    // 주스/에이드
    const Product(id: 'ade1', categoryId: 'ade', name: '자몽에이드', price: 5000, isActive: true, sortOrder: 0),

    // 제주말차&티
    const Product(id: 'tea1', categoryId: 'tea', name: '제주말차라떼', price: 5500, isActive: true, sortOrder: 0),

    // 디저트
    const Product(id: 'dessert1', categoryId: 'dessert', name: '마카롱', price: 2500, isActive: true, sortOrder: 0),
    const Product(id: 'dessert2', categoryId: 'dessert', name: '초코쿠키', price: 2000, isActive: true, sortOrder: 1),
  ];

  @override
  Future<List<Category>> getCategories() async => List.unmodifiable(_categories);

  @override
  Future<List<Product>> getProducts() async => List.unmodifiable(_products);
}
