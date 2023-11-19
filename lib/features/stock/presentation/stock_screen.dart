import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/v_async_widget.dart';
import '../../../constants/assets.dart';
import '../../../style/style.dart';
import '../application/stock_data.dart';
import '../application/stock_notifier.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  @override
  Widget build(BuildContext context) {
    final stocks = ref.watch(stockNotifierProvider);

    final isSearching = ref.watch(isSearchingProvider);
    final searchFocus = ref.watch(searchFocusProvider);
    final searchController = ref.watch(searchControllerProvider);

    return VAsyncWidgetScaffold<StockData>(
      value: stocks,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Image.asset(Assets.appLogo),
        title: isSearching
            ? TextField(
                focusNode: searchFocus,
                controller: searchController,
                style: const TextStyle(color: Palette.primaryColor),
                onChanged: (value) => value.isEmpty
                    ? () {
                        ref
                            .read(stockNotifierProvider.notifier)
                            .searchStocks(search: 'Shimizu');

                        ref.read(searchControllerProvider.notifier).state.text =
                            'Shimizu';
                      }()
                    : () {
                        ref
                            .read(stockNotifierProvider.notifier)
                            .searchStocks(search: value);

                        ref.read(searchControllerProvider.notifier).state.text =
                            value;
                      }(),
                onSubmitted: (val) => val.isEmpty
                    ? ref
                        .read(stockNotifierProvider.notifier)
                        .searchStocks(search: 'Shimizu')
                    : ref
                        .read(stockNotifierProvider.notifier)
                        .searchStocks(search: val),
                onTapOutside: (_) =>
                    ref.read(isSearchingProvider.notifier).state = !isSearching,
                decoration: const InputDecoration(
                  hintText: 'Search . . .',
                  fillColor: Palette.primaryColor,
                  hintStyle: TextStyle(color: Palette.primaryColor),
                ),
              )
            : Text(
                'Sentra Teknik Mobile',
                style: Themes.custom(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Palette.primaryColor),
              ),
        actions: [
          if (!isSearching)
            IconButton(
                onPressed: () {
                  ref.read(isSearchingProvider.notifier).state = !isSearching;
                  searchFocus.requestFocus();
                },
                icon: const Icon(
                  Icons.search,
                  color: Palette.primaryColor,
                ))
        ],
      ),
      data: (stocks) => StockContent(stocks: stocks),
    );
  }
}

class StockContent extends HookConsumerWidget {
  const StockContent({super.key, required this.stocks});
  final StockData stocks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPage = ref.watch(searchPageProvider);
    final isSearching = ref.watch(isSearchingProvider);
    final searchFocus = ref.watch(searchFocusProvider);
    final searchController = ref.watch(searchControllerProvider);

    final controller = useScrollController();

    useEffect(() {
      controller.addListener(() {
        if (int.parse(stocks.paging.pageNo) <= stocks.paging.totalPage &&
            controller.position.pixels >= controller.position.maxScrollExtent) {
          final page = ref.read(searchPageProvider);

          ref.read(searchPageProvider.notifier).state++;

          ref
              .read(stockNotifierProvider.notifier)
              .loadMore(page: page + 1, search: searchController.text);
        }
      });
      return () => controller.removeListener(() {});
    }, [controller]);

    return KeyboardDismissOnTap(
      child: RefreshIndicator(
        onRefresh: () {
          ref.read(searchFocusProvider).unfocus();
          ref.read(searchPageProvider.notifier).state = 1;
          ref.read(searchControllerProvider.notifier).state.text = 'Shimizu';
          //
          ref
              .read(stockNotifierProvider.notifier)
              .searchStocks(search: 'Shimizu');
          return Future.value();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Image.asset(Assets.appLogo),
            title: isSearching
                ? TextField(
                    focusNode: searchFocus,
                    controller: searchController,
                    style: const TextStyle(color: Palette.primaryColor),
                    onChanged: (value) {
                      if (value.isEmpty) return;

                      ref
                          .read(stockNotifierProvider.notifier)
                          .searchStocks(search: value);

                      ref.read(searchControllerProvider.notifier).state.text =
                          value;
                    },
                    onTapOutside: (_) => ref
                        .read(isSearchingProvider.notifier)
                        .state = !isSearching,
                    decoration: const InputDecoration(
                      hintText: 'Search . . .',
                      fillColor: Palette.primaryColor,
                      hintStyle: TextStyle(color: Palette.primaryColor),
                    ),
                  )
                : Text(
                    'Sentra Teknik Mobile',
                    style: Themes.custom(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Palette.primaryColor),
                  ),
            actions: [
              if (!isSearching)
                IconButton(
                    onPressed: () {
                      ref.read(isSearchingProvider.notifier).state =
                          !isSearching;
                      searchFocus.requestFocus();
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Palette.primaryColor,
                    ))
            ],
          ),
          body: stocks.resultSet.isEmpty
              ? Center(
                  child: InkWell(
                    onTap: () {
                      ref.read(isSearchingProvider.notifier).state =
                          !isSearching;
                      searchFocus.requestFocus();
                    },
                    child: Ink(
                      child: Text(
                        'Tidak ada item . . .\n Silahkan mulai pencarian ',
                        textAlign: TextAlign.center,
                        style: Themes.custom(
                            fontSize: 14,
                            color: Palette.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  controller: controller,
                  itemCount: stocks.resultSet.length,
                  padding: const EdgeInsets.all(4),
                  separatorBuilder: (context, index) => Container(),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stocks.resultSet[index].itemSku,
                            style: Themes.custom(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${stocks.resultSet[index].itemFullName}',
                            style: Themes.custom(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          if (stocks.resultSet[index].inStock != null) ...[
                            for (final gudangItem
                                in stocks.resultSet[index].inStock!) ...[
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${gudangItem.warehouseCode}',
                                    style: Themes.custom(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    'Stok : ${gudangItem.stockCount}',
                                    style: Themes.custom(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                            ]
                          ],
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Center(
                                child: Container(
                                  // width: MediaQuery.of(context).size.width / 2,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        Palette.primaryColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 5,
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    child: Ink(
                                      child: const Icon(
                                        Icons.mode,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
