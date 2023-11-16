import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/auth_repository.dart';

part 'token_notifier.freezed.dart';
part 'token_state.dart';

class TokenNotifier extends StateNotifier<TokenState> {
  TokenNotifier(this._repository) : super(const TokenState.initial());

  final AuthRepository _repository;

  Future<void> checkAndUpdateTokenStatus() async {
    final String? token = await _repository.getSignedInCredentials();
    final String? refreshToken = await _repository.getRefreshCredentials();

    final bool hasToken = token != null &&
        token.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;

    if (hasToken) {
      state = TokenState.withTokenAndRefresh(token, refreshToken);
    } else {
      state = const TokenState.failure();
    }
  }
}
