// ignore_for_file: strict_raw_type

import '../application/stock_data.dart';
import 'stock_remote_service.dart';

class StockRepository {
  StockRepository(this._remoteService);

  final StockRemoteService _remoteService;

  Future<StockData> getStocks({
    required int pageNumber,
    required String search,
  }) =>
      _remoteService.getStocks(pageNumber: pageNumber, search: search);
}
