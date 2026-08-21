import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/order_type_provider.dart';
import '../widgets/bottom_order_bar.dart';
import '../widgets/category_grid.dart';
import '../widgets/product_page_grid.dart';

class MainOrderScreen extends StatelessWidget {
  const MainOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PosColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            const ColoredBox(color: PosColors.chrome, child: CategoryGrid()),
            const ProductPageGrid(),
            const BottomOrderBar(),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: PosColors.chrome,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(7),
            onTap: () {
              ref.read(cartProvider.notifier).clear();
              ref.read(orderTypeProvider.notifier).state = null;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
              child: SvgPicture.asset('assets/icons/home_icon.svg'),
            ),
          ),
          Expanded(
            child: Center(
              child: SvgPicture.asset('assets/icons/logo_wordmark.svg', height: 22),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}
