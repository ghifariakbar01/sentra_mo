import 'package:dartz/dartz.dart';

import '../features/core/domain/failures.dart';

Either<ValueFailure<String>, String> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(
      ValueFailure.exceedingLength(failedValue: input, max: maxLength),
    );
  }
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(ValueFailure.empty(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (input.contains('\n')) {
    return left(ValueFailure.multiline(failedValue: input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validateEmail(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 4) {
    return right(input);
  } else {
    return left(ValueFailure.shortPassword(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateNomorIdentitas(String input) {
  if (input.length > 3) {
    return right(input);
  } else {
    return left(ValueFailure.invalidNomorIdentitas(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validatePhone(String input) {
  const phoneRegex = r'''^(\+62|62|0)8[1-9][0-9]{6,9}$''';
  if (RegExp(phoneRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidPhone(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateDate(String input) {
  final date = int.parse(input);
  if (1 <= date && date <= 31) {
    return right(input);
  } else {
    return left(ValueFailure.invalidDate(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateMonth(String input) {
  final month = int.parse(input);
  if (1 <= month && month <= 12) {
    return right(input);
  } else {
    return left(ValueFailure.invalidMonth(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateYear(String input) {
  final year = int.parse(input);
  if (1900 <= year && year <= 2100) {
    return right(input);
  } else {
    return left(ValueFailure.invalidYear(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateName(String input) {
  const nameRegex = r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
  const oneSyllableNameRegex = r"^[A-Za-z'\-]+$";

  if (RegExp(nameRegex).hasMatch(input) ||
      RegExp(oneSyllableNameRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidName(failedValue: input));
  }
}
