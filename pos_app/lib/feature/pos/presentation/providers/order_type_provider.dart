import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/order_type.dart';

/// 매장/포장 선택 화면에서 고른 값. 처음으로 돌아가면 초기화된다.
final orderTypeProvider = StateProvider<OrderType?>((ref) => null);
