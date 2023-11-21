import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/infrastructure/http_interceptor/http_interceptor_provider.dart';
import '../infrastructure/stock_inventory_remote_service.dart';
import '../infrastructure/stock_inventory_repository.dart';
import 'stock_inventory.dart';
import 'update_stock_inventory.dart';

part 'stock_inventory_notifier.g.dart';

@Riverpod(keepAlive: true)
StockInventoryRemoteService stockInventoryRemoteService(
    StockInventoryRemoteServiceRef ref) {
  return StockInventoryRemoteService(ref.watch(httpProvider));
}

@Riverpod(keepAlive: true)
StockInventoryRepository stockInventoryRepository(
    StockInventoryRepositoryRef ref) {
  return StockInventoryRepository(
      ref.watch(stockInventoryRemoteServiceProvider));
}

@riverpod
class StockInventoryNotifier extends _$StockInventoryNotifier {
  @override
  FutureOr<List<StockInventory>> build() async {
    return [];
  }

  Future<void> getStockInventoryBySku({
    required String itemSku,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(stockInventoryRepositoryProvider)
        .getStockInventoryBySku(itemSku: itemSku));
  }
}

@riverpod
class UpdateStockInventorController extends _$UpdateStockInventorController {
  @override
  FutureOr<void> build() async {}

  Future<void> adjustStockInventoryBySku(
      {required String itemSku,
      required UpdateStockInventory updateStockInventory}) async {
    state = const AsyncLoading();

    debugger();

    state = await AsyncValue.guard(() => ref
        .read(stockInventoryRepositoryProvider)
        .adjustStockInventoryBySku(
            itemSku: itemSku, updateStockInventory: updateStockInventory));
  }
}
