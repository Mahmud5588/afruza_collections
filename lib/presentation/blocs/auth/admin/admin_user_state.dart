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
    Object? message = _undefined,
  }) {
    return AdminUserState(
      status: status ?? this.status,
      users: users ?? this.users,
      message: message == _undefined ? this.message : message as String?,
    );
  }

  @override
  List<Object?> get props => [status, users, message];
}

const _undefined = Object();
