import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../style/style.dart';
import '../../home/widget/v_dialogs.dart';
import '../../stock_count/application/stock_inventory_notifier.dart';
import '../../stock_count/presentation/stock_inventory_bottom.dart';
import '../application/stock.dart';
import '../application/stock_notifier.dart';

class StockItemWidget extends ConsumerWidget {
  const StockItemWidget({super.key, required this.val});
  final StockItem val;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = Theme.of(context).colorScheme.primaryContainer;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
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
              '${val.itemFullName}',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              val.itemSku,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 8,
            ),

            if (val.inStock != null) ...[
              Row(
                children: [
                  for (final gudangItem in val.inStock!) ...[
                    Container(
                      decoration: BoxDecoration(
                          color: Palette.green,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1.5),
                              blurRadius: 5,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ]),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            ' ${gudangItem.warehouseCode}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Palette.greyDisabled,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              '${gudangItem.stockCount}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                  if (val.urlPriceList != null) ...[
                    InkWell(
                        onTap: () async => await canLaunchUrl(
                                Uri.parse('https://${val.urlPriceList!}'))
                            ? launchUrl(
                                Uri.parse('https://${val.urlPriceList!}'),
                                mode: LaunchMode.externalApplication)
                            // ignore: use_build_context_synchronously
                            : showVAlertDialog(
                                label: 'Error',
                                labelDescription: 'Url tidak bisa dibuka',
                                onPressed: () {
                                  context.pop();
                                  return Future.value(true);
                                },
                                pressedLabel: 'OK',
                                backPressedLabel: '',
                                context: context,
                              ),
                        child: Ink(
                            child: const Icon(
                          Icons.launch,
                          color: Colors.white,
                        ))),
                  ],
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      ref.refresh(updateStockInventorControllerProvider);
                      await showModalBottomSheet<bool>(
                        useSafeArea: true,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        context: context,
                        builder: (context) =>
                            StockInventoryBottomScreen(itemSku: val.itemSku),
                      ).whenComplete(() => ref.refresh(stockNotifierProvider));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Palette.primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Ink(
                        child: const Icon(
                          Icons.mode,
                          size: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
            const SizedBox(
              height: 2,
            ),
            //
          ],
        ),
      ),
    );
  }
}
