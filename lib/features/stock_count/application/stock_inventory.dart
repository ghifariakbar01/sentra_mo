import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_inventory.freezed.dart';

part 'stock_inventory.g.dart';

@freezed
class StockInventory with _$StockInventory {
  const factory StockInventory({
    @JsonKey(name: 'in_stock') required int stockCount,
    @JsonKey(name: 'location_id') required int locationId,
    @JsonKey(name: 'warehouse_code') required String warehouseCode,
  }) = _StockInventory;

  factory StockInventory.fromJson(Map<String, Object?> json) =>
      _$StockInventoryFromJson(json);

  static List<StockInventory> stockInventoryFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((e) => StockInventory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
