part of 'reset_password_bloc.dart';

class ResetPasswordEvent {
  final String email, otp, password;

  ResetPasswordEvent({
    required this.otp,
    required this.email,
    required this.password,
  });
}
