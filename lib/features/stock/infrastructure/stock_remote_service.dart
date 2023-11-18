// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';

import 'package:http_interceptor/http/intercepted_client.dart';

import '../../../../config/configuration.dart';

import '../../core/infrastructure/exceptions.dart';
import '../application/stock.dart';

class StockRemoteService {
  StockRemoteService(
    this._httpClient,
  );

  final InterceptedClient _httpClient;

  Future<List<StockItem>> getStocks({
    required int pageNumber,
    required String search,
  }) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
            '${BuildConfig.get().baseUrl}?mod=item&a=list&sq=$search&pn=$pageNumber'),
      );

      log('url ${BuildConfig.get().baseUrl}?mod=item&a=list&sq=$search&pn=$pageNumber');

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      log('response data $data');

      if (response.statusCode == 200 && data['data'] != null) {
        final resultSet = <StockItem>[];

        if (data['data']['result_set'] != null) {
          final list = data['data']['result_set'] as List<dynamic>;

          if (list.isNotEmpty) {
            for (final data in list) {
              resultSet.add(StockItem.fromJson(data as Map<String, dynamic>));
            }

            return resultSet;
          }
        }

        return resultSet;
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
}
