// ignore_for_file: strict_raw_type

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/error_message_widget.dart';
import '../../../constants/assets.dart';
import '../../../style/style.dart';
import '../../auth/application/sign_out/sign_out_notifier.dart';
import '../../auth/shared/providers.dart';
import '../../core/presentation/widgets/alert_helper.dart';
import '../../stock_count/application/stock_inventory_notifier.dart';
import '../application/stock_notifier.dart';
import 'stock_item.dart';

class StockContent extends HookConsumerWidget {
  const StockContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(updateStockInventorControllerProvider, (_, state) {
      if (!state.isLoading && state.hasValue && state.value != null) {
        return AlertHelper.showSnackBar(context,
            color: Palette.primaryColor, message: 'Sukses Mengubah Inventory ');
      }
    });

    ref.listen<SignOutState>(
        signOutNotifierProvider,
        (__, state) => state.maybeWhen(
            success: () => ref
                .read(authNotifierProvider.notifier)
                .checkAndUpdateAuthStatus(),
            orElse: () => null));

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
          ref.read(searchControllerProvider.notifier).state.text =
              searchController.text;
          //
          ref
              .read(stockNotifierProvider.notifier)
              .searchStocks(search: searchController.text);
          return Future.value();
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              // backgroundColor: Colors.white,
              // leading: Image.asset(Assets.appLogo,),
              title: isSearching
                  ? TextField(
                      focusNode: searchFocus,
                      controller: searchController,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary),
                      onTap: () => searchController.text = '',
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
                      decoration: InputDecoration(
                          hintText: 'Search . . .',
                          fillColor: Theme.of(context).colorScheme.tertiary,
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                          // suffix: Container(
                          //   height: 5,
                          //   child: const Icon(Icons.clear),
                          // ),miz
                          suffixIcon: InkWell(
                              onTap: () {
                                ref
                                    .read(searchControllerProvider.notifier)
                                    .state
                                    .text = '';

                                ref
                                    .read(stockNotifierProvider.notifier)
                                    .searchStocks(search: '');
                              },
                              child: const Icon(Icons.clear))),
                    )
                  : const Text(
                      'Sentra Mobile',
                      style: TextStyle(
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
                      )),
                IconButton(
                    onPressed: () =>
                        ref.read(signOutNotifierProvider.notifier).signOut(),
                    icon: const Icon(
                      Icons.logout,
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
                              ref
                                  .read(searchControllerProvider.notifier)
                                  .state
                                  .text = '';

                              ref.read(isSearchingProvider.notifier).state =
                                  !isSearching;

                              searchFocus.requestFocus();
                            },
                            child: Ink(
                              child: const Text(
                                'Tidak ada item . . .\n Silahkan mulai pencarian ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
