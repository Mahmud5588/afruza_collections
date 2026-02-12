part of "admin_user_bloc.dart";

class AdminUserState extends Equatable {
  const AdminUserState({
    this.status = AdminUserStatus.initial,
    this.users = const [],
    this.message,
  });

  final AdminUserStatus status;
  final List<UserAccount> users;
  final String? message;

  AdminUserState copyWith({
    AdminUserStatus? status,
    List<UserAccount>? users,
    String? message,
  }) {
    return AdminUserState(
      status: status ?? this.status,
      users: users ?? this.users,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, users, message];
}
