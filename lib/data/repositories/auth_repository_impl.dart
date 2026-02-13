import "package:dio/dio.dart";

import "../../core/logger.dart\";\nimport \"../../core/security/token_security.dart\";\nimport \"../local/storage_service.dart\";\nimport \"../models/auth_token_model.dart\";\nimport \"../remote/error_mapper.dart\";\nimport \"../../domain/repositories/auth_repository.dart\";

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.dio, this.storage);

  final Dio dio;
  final StorageService storage;

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      AppLogger.info("Login attempt for: $email");
      final response = await dio.post(
        "/auth/login",
        data: FormData.fromMap({
          "username": email,
          "password": password,
        }),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      await _storeSession(response.data as Map<String, dynamic>);
      AppLogger.success("Login successful for: $email");
    } on DioException catch (error) {
      AppLogger.error("Login failed for: $email", error: error);
      throw mapDioError(error);
    }
  }

  @override
  Future<void> register(
      {required String email, required String password}) async {
    try {
      AppLogger.info("Registration attempt for: $email");
      await dio.post(
        "/auth/register",
        data: {
          "email": email,
          "password": password,
          "is_admin": false,
        },
      );
      AppLogger.success("Registration successful for: $email");
    } on DioException catch (error) {
      AppLogger.error("Registration failed for: $email", error: error);
      throw mapDioError(error);
    }
  }

  @override
  Future<void> logout() async {
    AppLogger.info("User logged out");
    return storage.clearToken();
  }

  Future<void> _storeSession(Map<String, dynamic> data) async {
    final token = AuthTokenModel.fromJson(data);

    // Validate token format before storing
    if (!TokenSecurity.isValidTokenFormat(token.accessToken)) {
      AppLogger.error(\"Invalid access token format received from server\");
      throw Exception(\"Invalid token format\");
    }

    if (token.refreshToken != null &&
        !TokenSecurity.isValidTokenFormat(token.refreshToken!)) {
      AppLogger.error(\"Invalid refresh token format received from server\");
      throw Exception(\"Invalid refresh token format\");
    }

    await storage.saveToken(token.accessToken);
    if (token.refreshToken != null) {
      await storage.saveRefreshToken(token.refreshToken!);
    }

    AppLogger.debug("Fetching user profile...");
    final me = await dio.get("/users/me");
    final payload = me.data as Map<String, dynamic>;
    final isAdmin = payload["is_admin"] as bool? ?? false;
    await storage.saveIsAdmin(isAdmin);
    AppLogger.debug("Session stored. isAdmin: $isAdmin");
  }
}
