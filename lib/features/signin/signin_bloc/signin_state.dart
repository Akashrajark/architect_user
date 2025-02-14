part of 'signin_bloc.dart';

@immutable
sealed class SigninState {}

final class SigninInitial extends SigninState {}

final class SigninSuccessState extends SigninState {}

final class SigninLoadingState extends SigninState {}

final class SigninFailureState extends SigninState {
  final String message;

  SigninFailureState({this.message = apiErrorMessage});
}
