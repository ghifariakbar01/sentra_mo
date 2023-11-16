part of 'token_notifier.dart';

@freezed
class TokenState with _$TokenState {
  const factory TokenState.initial() = _Initial;
  const factory TokenState.withTokenAndRefresh(
      [String? token, String? refreshToken]) = _WithToken;
  const factory TokenState.failure() = _Failure;
}
