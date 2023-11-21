// ignore_for_file: strict_raw_type

import 'package:dartz/dartz.dart';

import '../application/stock_inventory.dart';
import '../application/update_stock_inventory.dart';
import 'stock_inventory_remote_service.dart';

class StockInventoryRepository {
  StockInventoryRepository(this._remoteService);

  final StockInventoryRemoteService _remoteService;

  Future<List<StockInventory>> getStockInventoryBySku({
    required String itemSku,
  }) =>
      _remoteService.getStockInventoryBySku(itemSku: itemSku);

  Future<Unit> adjustStockInventoryBySku({
    required String itemSku,
    required UpdateStockInventory updateStockInventory,
  }) =>
      _remoteService.adjustStockInventoryBySku(
          itemSku: itemSku, updateStockInventory: updateStockInventory);
}
