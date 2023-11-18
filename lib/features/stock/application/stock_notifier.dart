import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/infrastructure/http_interceptor/http_interceptor_provider.dart';
import '../infrastructure/stock_remote_service.dart';
import '../infrastructure/stock_repository.dart';
import 'stock.dart';

part 'stock_notifier.g.dart';

@Riverpod(keepAlive: true)
StockRemoteService stockRemoteService(StockRemoteServiceRef ref) {
  return StockRemoteService(ref.watch(httpProvider));
}

@Riverpod(keepAlive: true)
StockRepository stockRepository(StockRepositoryRef ref) {
  return StockRepository(
    ref.watch(stockRemoteServiceProvider),
  );
}

@riverpod
class StockNotifier extends _$StockNotifier {
  @override
  FutureOr<List<StockItem>> build() async {
    return ref
        .read(stockRepositoryProvider)
        .getStocks(pageNumber: 1, search: 'Shimizu');
  }

  Future<void> searchStocks({
    required String search,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(stockRepositoryProvider)
        .getStocks(pageNumber: 1, search: search));
  }
}
