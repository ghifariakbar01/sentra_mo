import 'package:freezed_annotation/freezed_annotation.dart';

part 'input_failure.freezed.dart';

@freezed
class InputFailure with _$InputFailure {
  const factory InputFailure.server([int? errorCode, String? message]) =
      _Server;
  const factory InputFailure.noConnection() = _NoConnection;
  const factory InputFailure.unauthorized([int? errorCode, String? message]) =
      _Unauthorized;
}
