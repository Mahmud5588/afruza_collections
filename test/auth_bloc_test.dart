import "package:bloc_test/bloc_test.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

import "package:afruza_collection_mobile/data/remote/api_exception.dart";
import "package:afruza_collection_mobile/domain/repositories/auth_repository.dart";
import "package:afruza_collection_mobile/domain/usecases/login_user.dart";
import "package:afruza_collection_mobile/domain/usecases/register_user.dart";
import "package:afruza_collection_mobile/presentation/blocs/auth/auth_bloc.dart";

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late AuthBloc bloc;

  setUp(() {
    repository = MockAuthRepository();
    bloc = AuthBloc(LoginUser(repository), RegisterUser(repository));
  });

  tearDown(() {
    bloc.close();
  });

  blocTest<AuthBloc, AuthState>(
    "emits loading then success on login",
    build: () {
      when(
        () => repository.login(
          email: any(named: "email"),
          password: any(named: "password"),
        ),
      ).thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(
        const LoginSubmitted(email: "user@test.com", password: "password123")),
    expect: () => [
      const AuthState(status: AuthStatus.loading, message: null),
      const AuthState(status: AuthStatus.success, message: null),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    "emits loading then failure on login error",
    build: () {
      when(
        () => repository.login(
          email: any(named: "email"),
          password: any(named: "password"),
        ),
      ).thenThrow(ApiException("Invalid credentials"));
      return bloc;
    },
    act: (bloc) =>
        bloc.add(const LoginSubmitted(email: "user@test.com", password: "bad")),
    expect: () => [
      const AuthState(status: AuthStatus.loading, message: null),
      const AuthState(
          status: AuthStatus.failure, message: "Invalid credentials"),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    "emits loading then success on register",
    build: () {
      when(
        () => repository.register(
          email: any(named: "email"),
          password: any(named: "password"),
        ),
      ).thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(const RegisterSubmitted(
        email: "new@test.com", password: "password123")),
    expect: () => [
      const AuthState(status: AuthStatus.loading, message: null),
      const AuthState(status: AuthStatus.success, message: "Account created"),
    ],
  );
}
