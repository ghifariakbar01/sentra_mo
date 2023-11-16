part of 'sign_in_form_notifier.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required UserId userId,
    required Password password,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<AuthFailure, Unit>> failureOrSuccessOption,
  }) = _SignInFormState;

  factory SignInFormState.initial() => SignInFormState(
        userId: UserId(''),
        password: Password(''),
        showErrorMessages: false,
        isSubmitting: false,
        failureOrSuccessOption: none(),
      );
}
