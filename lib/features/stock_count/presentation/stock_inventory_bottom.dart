// ignore_for_file: strict_raw_type

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/async_value_ui.dart';
import '../../../common/v_async_widget.dart';
import '../../../common/v_button.dart';
import '../../../style/style.dart';
import '../../core/presentation/widgets/alert_helper.dart';
import '../application/stock_inventory.dart';
import '../application/stock_inventory_notifier.dart';
import '../application/update_stock_inventory.dart';

class StockInventoryBottomScreen extends ConsumerStatefulWidget {
  const StockInventoryBottomScreen({super.key, required this.itemSku});

  final String itemSku;

  @override
  ConsumerState<StockInventoryBottomScreen> createState() =>
      _StockInventoryBottomScreenState();
}

class _StockInventoryBottomScreenState
    extends ConsumerState<StockInventoryBottomScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => ref
        .read(stockInventoryNotifierProvider.notifier)
        .getStockInventoryBySku(itemSku: widget.itemSku));

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    ref.listen<AsyncValue>(
      stockInventoryNotifierProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final stockInventoriesAsync = ref.watch(stockInventoryNotifierProvider);

    return AsyncValueWidget<List<StockInventory>>(
      value: stockInventoriesAsync,
      data: (stockInventories) => StockInventoryBottomSheet(
        itemSku: widget.itemSku,
        stockInventories: stockInventories,
      ),
    );
  }
}

class StockInventoryBottomSheet extends HookConsumerWidget {
  const StockInventoryBottomSheet(
      {super.key, required this.itemSku, required this.stockInventories});

  final String itemSku;
  final List<StockInventory> stockInventories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(updateStockInventorControllerProvider, (_, state) {
      if (!state.isLoading && state.hasValue && state.value != null) {
        return AlertHelper.showSnackBar(context,
            color: Palette.primaryColor,
            message: 'Sukses Mengubah Inventory ',
            onDone: () => context.canPop() ? context.pop(true) : null);
      } else {
        return state.showAlertDialogOnError(context);
      }
    });

    final inventoryControllers = stockInventories
        .map((e) => useTextEditingController(text: e.stockCount.toString()))
        .toList();

    final updateStockInventoryAsync =
        ref.watch(updateStockInventorControllerProvider);

    return AsyncValueWidget<void>(
      value: updateStockInventoryAsync,
      data: (_) => Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: VButton(
          onPressed: () => ref
              .read(updateStockInventorControllerProvider.notifier)
              .adjustStockInventoryBySku(
                  itemSku: itemSku,
                  updateStockInventory: UpdateStockInventory(
                    locationId:
                        stockInventories.map((e) => e.locationId).toList(),
                    stockCountBefore:
                        stockInventories.map((e) => e.stockCount).toList(),
                    stockCountAfter: [
                      ...inventoryControllers
                          .map((e) => e.text.isEmpty ? 0 : int.parse(e.text))
                          .toList()
                    ],
                  )),
          label: 'Adjust Stock Count',
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: ListView.separated(
                itemCount: stockInventories.length + 1,
                separatorBuilder: (context, index) => const SizedBox(
                      height: 4,
                    ),
                itemBuilder: (context, index) {
                  if (index == stockInventories.length) {
                    return Container();
                  } else {
                    return Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Palette.secondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            stockInventories[index].warehouseCode,
                            style: Themes.custom(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                            height: 50,
                            width: 25,
                            child: TextFormField(
                              cursorHeight: 1,
                              // decoration: Themes.formStyle(),
                              controller: inventoryControllers[index],
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  inventoryControllers[index].text = value,
                            ))
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
