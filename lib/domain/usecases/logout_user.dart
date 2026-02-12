import "../repositories/auth_repository.dart";

class LogoutUser {
  const LogoutUser(this.repository);

  final AuthRepository repository;

  Future<void> call() {
    return repository.logout();
  }
}
