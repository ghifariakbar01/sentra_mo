import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock.freezed.dart';

part 'stock.g.dart';

@freezed
class StockItem with _$StockItem {
  const factory StockItem({
    @JsonKey(name: 'item_sku') required String itemSku,
    @JsonKey(name: 'item_full_name') required String? itemFullName,
    @JsonKey(name: 'url_pricelist') required String? urlPriceList,
    @JsonKey(name: 'in_stock')
    @JsonSerializable(converters: [MyResponseConverter()])
    required List<InStock>? inStock,
  }) = _StockItem;

  factory StockItem.fromJson(Map<String, Object?> json) =>
      _$StockItemFromJson(json);
}

@freezed
class InStock with _$InStock {
  const factory InStock({
    @JsonKey(name: 'warehouse_code') required String? warehouseCode,
    @JsonKey(name: 'stock_count') required int? stockCount,
  }) = _InStock;

  factory InStock.fromJson(Map<String, Object?> json) =>
      _$InStockFromJson(json);

  static List<InStock> inStockFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((e) => InStock.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class MyResponseConverter
    implements JsonConverter<List<InStock>, Map<String, dynamic>> {
  const MyResponseConverter();

  @override
  List<InStock> fromJson(Map<String, dynamic> json) {
    // type data was already set (e.g. because we serialized it ourselves)
    if (json['in_stock'] != null) {
      final data = json['in_stock'] as List;

      if (data.isNotEmpty) {
        return data
            .map((e) => InStock.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    }

    return [];
  }

  @override
  Map<String, dynamic> toJson(List<InStock> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
