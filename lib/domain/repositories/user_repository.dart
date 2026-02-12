import "../entities/user.dart";

abstract class UserRepository {
  Future<List<UserAccount>> fetchUsers({int? skip, int? limit});
  Future<void> updateUser({required int userId, bool? isAdmin, bool? isActive});
  Future<void> deleteUser({required int userId});
  Future<void> updateMe({String? email, String? password});
}
