import "package:dio/dio.dart";

import "../../domain/entities/user.dart";
import "../../domain/repositories/user_repository.dart";
import "../models/user_model.dart";
import "../remote/error_mapper.dart";

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<UserAccount>> fetchUsers({int? skip, int? limit}) async {
    try {
      final response = await dio.get(
        "/users",
        queryParameters: {
          if (skip != null) "skip": skip,
          if (limit != null) "limit": limit,
        },
      );
      final data = response.data as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(UserModel.fromJson)
          .map((model) => model.toEntity())
          .toList();
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> updateUser(
      {required int userId, bool? isAdmin, bool? isActive}) async {
    try {
      await dio.patch(
        "/users/$userId",
        data: {
          if (isAdmin != null) "is_admin": isAdmin,
          if (isActive != null) "is_active": isActive,
        },
      );
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> deleteUser({required int userId}) async {
    try {
      await dio.delete("/users/$userId");
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> updateMe({String? email, String? password}) async {
    try {
      await dio.patch(
        "/users/me",
        data: {
          if (email != null) "email": email,
          if (password != null) "password": password,
        },
      );
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
