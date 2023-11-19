import 'package:freezed_annotation/freezed_annotation.dart';

import 'paging.dart';
import 'stock.dart';

part 'stock_data.freezed.dart';

part 'stock_data.g.dart';

@freezed
class StockData with _$StockData {
  const factory StockData({
    @JsonSerializable(converters: [MyResultSetConverter()])
    @JsonKey(name: 'result_set')
    required List<StockItem> resultSet,
    @JsonSerializable(converters: [MyPagingConverter()])
    @JsonKey(name: 'paging')
    required Paging paging,
  }) = _Data;

  factory StockData.fromJson(Map<String, Object?> json) =>
      _$StockDataFromJson(json);
}

class MyResultSetConverter
    implements JsonConverter<List<StockItem>, Map<String, dynamic>> {
  const MyResultSetConverter();

  @override
  List<StockItem> fromJson(Map<String, dynamic> json) {
    // type data was already set (e.g. because we serialized it ourselves)
    if (json['paging'] != null) {
      final data = json['paging'] as List<Map<String, dynamic>>;

      return data.map(StockItem.fromJson).toList();
    }

    throw const FormatException('List<StockItem> fromJson null');
  }

  @override
  Map<String, dynamic> toJson(List<StockItem> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

class MyPagingConverter implements JsonConverter<Paging, Map<String, dynamic>> {
  const MyPagingConverter();

  @override
  Paging fromJson(Map<String, dynamic> json) {
    // type data was already set (e.g. because we serialized it ourselves)
    if (json['paging'] != null) {
      final data = json['paging'] as Map<String, dynamic>;

      return Paging.fromJson(data);
    }

    throw const FormatException('Paging fromJson null');
  }

  @override
  Map<String, dynamic> toJson(Paging object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
