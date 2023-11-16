import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_failure.freezed.dart';

@freezed
class UploadFailure with _$UploadFailure {
  const factory UploadFailure.pickingFailed({int? errorCode, String? message}) =
      _PickingFailed;
  const factory UploadFailure.cameraFailed() = _CameraFailed;
}
