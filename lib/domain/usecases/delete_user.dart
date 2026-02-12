import "../repositories/user_repository.dart";

class DeleteUser {
  const DeleteUser(this.repository);

  final UserRepository repository;

  Future<void> call({required int userId}) {
    return repository.deleteUser(userId: userId);
  }
}
