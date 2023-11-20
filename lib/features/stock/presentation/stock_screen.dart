import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/error_message_widget.dart';
import '../../../constants/assets.dart';
import '../../../style/style.dart';
import '../application/stock_notifier.dart';
import 'stock_item.dart';

class StockContent extends HookConsumerWidget {
  const StockContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocks = ref.watch(stockNotifierProvider);

    final searchPage = ref.watch(searchPageProvider);
    final isSearching = ref.watch(isSearchingProvider);
    final searchFocus = ref.watch(searchFocusProvider);
    final searchController = ref.watch(searchControllerProvider);

    final controller = useScrollController();

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

                        ref.read(searchPageProvider.notifier).state = 1;

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
            body: stocks.when(
                data: (val) {
                  void onScrolled() {
                    if (int.parse(val.paging.pageNo) <= val.paging.totalPage &&
                        controller.position.pixels >=
                            controller.position.maxScrollExtent) {
                      // debugger();

                      final page = ref.read(searchPageProvider);

                      ref.read(searchPageProvider.notifier).state++;

                      ref.read(stockNotifierProvider.notifier).loadMore(
                          page: page + 1, search: searchController.text);

                      // debugger();
                    }
                  }

                  useEffect(() {
                    controller.addListener(onScrolled);
                    return () => controller.removeListener(onScrolled);
                  }, [controller]);

                  return val.resultSet.isEmpty
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
                          itemCount: val.resultSet.length,
                          padding: const EdgeInsets.all(4),
                          separatorBuilder: (context, index) => Container(),
                          itemBuilder: (context, index) =>
                              StockItemWidget(val: val.resultSet[index]),
                        );
                },
                error: (e, st) => Scaffold(
                      appBar: AppBar(),
                      body: Center(child: ErrorMessageWidget(e.toString())),
                    ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()))),
      ),
    );
  }
}
