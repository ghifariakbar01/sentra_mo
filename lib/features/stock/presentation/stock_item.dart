import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../application/stock.dart';

class StockItemWidget extends StatelessWidget {
  const StockItemWidget({super.key, required this.val});
  final StockItem val;

  @override
  Widget build(BuildContext context) {
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
              val.itemSku,
              style: Themes.custom(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 8,
            ),
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
            if (val.inStock != null) ...[
              for (final gudangItem in val.inStock!) ...[
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            //
            Row(
              children: [
                Center(
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
    );
  }
}
