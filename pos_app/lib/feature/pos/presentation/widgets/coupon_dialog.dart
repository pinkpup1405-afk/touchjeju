import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Figma "쿠폰/포인트" 모달. 1단계에서는 데모용 — 실제 할인 계산은 연결하지 않는다.
class CouponDialog extends StatelessWidget {
  const CouponDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('쿠폰 / 포인트', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                ],
              ),
              const Text('사용하실 쿠폰 또는 포인트를 선택해 주세요.', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: PosColors.pageBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.card_giftcard, size: 32, color: Colors.black38),
                    SizedBox(height: 8),
                    Text('사용 가능한 쿠폰이 없어요', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('닫기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
