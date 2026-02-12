import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "../../../domain/usecases/login_user.dart";
import "../../../domain/usecases/register_user.dart";
import "../../../data/remote/api_exception.dart";

part "auth_event.dart";
part "auth_state.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._loginUser, this._registerUser) : super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  final LoginUser _loginUser;
  final RegisterUser _registerUser;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    try {
      await _loginUser(email: event.email, password: event.password);
      emit(state.copyWith(status: AuthStatus.success));
    } catch (error) {
      final message = error is ApiException ? error.message : "Login failed";
      emit(state.copyWith(status: AuthStatus.failure, message: message));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    try {
      await _registerUser(email: event.email, password: event.password);
      await _loginUser(email: event.email, password: event.password);
      emit(state.copyWith(status: AuthStatus.success, message: "Account created"));
    } catch (error) {
      final message = error is ApiException ? error.message : "Register failed";
      emit(state.copyWith(status: AuthStatus.failure, message: message));
    }
  }
}
