import 'package:freezed_annotation/freezed_annotation.dart';

part 'input_response.freezed.dart';

@freezed
class InputResponse with _$InputResponse {
  const factory InputResponse.withNumber([String? number]) = _WithNumber;
  const factory InputResponse.empty() = _Empty;
  const factory InputResponse.failure([int? errorCode, String? message]) =
      _Failure;
}
