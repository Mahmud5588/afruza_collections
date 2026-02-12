import "../../core/app_config.dart";
import "../../domain/entities/user.dart";
import "../../domain/repositories/user_repository.dart";
import "mock_data_source.dart";

/// Mock User Repository - Backend tayyor bo'lgunicha test qilish uchun
class UserRepositoryMock implements UserRepository {
  static final List<UserAccount> _users = List.from(MockDataSource.users);

  @override
  Future<List<UserAccount>> fetchUsers({int? skip, int? limit}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    final skipValue = skip ?? 0;
    final limitValue = limit ?? _users.length;

    return _users.skip(skipValue).take(limitValue).toList();
  }

  @override
  Future<void> updateUser({
    required int userId,
    bool? isAdmin,
    bool? isActive,
  }) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _users.indexWhere((u) => u.id == userId);
    if (index == -1) {
      throw Exception("Foydalanuvchi topilmadi!");
    }

    final user = _users[index];
    _users[index] = UserAccount(
      id: user.id,
      email: user.email,
      isAdmin: isAdmin ?? user.isAdmin,
      isActive: isActive ?? user.isActive,
    );
  }

  @override
  Future<void> deleteUser({required int userId}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    _users.removeWhere((u) => u.id == userId);
  }

  @override
  Future<void> updateMe({String? email, String? password}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock mode'da profil yangilash faqat success qaytaradi
    // Real backend'da bu haqiqiy yangilanadi
  }
}
