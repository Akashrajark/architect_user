import 'package:bloc/bloc.dart';
import 'package:dream_home_user/values/strings.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(SigninInitial()) {
    on<SigninEvent>((event, emit) async {
      try {
        emit(SigninLoadingState());

        await Supabase.instance.client.auth.signInWithPassword(
          password: event.password,
          email: event.email,
        );
        emit(SigninSuccessState());
      } catch (e, s) {
        Logger().e('$e\n$s');

        if (e is AuthException) {
          emit(SigninFailureState(message: e.message));
        } else {
          emit(SigninFailureState());
        }
      }
    });
  }
}
