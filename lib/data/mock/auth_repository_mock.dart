import "../../core/app_config.dart";
import "../../domain/repositories/auth_repository.dart";
import "../local/storage_service.dart";

/// Mock Auth Repository - Backend tayyor bo'lgunicha test qilish uchun
class AuthRepositoryMock implements AuthRepository {
  AuthRepositoryMock(this.storage);

  final StorageService storage;

  // Mock foydalanuvchilar
  static const Map<String, Map<String, dynamic>> _mockUsers = {
    "admin@afruza.com": {
      "password": "admin123",
      "isAdmin": true,
      "token": "mock_admin_token_123",
    },
    "user@afruza.com": {
      "password": "user123",
      "isAdmin": false,
      "token": "mock_user_token_456",
    },
  };

  @override
  Future<void> login({required String email, required String password}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay - real API'dagi kabi
    await Future.delayed(const Duration(milliseconds: 500));

    final user = _mockUsers[email];
    if (user == null) {
      throw Exception("Foydalanuvchi topilmadi!");
    }

    if (user["password"] != password) {
      throw Exception("Parol noto'g'ri!");
    }

    // Token va admin statusni saqlash
    await storage.saveToken(user["token"] as String);
    await storage.saveIsAdmin(user["isAdmin"] as bool);
  }

  @override
  Future<void> register(
      {required String email, required String password}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_mockUsers.containsKey(email)) {
      throw Exception("Bu email allaqachon ro'yxatdan o'tgan!");
    }

    // Mock mode'da yangi foydalanuvchi qo'shilmaydi, faqat success qaytariladi
    // Real backend'da bu foydalanuvchi bazaga qo'shiladi
  }

  @override
  Future<void> registerAdmin(
      {required String email, required String password}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_mockUsers.containsKey(email)) {
      throw Exception("Bu email allaqachon ro'yxatdan o'tgan!");
    }

    // Mock mode'da admin qo'shilmaydi, faqat success qaytariladi
    // Real backend'da bu admin foydalanuvchi bazaga qo'shiladi
  }

  @override
  Future<void> logout() async {
    await storage.clearToken();
  }
}
