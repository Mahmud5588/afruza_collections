import "../repositories/user_repository.dart";

class UpdateUser {
  const UpdateUser(this.repository);

  final UserRepository repository;

  Future<void> call({required int userId, bool? isAdmin, bool? isActive}) {
    return repository.updateUser(
        userId: userId, isAdmin: isAdmin, isActive: isActive);
  }
}
