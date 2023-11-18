import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/v_async_widget.dart';
import '../../../constants/assets.dart';
import '../../../style/style.dart';
import '../application/stock.dart';
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

    return VAsyncWidgetScaffold<List<StockItem>>(
      value: stocks,
      data: (stocks) => StockContent(stocks: stocks),
    );
  }
}

class StockContent extends HookConsumerWidget {
  const StockContent({super.key, required this.stocks});
  final List<StockItem> stocks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = useState(false);
    final searchFocus = ref.watch(searchFocusProvider);
    final searchController = ref.watch(searchControllerProvider);

    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Image.asset(Assets.appLogo),
          title: isSearching.value
              ? TextField(
                  focusNode: searchFocus,
                  controller: searchController,
                  style: const TextStyle(color: Palette.primaryColor),
                  onChanged: (value) => ref
                      .read(searchControllerProvider.notifier)
                      .state
                      .text = value,
                  onSubmitted: (val) => val.isEmpty
                      ? null
                      : ref
                          .read(stockNotifierProvider.notifier)
                          .searchStocks(search: val),
                  onTapOutside: (_) => isSearching.value = !isSearching.value,
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
            if (!isSearching.value)
              IconButton(
                  onPressed: () {
                    isSearching.value = !isSearching.value;
                    searchFocus.requestFocus();
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Palette.primaryColor,
                  ))
          ],
        ),
        body: stocks.isEmpty
            ? Center(
                child: InkWell(
                  onTap: () {
                    isSearching.value = !isSearching.value;
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
                itemCount: stocks.length,
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
                          'SKU  : ${stocks[index].itemSku}',
                          style: Themes.custom(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Nama : ${stocks[index].itemFullName}',
                          style: Themes.custom(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (stocks[index].inStock != null) ...[
                          for (final gudangItem in stocks[index].inStock!) ...[
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gudang : ${gudangItem.warehouseCode}',
                                  style: Themes.custom(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Stok : ${gudangItem.stockCount}',
                                  style: Themes.custom(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                          ]
                        ]
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
