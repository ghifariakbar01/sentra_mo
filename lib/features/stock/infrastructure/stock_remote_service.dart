// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';

import 'package:http_interceptor/http/intercepted_client.dart';

import '../../../../config/configuration.dart';

import '../../core/infrastructure/exceptions.dart';
import '../application/stock_data.dart';

class StockRemoteService {
  StockRemoteService(
    this._httpClient,
  );

  final InterceptedClient _httpClient;

  Future<StockData> getStocks({
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

      // log('response data $data');

      if (response.statusCode == 200 && data['data'] != null) {
        return StockData.fromJson(data['data'] as Map<String, dynamic>);
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
