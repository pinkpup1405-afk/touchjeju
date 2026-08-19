/// 옵션 그룹 하나 안에서는 단일 선택(라디오)만 지원한다 (Figma 옵션 선택 모달 기준).
class ProductOptionChoice {
  const ProductOptionChoice({
    required this.id,
    required this.label,
    this.priceDelta = 0,
  });

  final String id;
  final String label;
  final int priceDelta;
}

class ProductOptionGroup {
  const ProductOptionGroup({
    required this.id,
    required this.title,
    required this.choices,
    required this.defaultChoiceId,
  });

  final String id;
  final String title;
  final List<ProductOptionChoice> choices;
  final String defaultChoiceId;

  ProductOptionChoice get defaultChoice =>
      choices.firstWhere((choice) => choice.id == defaultChoiceId, orElse: () => choices.first);
}

/// 사용자가 옵션 모달에서 그룹별로 실제 고른 선택지 스냅샷.
class SelectedOption {
  const SelectedOption({
    required this.groupTitle,
    required this.choice,
  });

  final String groupTitle;
  final ProductOptionChoice choice;
}
