// ignore_for_file: strict_raw_type

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/async_value_ui.dart';
import '../../../common/v_async_widget.dart';
import '../../../common/v_button.dart';
import '../../../style/style.dart';
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

    return KeyboardDismissOnTap(
      child: AsyncValueWidget<List<StockInventory>>(
        value: stockInventoriesAsync,
        data: (stockInventories) => StockInventoryBottomSheet(
          widget.itemSku,
          stockInventories,
        ),
      ),
    );
  }
}

class StockInventoryBottomSheet extends StatefulHookConsumerWidget {
  const StockInventoryBottomSheet(this.itemSku, this.stockInventories,
      {super.key});

  final String itemSku;
  final List<StockInventory> stockInventories;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StockInventoryBottomSheetState();
}

class _StockInventoryBottomSheetState
    extends ConsumerState<StockInventoryBottomSheet> {
  _StockInventoryBottomSheetState();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(updateStockInventorControllerProvider, (_, state) {
      if (!state.isLoading && state.hasValue && state.value != null) {
        context.canPop() ? context.pop(true) : null;
      } else {
        return state.showAlertDialogOnError(context);
      }
    });

    final inventoryControllers = widget.stockInventories
        .map((e) => useTextEditingController(text: e.stockCount.toString()))
        .toList();

    final updateStockInventoryAsync =
        ref.watch(updateStockInventorControllerProvider);

    return AsyncValueWidget<void>(
      value: updateStockInventoryAsync,
      data: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.stockInventories.length + 1,
              separatorBuilder: (context, index) => const SizedBox(
                    height: 4,
                  ),
              itemBuilder: (context, index) {
                if (index == widget.stockInventories.length) {
                  return Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: VButton(
                          color: Colors.red,
                          width: MediaQuery.of(context).size.width,
                          onPressed: () =>
                              context.canPop() ? context.pop() : null,
                          label: 'Batal',
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: VButton(
                          color: Palette.primaryColor,
                          width: MediaQuery.of(context).size.width,
                          onPressed: () => ref
                              .read(updateStockInventorControllerProvider
                                  .notifier)
                              .adjustStockInventoryBySku(
                                  itemSku: widget.itemSku,
                                  updateStockInventory: UpdateStockInventory(
                                    locationId: widget.stockInventories
                                        .map((e) => e.locationId)
                                        .toList(),
                                    stockCountBefore: widget.stockInventories
                                        .map((e) => e.stockCount)
                                        .toList(),
                                    stockCountAfter: [
                                      ...inventoryControllers
                                          .map((e) => e.text.isEmpty
                                              ? 0
                                              : int.parse(e.text))
                                          .toList()
                                    ],
                                  )),
                          label: 'Simpan',
                        ),
                      ),
                    ],
                  );
                } else {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Palette.green,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1.5),
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ]),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ' ${widget.stockInventories[index].warehouseCode}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 45,
                              width: 75,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1.5),
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ]),
                              child: Center(
                                child: TextFormField(
                                  focusNode: index == 0 ? focusNode : null,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(16),
                                      border: InputBorder.none),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  controller: inventoryControllers[index],
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) =>
                                      inventoryControllers[index].text = value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                }
              }),
        ),
      ),
    );
  }
}
