import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../common_widgets.dart/custom_button.dart';
import '../../util/value_validator.dart';
import '../signin/signin_screen.dart';
import 'reset_password_bloc/reset_password_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cPassController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              child: BlocProvider<ResetPasswordBloc>(
                create: (context) => ResetPasswordBloc(),
                child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
                  listener: (context, state) async {
                    if (state is ResetPasswordSuccessState) {
                      await showDialog(
                        context: context,
                        builder: (context) => const CustomAlertDialog(
                          title: 'Success',
                          description: 'Password reset successfully, you will be automatically logged in now.',
                          primaryButton: 'OK',
                        ),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const SigninScreen()),
                        (route) => false,
                      );
                    } else if (state is ResetPasswordFailureState) {
                      showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                          title: 'Failure',
                          description: state.message,
                          primaryButton: 'OK',
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reset Password",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Enter the OTP you received through email and the new password to reset the password.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _otpController,
                            enabled: state is! ResetPasswordLoadingState,
                            validator: notEmptyValidator,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.password,
                              ),
                              hintText: 'OTP',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passController,
                            obscureText: _isObscure,
                            enabled: state is! ResetPasswordLoadingState,
                            validator: notEmptyValidator,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _isObscure = !_isObscure;
                                  setState(() {});
                                },
                                icon: Icon(
                                  _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                ),
                              ),
                              hintText: 'Password',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _cPassController,
                            obscureText: _isObscure,
                            enabled: state is! ResetPasswordLoadingState,
                            validator: (value) => confirmPasswordValidator(value, _passController.text.trim()),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                              ),
                              hintText: 'Confirm Password',
                            ),
                          ),
                          const SizedBox(height: 15),
                          CustomButton(
                            isLoading: state is ResetPasswordLoadingState,
                            label: 'CONTINUE',
                            inverse: true,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<ResetPasswordBloc>(context).add(
                                  ResetPasswordEvent(
                                      email: widget.email,
                                      otp: _otpController.text.trim(),
                                      password: _passController.text.trim()),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
