import "../repositories/auth_repository.dart";

class RegisterUser {
  const RegisterUser(this.repository);

  final AuthRepository repository;

  Future<void> call({required String email, required String password}) {
    return repository.register(email: email, password: password);
  }
}
