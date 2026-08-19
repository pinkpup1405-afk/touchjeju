import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/currency.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_option.dart';
import '../providers/cart_provider.dart';

/// Figma "옵션 선택" 모달. 그룹마다 라디오 단일 선택, 하단에 수량/합계/담기.
class OptionSelectDialog extends ConsumerStatefulWidget {
  const OptionSelectDialog({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<OptionSelectDialog> createState() => _OptionSelectDialogState();
}

class _OptionSelectDialogState extends ConsumerState<OptionSelectDialog> {
  late final Map<String, String> _selectedChoiceIdByGroup = {
    for (final group in widget.product.optionGroups) group.id: group.defaultChoiceId,
  };
  int _quantity = 1;

  int get _optionAmount {
    return widget.product.optionGroups.fold<int>(0, (sum, group) {
      final choiceId = _selectedChoiceIdByGroup[group.id];
      final choice = group.choices.firstWhere((c) => c.id == choiceId, orElse: () => group.defaultChoice);
      return sum + choice.priceDelta;
    });
  }

  int get _orderAmount => (widget.product.price + _optionAmount) * _quantity;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(title: product.name, price: product.price, optionAmount: _optionAmount, orderAmount: _orderAmount),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final group in product.optionGroups) _OptionGroupSection(
                      group: group,
                      selectedChoiceId: _selectedChoiceIdByGroup[group.id]!,
                      onSelect: (choiceId) => setState(() => _selectedChoiceIdByGroup[group.id] = choiceId),
                    ),
                  ],
                ),
              ),
            ),
            _Footer(
              quantity: _quantity,
              orderAmount: _orderAmount,
              onDecrement: _quantity > 1 ? () => setState(() => _quantity--) : null,
              onIncrement: () => setState(() => _quantity++),
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: () {
                final options = [
                  for (final group in product.optionGroups)
                    SelectedOption(
                      groupTitle: group.title,
                      choice: group.choices.firstWhere((c) => c.id == _selectedChoiceIdByGroup[group.id]),
                    ),
                ];
                final notifier = ref.read(cartProvider.notifier);
                for (var i = 0; i < _quantity; i++) {
                  notifier.addProduct(product, options: options);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.price, required this.optionAmount, required this.orderAmount});

  final String title;
  final int price;
  final int optionAmount;
  final int orderAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PosColors.chrome,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('옵션 선택', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const Text('해당 제품의 옵션을 선택해 주세요.', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              _AmountBox(label: '상품금액', value: formatWon(price)),
              const SizedBox(width: 8),
              _AmountBox(label: '옵션금액', value: formatWon(optionAmount)),
              const SizedBox(width: 8),
              _AmountBox(label: '주문금액', value: formatWon(orderAmount), highlight: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountBox extends StatelessWidget {
  const _AmountBox({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: highlight ? Colors.white : Colors.white24,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: highlight ? Colors.black54 : Colors.white70)),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: highlight ? PosColors.textDark : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionGroupSection extends StatelessWidget {
  const _OptionGroupSection({required this.group, required this.selectedChoiceId, required this.onSelect});

  final ProductOptionGroup group;
  final String selectedChoiceId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: PosColors.textDark)),
          const SizedBox(height: 4),
          RadioGroup<String>(
            groupValue: selectedChoiceId,
            onChanged: (value) => onSelect(value!),
            child: Column(
              children: [
                for (final choice in group.choices)
                  RadioListTile<String>(
                    value: choice.id,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    activeColor: PosColors.danger,
                    title: Text(choice.label, style: const TextStyle(fontSize: 15)),
                    subtitle: choice.priceDelta == 0 ? null : Text('+${formatWon(choice.priceDelta)}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.quantity,
    required this.orderAmount,
    required this.onDecrement,
    required this.onIncrement,
    required this.onCancel,
    required this.onConfirm,
  });

  final int quantity;
  final int orderAmount;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: PosColors.cardBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('주문금액  ', style: const TextStyle(fontSize: 14, color: Colors.black54)),
              Expanded(
                child: Text(formatWon(orderAmount), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              IconButton.filledTonal(onPressed: onDecrement, icon: const Icon(Icons.remove)),
              SizedBox(width: 36, child: Text('$quantity', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
              IconButton.filledTonal(onPressed: onIncrement, icon: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: onCancel, child: const Text('취소')),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(backgroundColor: PosColors.chrome, foregroundColor: Colors.white),
                  child: const Text('메뉴 담기'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
