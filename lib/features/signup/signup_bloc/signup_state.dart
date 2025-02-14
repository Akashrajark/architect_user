part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

final class SignUpSuccessState extends SignupState {}

final class SignUpLoadingState extends SignupState {}

final class SignUpFailureState extends SignupState {
  final String message;

  SignUpFailureState({this.message = apiErrorMessage});
}
