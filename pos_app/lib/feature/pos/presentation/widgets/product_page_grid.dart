import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/format/currency.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product.dart';
import '../providers/cart_provider.dart';
import '../providers/catalog_providers.dart';
import 'option_select_dialog.dart';

const _pageSize = 6;

class ProductPageGrid extends ConsumerStatefulWidget {
  const ProductPageGrid({super.key});

  @override
  ConsumerState<ProductPageGrid> createState() => _ProductPageGridState();
}

class _ProductPageGridState extends ConsumerState<ProductPageGrid> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsByCategoryProvider);

    // 카테고리를 바꿔서 페이지 수가 줄었으면 첫 페이지로 되돌린다.
    final pageCount = (products.length / _pageSize).ceil().clamp(1, 999);
    if (_page >= pageCount) {
      _page = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) _pageController.jumpToPage(0);
      });
    }

    if (products.isEmpty) {
      return const Expanded(
        child: Center(child: Text('상품이 없어요', style: TextStyle(fontSize: 18, color: Colors.black45))),
      );
    }

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              onPageChanged: (value) => setState(() => _page = value),
              itemBuilder: (context, pageIndex) {
                final start = pageIndex * _pageSize;
                final end = (start + _pageSize).clamp(0, products.length);
                final pageItems = products.sublist(start, end);
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) => _ProductCard(product: pageItems[index]),
                );
              },
            ),
          ),
          _PageControls(pageCount: pageCount, page: _page, controller: _pageController),
        ],
      ),
    );
  }
}

class _PageControls extends StatelessWidget {
  const _PageControls({required this.pageCount, required this.page, required this.controller});

  final int pageCount;
  final int page;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          _ArrowButton(
            icon: Icons.chevron_left,
            enabled: page > 0,
            onTap: () => controller.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeOut),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pageCount, (index) {
                final active = index == page;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 10 : 8,
                  height: active ? 10 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? PosColors.chrome : Colors.black26,
                  ),
                );
              }),
            ),
          ),
          _ArrowButton(
            icon: Icons.chevron_right,
            enabled: page < pageCount - 1,
            onTap: () => controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeOut),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.enabled, required this.onTap});

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: enabled ? PosColors.chrome : Colors.black12,
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white38,
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _onTap(context, ref),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: PosColors.cardBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: product.imageUrl != null
                          ? Image.asset(product.imageUrl!, fit: BoxFit.cover)
                          : Container(color: PosColors.pageBackground, child: const Icon(Icons.local_cafe, size: 40, color: Colors.black26)),
                    ),
                    const Positioned(
                      left: 8,
                      top: 8,
                      child: _RingBadge(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: PosColors.productName),
                    ),
                    if (product.description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          product.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: Colors.black45),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/won_icon_card.svg', width: 12, height: 12),
                        const SizedBox(width: 3),
                        Text(
                          formatWon(product.price).replaceAll('원', ''),
                          style: const TextStyle(fontSize: 14, color: PosColors.productName),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref) {
    if (product.hasOptions) {
      showDialog<void>(
        context: context,
        builder: (_) => OptionSelectDialog(product: product),
      );
    } else {
      ref.read(cartProvider.notifier).addProduct(product);
    }
  }
}

class _RingBadge extends StatelessWidget {
  const _RingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      padding: const EdgeInsets.all(3),
      child: SvgPicture.asset('assets/icons/card_ring.svg'),
    );
  }
}
