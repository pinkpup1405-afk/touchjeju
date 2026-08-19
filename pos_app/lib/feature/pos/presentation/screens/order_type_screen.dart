import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/order_type.dart';
import '../providers/order_type_provider.dart';
import 'main_order_screen.dart';

class OrderTypeScreen extends ConsumerWidget {
  const OrderTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: PosColors.chrome,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/logo_pill.svg', height: 56),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: _OrderTypeCard(
                      type: OrderType.dineIn,
                      iconAsset: 'assets/icons/store_icon.svg',
                      onTap: () => _select(context, ref, OrderType.dineIn),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _OrderTypeCard(
                      type: OrderType.takeout,
                      iconAsset: 'assets/icons/takeout_icon.svg',
                      onTap: () => _select(context, ref, OrderType.takeout),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                '주문 방법을 선택해 주세요',
                style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1),
              ),
            ],
          ),
        ),
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              SvgPicture.asset(iconAsset, height: 72, colorFilter: const ColorFilter.mode(PosColors.textDark, BlendMode.srcIn)),
              const SizedBox(height: 16),
              Text(type.label, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: PosColors.textDark)),
              const SizedBox(height: 8),
              Text(type.description, style: const TextStyle(fontSize: 14, color: PosColors.textDark)),
            ],
          ),
        ),
      ),
    );
  }
}
