import "package:dio/dio.dart";

import "../local/storage_service.dart";
import "../models/auth_token_model.dart";
import "../remote/error_mapper.dart";
import "../../domain/repositories/auth_repository.dart";

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.dio, this.storage);

  final Dio dio;
  final StorageService storage;

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        "/auth/login",
        data: FormData.fromMap({
          "username": email,
          "password": password,
        }),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      await _storeSession(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> register(
      {required String email, required String password}) async {
    try {
      await dio.post(
        "/auth/register",
        data: {
          "email": email,
          "password": password,
          "is_admin": false,
        },
      );
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> logout() {
    return storage.clearToken();
  }

  Future<void> _storeSession(Map<String, dynamic> data) async {
    final token = AuthTokenModel.fromJson(data);
    await storage.saveToken(token.accessToken);

    final me = await dio.get("/users/me");
    final payload = me.data as Map<String, dynamic>;
    final isAdmin = payload["is_admin"] as bool? ?? false;
    await storage.saveIsAdmin(isAdmin);
  }
}
