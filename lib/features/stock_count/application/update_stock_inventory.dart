import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_stock_inventory.freezed.dart';

@freezed
class UpdateStockInventory with _$UpdateStockInventory {
  const factory UpdateStockInventory({
    required List<int> locationId,
    required List<int> stockCountAfter,
    required List<int> stockCountBefore,
  }) = _UpdateStockInventory;

  factory UpdateStockInventory.initial() => const UpdateStockInventory(
      locationId: [], stockCountAfter: [], stockCountBefore: []);
}
