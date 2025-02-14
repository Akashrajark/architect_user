part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

class SignUpUserEvent extends SignupEvent {
  final String email, password;
  final Map userDetails;

  SignUpUserEvent({
    required this.email,
    required this.password,
    required this.userDetails,
  });
}

class GetStreamsEvent extends SignupEvent {}
