// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../config/configuration.dart';
import '../../core/infrastructure/exceptions.dart';
import 'auth_response.dart';

class AuthRemoteService {
  AuthRemoteService();

  Future<void> signOut() async {}

  Future<AuthResponse> signIn({
    required String userId,
    required String password,
  }) async {
    try {
      final response = await http.post(
          Uri.parse('${BuildConfig.get().baseUrl}?mod=auth&a=signin'),
          body: {
            '_action_': 'Login',
            'user_id': userId,
            'password': password,
          });

      debugger();

      log('response.body ${response.body}');

      final responseLogin = jsonDecode(response.body) as Map<String, dynamic>;

      log('response.statusCode ${response.statusCode}');

      if (response.statusCode == 200 && responseLogin['code'] == 200) {
        if (responseLogin['data']['access_token'] != null &&
            responseLogin['data']['refresh_token'] != null) {
          return AuthResponse.withToken(
            responseLogin['data']['access_token'] as String,
            responseLogin['data']['refresh_token'] as String,
          );
        } else {
          return const AuthResponse.failure(
            errorCode: 404,
            message: 'Credential token not found',
          );
        }
      } else {
        return AuthResponse.failure(
          errorCode: int.parse(responseLogin['code'] as String),
          message: responseLogin['message'] as String,
        );
      }
    } on NoConnectionException {
      throw NoConnectionException();
    } on RestApiException catch (e) {
      throw RestApiException(e.errorCode, e.message);
    }
  }

  Future<AuthResponse> refreshToken(
      {required String token, required Map<String, String> headers}) async {
    try {
      final response = await http.post(
          Uri.parse('${BuildConfig.get().baseUrl}?mod=auth&a=signin_token'),
          body: {'_action_': 'LoginToken', 'token': token},
          headers: headers);

      final responseLogin = jsonDecode(response.body) as Map<String, dynamic>;

      log('response.body ${response.body} response.header ${response.headers} response.statusCode ${response.statusCode} responseLogin $responseLogin');

      if (response.statusCode == 200 && responseLogin['code'] == 200) {
        if (responseLogin['data']['access_token'] != null &&
            responseLogin['data']['refresh_token'] != null) {
          return AuthResponse.withToken(
              responseLogin['data']['access_token'] as String,
              responseLogin['data']['refresh_token'] as String);
        } else {
          return const AuthResponse.failure(
            errorCode: 404,
            message: 'Credential token not found',
          );
        }
      } else {
        return AuthResponse.failure(
          errorCode: int.parse(responseLogin['code'] as String),
          message: responseLogin['message'] as String,
        );
      }
    } on NoConnectionException {
      throw NoConnectionException();
    } on RestApiException catch (e) {
      throw RestApiException(e.errorCode, e.message);
    }
  }
}
