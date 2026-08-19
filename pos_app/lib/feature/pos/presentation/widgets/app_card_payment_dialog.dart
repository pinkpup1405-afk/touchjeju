import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Figma "앱카드 결제" 모달(바코드 스캔). 실제 스캐너 대신 버튼으로 완료를 시뮬레이션한다.
/// true를 반환하면 결제 완료, false/null이면 취소.
class AppCardPaymentDialog extends StatelessWidget {
  const AppCardPaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: PosColors.chrome,
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
                    child: Text('앱카드 결제', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const Text('앱카드의 바코드를 바코드 리더기에 스캔해 주세요.', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => Navigator.of(context).pop(true),
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner, size: 64, color: PosColors.chrome),
                      SizedBox(height: 12),
                      Text('여기를 눌러 스캔을 연습해보세요', style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white)),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('이전'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
