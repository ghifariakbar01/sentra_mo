// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../../../config/configuration.dart';

import '../../core/infrastructure/exceptions.dart';
// import '../application/stock_data.dart';
import '../application/stock_inventory.dart';
import '../application/update_stock_inventory.dart';

class StockInventoryRemoteService {
  StockInventoryRemoteService(
    this._httpClient,
  );

  final InterceptedClient _httpClient;

  Future<List<StockInventory>> getStockInventoryBySku({
    required String itemSku,
  }) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
            '${BuildConfig.get().baseUrl}?mod=inventory&a=adjust&item_sku=$itemSku'),
      );

      log('url ${BuildConfig.get().baseUrl}?mod=inventory&a=adjust&item_sku=$itemSku');

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // log('response data $data');

      if (response.statusCode == 200 &&
          data['data']['arr_ds_item_location'] != null) {
        final stock = data['data']['arr_ds_item_location'] as List<dynamic>;

        return StockInventory.stockInventoryFromJson(stock);
      }

      final code = int.parse(data['code'] as String);
      final message = data['message'] as String;

      debugger(message: 'called');

      throw 'Server Error Code : $code Message : $message ';
    } on NoConnectionException {
      throw 'No Connection ';
    } on FormatException catch (e) {
      throw 'Format Error $e ';
    } on RestApiException catch (e) {
      throw 'Server Error ${e.message}';
    }
  }

  Future<Unit> adjustStockInventoryBySku({
    required String itemSku,
    required UpdateStockInventory updateStockInventory,
  }) async {
    try {
      final Map<String, dynamic> stockBeforeListMap = {};
      final stockCountBefore = updateStockInventory.stockCountBefore;

      for (int index = 0; index < stockCountBefore.length; index++) {
        stockBeforeListMap['arr_current[$index]'] =
            stockCountBefore[index].toString();
      }

      final Map<String, dynamic> stockAfterListMap = {};
      final stockAfterCount = updateStockInventory.stockCountAfter;

      for (int index = 0; index < stockAfterCount.length; index++) {
        stockAfterListMap['arr_new[$index]'] =
            stockAfterCount[index].toString();
      }

      final Map<String, dynamic> stockLocationIdListMap = {};
      final stockLocationId = updateStockInventory.locationId;

      for (int index = 0; index < stockLocationId.length; index++) {
        stockLocationIdListMap['arr_location_id[$index]'] =
            stockLocationId[index].toString();
      }

      final Map<String, dynamic> bodyToSend = {
        '_action_': 'SaveAdjust',
      };

      bodyToSend.addAll(stockAfterListMap);
      bodyToSend.addAll(stockBeforeListMap);
      bodyToSend.addAll(stockLocationIdListMap);

      log('bodyToSend $bodyToSend');

      debugger();

      final response = await _httpClient.post(
          Uri.parse(
              '${BuildConfig.get().baseUrl}?mod=inventory&a=adjust&item_sku=$itemSku'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: bodyToSend);

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // log('response data $data');

      if (response.statusCode == 200 && data['code'] != null) {
        //
        if (data['code'] is int) {
          final int code = data['code'] as int;

          if (code == 200) {
            return unit;
          }
        }
      }

      log('response.statusCode ${response.statusCode}');

      final code = int.parse(data['code'] as String);
      final message = data['message'] as String;

      debugger(message: 'called');

      throw 'Server Error Code : $code  Message : $message ';
    } on NoConnectionException {
      throw 'No Connection ';
    } on FormatException catch (e) {
      throw 'Format Error $e ';
    } on RestApiException catch (e) {
      throw 'Server Error ${e.message}';
    }
  }
}
