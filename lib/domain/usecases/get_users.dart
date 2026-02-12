import "../entities/user.dart";
import "../repositories/user_repository.dart";

class GetUsers {
  const GetUsers(this.repository);

  final UserRepository repository;

  Future<List<UserAccount>> call({int? skip, int? limit}) {
    return repository.fetchUsers(skip: skip, limit: limit);
  }
}
