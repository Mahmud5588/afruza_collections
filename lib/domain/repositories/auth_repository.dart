abstract class AuthRepository {
  Future<void> login({required String email, required String password});
  Future<void> register({required String email, required String password});

  /// TEMPORARY: Register admin user (DEVELOPMENT ONLY)
  /// In production, admins should be created from backend
  Future<void> registerAdmin({required String email, required String password});

  Future<void> logout();
}
