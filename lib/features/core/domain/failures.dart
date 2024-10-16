import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.exceedingLength({
    required T failedValue,
    required int max,
  }) = ExceedingLength<T>;
  const factory ValueFailure.empty({
    required T failedValue,
  }) = Empty<T>;
  const factory ValueFailure.multiline({
    required T failedValue,
  }) = Multiline<T>;
  const factory ValueFailure.invalidEmail({
    required T failedValue,
  }) = InvalidEmail<T>;
  const factory ValueFailure.shortPassword({
    required T failedValue,
  }) = ShortPassword<T>;
  const factory ValueFailure.invalidNomorIdentitas({
    required T failedValue,
  }) = InvalidNomorIdentitas<T>;
  const factory ValueFailure.invalidPhone({
    required T failedValue,
  }) = InvalidPhone<T>;
  const factory ValueFailure.invalidDate({
    required T failedValue,
  }) = InvalidDate<T>;
  const factory ValueFailure.invalidMonth({
    required T failedValue,
  }) = InvalidMonth<T>;
  const factory ValueFailure.invalidYear({
    required T failedValue,
  }) = InvalidYear<T>;
  const factory ValueFailure.invalidName({
    required T failedValue,
  }) = InvalidName<T>;
}
