// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';

import 'package:http_interceptor/http/intercepted_client.dart';

import '../../../../config/configuration.dart';

import '../../core/infrastructure/exceptions.dart';

class StockRemoteService {
  StockRemoteService(
    this._httpClient,
  );

  final InterceptedClient _httpClient;

  // Future<List<PatientDataState>> getPatients(int pageNumber) async {
  //   try {
  //     final response = await _httpClient.get(
  //       Uri.parse(
  //           '${BuildConfig.get().baseUrl}v-care/?mod=pasien&a=list&sq=&so=&pn=$pageNumber'),
  //     );

  //     log('url ${'${BuildConfig.get().baseUrl}v-care/?mod=pasien&a=list&sq=&so=&pn=$pageNumber'}');

  //     final responsePatients =
  //         jsonDecode(response.body) as Map<String, dynamic>;

  //     log('response.patients ${responsePatients}');

  //     if (response.statusCode == 200 && responsePatients['data'] != null) {
  //       final resultSet = <PatientDataState>[];

  //       if (responsePatients['data']['result_set'] != null) {
  //         final list = responsePatients['data']['result_set'] as List<dynamic>;

  //         if (list.isNotEmpty) {
  //           for (final data in list) {
  //             resultSet
  //                 .add(PatientDataState.fromJson(data as Map<String, dynamic>));
  //           }

  //           return resultSet;
  //         }
  //       }

  //       return resultSet;
  //     }

  //     final responseCode = responsePatients['code'] as String;
  //     final responseCodeInt = int.parse(responseCode);
  //     final responseMessage = responsePatients['message'] as String;

  //     log('response.body 2  $responseCode $responseCodeInt $responseMessage');

  //     debugger(message: 'called');

  //     throw RestApiException(responseCodeInt, responseMessage);
  //   } on FormatException {
  //     throw const FormatException();
  //   } on NoConnectionException {
  //     throw NoConnectionException();
  //   } on RestApiException catch (e) {
  //     throw RestApiException(e.errorCode, e.message);
  //   }
  // }
}
