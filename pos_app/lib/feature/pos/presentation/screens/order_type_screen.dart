import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/order_type.dart';
import '../providers/order_type_provider.dart';
import 'main_order_screen.dart';

/// Figma "2 매장, 포장" (node 1:181) 실측 좌표를 그대로 이식.
class OrderTypeScreen extends ConsumerWidget {
  const OrderTypeScreen({super.key});

  static const _cardTop = 421.0;
  static const _cardHeight = 155.0;
  static const _cardWidth = 174.0;
  static const _cardSideMargin = 25.0;
  static const _cardGap = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          Positioned(
            top: 344,
            left: 0,
            right: 0,
            height: 48,
            child: Center(
              child: Container(
                width: 158,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: FittedBox(child: SvgPicture.asset('assets/icons/logo_pill.svg')),
              ),
            ),
          ),
          Positioned(
            top: _cardTop,
            left: _cardSideMargin,
            width: _cardWidth,
            height: _cardHeight,
            child: _OrderTypeCard(
              type: OrderType.dineIn,
              iconAsset: 'assets/icons/store_icon.svg',
              onTap: () => _select(context, ref, OrderType.dineIn),
            ),
          ),
          Positioned(
            top: _cardTop,
            left: _cardSideMargin + _cardWidth + _cardGap,
            width: _cardWidth,
            height: _cardHeight,
            child: _OrderTypeCard(
              type: OrderType.takeout,
              iconAsset: 'assets/icons/takeout_icon.svg',
              onTap: () => _select(context, ref, OrderType.takeout),
            ),
          ),
          const Positioned(
            top: 594,
            left: 0,
            right: 0,
            child: Text(
              '주문 방법을 선택해 주세요',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }

  void _select(BuildContext context, WidgetRef ref, OrderType type) {
    ref.read(orderTypeProvider.notifier).state = type;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MainOrderScreen()));
  }
}

class _OrderTypeCard extends StatelessWidget {
  const _OrderTypeCard({required this.type, required this.iconAsset, required this.onTap});

  final OrderType type;
  final String iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(iconAsset, height: 64, colorFilter: const ColorFilter.mode(PosColors.textDark, BlendMode.srcIn)),
                const SizedBox(height: 12),
                Text(type.label, style: const TextStyle(fontSize: 29, fontWeight: FontWeight.bold, color: PosColors.textDark)),
                const SizedBox(height: 6),
                Text(type.description, style: const TextStyle(fontSize: 14, color: PosColors.textDark)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
