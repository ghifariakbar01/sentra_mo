import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_response.freezed.dart';

@freezed
class UpdateResponse with _$UpdateResponse {
  const factory UpdateResponse.success() = _Success;
  const factory UpdateResponse.failure([int? code, String? message]) = _Failure;
}
