import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../common_widgets.dart/custom_button.dart';
import '../../common_widgets.dart/custom_text_formfield.dart';
import '../../theme/app_theme.dart';
import '../../util/value_validator.dart';
import '../home_screen.dart';
import '../signup/signup_screen.dart';
import 'signin_bloc/signin_bloc.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  void initState() {
    Future.delayed(
        const Duration(
          milliseconds: 100,
        ), () {
      User? currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninBloc(),
      child: BlocConsumer<SigninBloc, SigninState>(
        listener: (context, state) {
          if (state is SigninSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else if (state is SigninFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failed',
                description: state.message,
                primaryButton: 'Ok',
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      child: Image.asset(
                        'assets/images/cover_photo.jpg',
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign in',
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 5),
                          CustomTextFormField(
                            labelText: 'Enter Email',
                            controller: _emailController,
                            validator: emailValidator,
                            isLoading: state is SigninLoadingState,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Password',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                              enabled: state is! SigninLoadingState,
                              controller: _passwordController,
                              obscureText: isObscure,
                              validator: passwordValidator,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      isObscure = !isObscure;
                                      setState(() {});
                                    },
                                    icon: Icon(isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility)),
                                border: const OutlineInputBorder(),
                                hintText: 'Password',
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          CustomButton(
                            isLoading: state is SigninLoadingState,
                            inverse: true,
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                BlocProvider.of<SigninBloc>(context).add(
                                  SigninEvent(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                            label: 'Signin',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Create account?",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupScreen(),
                                      ));
                                },
                                child: Text(
                                  "Signup",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
