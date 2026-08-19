import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format/currency.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../screens/payment_complete_screen.dart';
import 'app_card_payment_dialog.dart';
import 'cart_items_list.dart';
import 'coupon_dialog.dart';

class BottomOrderBar extends ConsumerStatefulWidget {
  const BottomOrderBar({super.key});

  @override
  ConsumerState<BottomOrderBar> createState() => _BottomOrderBarState();
}

class _BottomOrderBarState extends ConsumerState<BottomOrderBar> {
  bool _expanded = false;
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(cartTotalProvider);
    final count = ref.watch(cartItemCountProvider);
    final hasItems = count > 0;

    return Container(
      decoration: const BoxDecoration(color: PosColors.chrome),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ExpandHandle(
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            SizedBox(height: 220, child: const CartItemsList()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                            child: Text('$count', style: const TextStyle(fontSize: 20, color: PosColors.textDark)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: hasItems ? _confirmClearAll : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PosColors.danger,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.white24,
                                ),
                                child: const Text('전체삭제', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _AmountRow(label: '할인', value: 0),
                      const SizedBox(height: 6),
                      _AmountRow(label: '주문금액', value: total, big: true),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _SideButton(
                        label: '카드',
                        sublabel: '삼성페이',
                        enabled: hasItems && !_processing,
                        onTap: () => _payWithCard('카드 결제'),
                      ),
                      const SizedBox(height: 6),
                      _SideButton(
                        label: '간편결제',
                        enabled: hasItems && !_processing,
                        onTap: _payWithAppCard,
                      ),
                      const SizedBox(height: 6),
                      _SideButton(
                        label: '쿠폰/포인트',
                        enabled: true,
                        onTap: () => showDialog<void>(context: context, builder: (_) => const CouponDialog()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('전체 취소'),
        content: const Text('담긴 상품을 모두 지울까요?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('아니요')),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clear();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('네, 지울게요'),
          ),
        ],
      ),
    );
  }

  Future<void> _payWithCard(String label) async {
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _processing = false);
    _completePayment(label);
  }

  Future<void> _payWithAppCard() async {
    final completed = await showDialog<bool>(
      context: context,
      builder: (_) => const AppCardPaymentDialog(),
    );
    if (completed == true && mounted) {
      _completePayment('간편결제');
    }
  }

  void _completePayment(String label) {
    ref.read(cartProvider.notifier).clear();
    setState(() => _expanded = false);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PaymentCompleteScreen(methodLabel: label)),
    );
  }
}

class _ExpandHandle extends StatelessWidget {
  const _ExpandHandle({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(color: PosColors.chromeLight, shape: BoxShape.circle),
          child: Icon(
            expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({required this.label, required this.value, this.big = false});

  final String label;
  final int value;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: PosColors.chromeLight, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.bold)),
          Text(
            formatWon(value),
            style: TextStyle(fontSize: big ? 20 : 14, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({required this.label, this.sublabel, required this.enabled, required this.onTap});

  final String label;
  final String? sublabel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: PosColors.chromeLight,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.white12,
          disabledForegroundColor: Colors.white38,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            if (sublabel != null) Text(sublabel!, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
