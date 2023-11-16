import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_failure.freezed.dart';

@freezed
class RemoteFailure with _$RemoteFailure {
  const factory RemoteFailure.storage() = _Storage;
  const factory RemoteFailure.parse({String? message}) = _Parse;
  const factory RemoteFailure.noConnection() = _NoConnection;
  const factory RemoteFailure.server([int? errorCode, String? message]) =
      _Server;
}
