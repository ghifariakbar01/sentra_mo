import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/value_validators.dart';
import 'errors.dart';
import 'failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  /// Throws [UnexpectedValueError] containing the [ValueFailure]
  T getOrCrash() {
    // id = identity - same as writing (right) => right
    return value.fold((f) => throw UnexpectedValueError(f), id);
  }

  /// Throws [UnexpectedValueError] containing the [ValueFailure]
  T getOrLeave(T defaultValue) {
    // id = identity - same as writing (right) => right
    return value.getOrElse(() => defaultValue);
  }

  Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
    return value.fold(
      left,
      (r) => right(unit),
    );
  }

  bool isValid() => value.isRight();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}

class UniqueId extends ValueObject<String> {
  factory UniqueId(String uniqueId) {
    return UniqueId._(
      validateStringNotEmpty(uniqueId),
    );
  }

  factory UniqueId.fromInteger(int uniqueId) {
    return UniqueId._(
      right(uniqueId.toString()),
    );
  }

  factory UniqueId.empty() => UniqueId('-');

  const UniqueId._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Email extends ValueObject<String> {
  factory Email(String input) {
    return Email._(
      validateStringNotEmpty(input).flatMap(validateEmail),
    );
  }

  const Email._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class NomorIdentitas extends ValueObject<String> {
  factory NomorIdentitas(String ktp) {
    return NomorIdentitas._(
      validateStringNotEmpty(ktp).flatMap(validateNomorIdentitas),
    );
  }

  factory NomorIdentitas.fromInteger(int nomorIdentitas) {
    return NomorIdentitas._(
      right(nomorIdentitas.toString()),
    );
  }

  const NomorIdentitas._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class UploadId extends ValueObject<String> {
  factory UploadId(String uploadId) {
    return UploadId._(
      validateStringNotEmpty(uploadId),
    );
  }

  const UploadId._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class PhoneNumber extends ValueObject<String> {
  factory PhoneNumber(String phoneNumber) {
    return PhoneNumber._(
      validateStringNotEmpty(phoneNumber).flatMap(validatePhone),
    );
  }

  factory PhoneNumber.fromInteger(int phoneNumber) {
    return PhoneNumber._(
      right(phoneNumber.toString()),
    );
  }

  factory PhoneNumber.empty() => PhoneNumber('-');

  const PhoneNumber._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Name extends ValueObject<String> {
  factory Name(String name) {
    return Name._(
      validateStringNotEmpty(name).flatMap(validateName),
    );
  }

  const Name._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Date extends ValueObject<String> {
  factory Date(String date) {
    return Date._(
      validateStringNotEmpty(date).flatMap(validateDate),
    );
  }

  factory Date.fromDate(DateTime date) {
    return Date._(right(date.toString()));
  }

  const Date._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Month extends ValueObject<String> {
  factory Month(String month) {
    return Month._(
      validateStringNotEmpty(month).flatMap(validateMonth),
    );
  }

  factory Month.fromDate(DateTime month) {
    return Month._(right(month.toString()));
  }

  const Month._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Year extends ValueObject<String> {
  factory Year(String year) {
    return Year._(
      validateStringNotEmpty(year).flatMap(validateYear),
    );
  }

  factory Year.fromDate(DateTime year) {
    return Year._(right(year.toString()));
  }

  const Year._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Notes extends ValueObject<String> {
  factory Notes(String notes) {
    return Notes._(validateStringNotEmpty(notes));
  }

  const Notes._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Photo extends ValueObject<String> {
  factory Photo(String photo) {
    return Photo._(validateStringNotEmpty(photo));
  }

  factory Photo.fromImage(XFile photo) {
    return Photo._(right(photo.toString()));
  }

  const Photo._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class DateReceived extends ValueObject<String> {
  factory DateReceived(String date) {
    return DateReceived._(validateStringNotEmpty(date));
  }

  const DateReceived._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class PaymentDesc extends ValueObject<String> {
  factory PaymentDesc(String paymentDesc) {
    return PaymentDesc._(validateStringNotEmpty(paymentDesc));
  }

  const PaymentDesc._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Amount extends ValueObject<String> {
  factory Amount(String amount) {
    return Amount._(validateStringNotEmpty(amount));
  }

  const Amount._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class NoMR extends ValueObject<String> {
  factory NoMR(String noMr) {
    return NoMR._(validateStringNotEmpty(noMr));
  }

  const NoMR._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
