part of "admin_user_bloc.dart";

enum AdminUserStatus { initial, loading, success, failure }

abstract class AdminUserEvent extends Equatable {
  const AdminUserEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminUsers extends AdminUserEvent {
  const LoadAdminUsers();
}

class ToggleAdminRole extends AdminUserEvent {
  const ToggleAdminRole({required this.userId, required this.isAdmin});

  final int userId;
  final bool isAdmin;

  @override
  List<Object?> get props => [userId, isAdmin];
}

class ToggleUserActive extends AdminUserEvent {
  const ToggleUserActive({required this.userId, required this.isActive});

  final int userId;
  final bool isActive;

  @override
  List<Object?> get props => [userId, isActive];
}

class DeleteAdminUser extends AdminUserEvent {
  const DeleteAdminUser({required this.userId});

  final int userId;

  @override
  List<Object?> get props => [userId];
}
