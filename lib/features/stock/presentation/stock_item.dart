import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';
import '../../stock_count/application/stock_inventory_notifier.dart';
import '../../stock_count/presentation/stock_inventory_bottom.dart';
import '../application/stock.dart';
import '../application/stock_notifier.dart';

class StockItemWidget extends ConsumerWidget {
  const StockItemWidget({super.key, required this.val});
  final StockItem val;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
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
              '${val.itemFullName}',
              style: Themes.custom(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              val.itemSku,
              style: Themes.custom(
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
                        color: Palette.secondaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        '${gudangItem.warehouseCode}:${gudangItem.stockCount}',
                        style: Themes.custom(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                  const Spacer(),
                  if (val.inStock!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: InkWell(
                        onTap: () => showModalBottomSheet<bool>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) =>
                              StockInventoryBottomScreen(itemSku: val.itemSku),
                        ).whenComplete(
                            () => ref.refresh(stockNotifierProvider)),
                        child: Ink(
                          padding: EdgeInsets.zero,
                          child: const Icon(
                            Icons.mode,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
