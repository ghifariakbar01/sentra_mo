import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/infrastructure/http_interceptor/http_interceptor_provider.dart';
import '../infrastructure/stock_remote_service.dart';
import '../infrastructure/stock_repository.dart';
import 'stock.dart';
import 'stock_data.dart';

part 'stock_notifier.g.dart';

final isSearchingProvider = StateProvider<bool>((ref) {
  return false;
});

final searchPageProvider = StateProvider<int>((ref) {
  return 1;
});

final searchControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController(text: '');
});

final searchFocusProvider = StateProvider<FocusNode>((ref) {
  return FocusNode();
});

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
  bool canLoadMore() =>
      int.parse(state.requireValue.paging.pageNo) <=
      state.requireValue.paging.pageSize;

  @override
  FutureOr<StockData> build() async {
    final text = ref.read(searchControllerProvider);

    if (text.text.isEmpty) {
      return StockData.initial();
    }

    return ref
        .read(stockRepositoryProvider)
        .getStocks(pageNumber: 1, search: text.text);
  }

  void emptyStocks() {
    state = const AsyncLoading();

    state = AsyncValue.data(StockData.initial());
  }

  Future<void> searchStocks({
    required String search,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(stockRepositoryProvider)
        .getStocks(pageNumber: 1, search: search));
  }

  Future<void> loadMore({
    required int page,
    required String search,
  }) async {
    state = const AsyncLoading<StockData>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res = await ref
          .read(stockRepositoryProvider)
          .getStocks(pageNumber: page, search: search);

      final List<StockItem> list = [
        ...state.requireValue.resultSet.toList(),
        ...res.resultSet,
      ];

      final stock = StockData(resultSet: list, paging: res.paging);

      return stock;
    });
  }
}
