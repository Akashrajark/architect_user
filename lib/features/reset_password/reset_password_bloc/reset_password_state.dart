part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordState {}

class ResetPasswordInitialState extends ResetPasswordState {}

class ResetPasswordLoadingState extends ResetPasswordState {}

class ResetPasswordSuccessState extends ResetPasswordState {}

class ResetPasswordFailureState extends ResetPasswordState {
  final String message;

  ResetPasswordFailureState({this.message = apiErrorMessage});
}
