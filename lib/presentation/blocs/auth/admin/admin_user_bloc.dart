import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "../../../../domain/entities/user.dart";
import "../../../../domain/usecases/delete_user.dart";
import "../../../../domain/usecases/get_users.dart";
import "../../../../domain/usecases/update_user.dart";
import "../../../../data/remote/api_exception.dart";

part "admin_user_event.dart";
part "admin_user_state.dart";

class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  AdminUserBloc(this._getUsers, this._updateUser, this._deleteUser)
      : super(const AdminUserState()) {
    on<LoadAdminUsers>(_onLoadUsers);
    on<ToggleAdminRole>(_onToggleAdmin);
    on<ToggleUserActive>(_onToggleActive);
    on<DeleteAdminUser>(_onDeleteUser);
  }

  final GetUsers _getUsers;
  final UpdateUser _updateUser;
  final DeleteUser _deleteUser;

  Future<void> _onLoadUsers(
    LoadAdminUsers event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(state.copyWith(status: AdminUserStatus.loading, message: null));
    try {
      final users = await _getUsers();
      emit(state.copyWith(status: AdminUserStatus.success, users: users));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to load users";
      emit(state.copyWith(status: AdminUserStatus.failure, message: message));
    }
  }

  Future<void> _onToggleAdmin(
    ToggleAdminRole event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(state.copyWith(status: AdminUserStatus.loading, message: null));
    try {
      await _updateUser(userId: event.userId, isAdmin: event.isAdmin);
      final users = await _getUsers();
      emit(state.copyWith(status: AdminUserStatus.success, users: users));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to update user";
      emit(state.copyWith(status: AdminUserStatus.failure, message: message));
    }
  }

  Future<void> _onToggleActive(
    ToggleUserActive event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(state.copyWith(status: AdminUserStatus.loading, message: null));
    try {
      await _updateUser(userId: event.userId, isActive: event.isActive);
      final users = await _getUsers();
      emit(state.copyWith(status: AdminUserStatus.success, users: users));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to update user";
      emit(state.copyWith(status: AdminUserStatus.failure, message: message));
    }
  }

  Future<void> _onDeleteUser(
    DeleteAdminUser event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(state.copyWith(status: AdminUserStatus.loading, message: null));
    try {
      await _deleteUser(userId: event.userId);
      final users = await _getUsers();
      emit(state.copyWith(status: AdminUserStatus.success, users: users));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to delete user";
      emit(state.copyWith(status: AdminUserStatus.failure, message: message));
    }
  }
}
