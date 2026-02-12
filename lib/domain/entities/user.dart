class UserAccount {
  final int id;
  final String email;
  final bool isAdmin;
  final bool isActive;

  const UserAccount({
    required this.id,
    required this.email,
    required this.isAdmin,
    required this.isActive,
  });
}
