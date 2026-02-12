import "../repositories/auth_repository.dart";

class LoginUser {
  const LoginUser(this.repository);

  final AuthRepository repository;

  Future<void> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
