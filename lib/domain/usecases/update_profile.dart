import "../repositories/user_repository.dart";

class UpdateProfile {
  const UpdateProfile(this.repository);

  final UserRepository repository;

  Future<void> call({String? email, String? password}) {
    return repository.updateMe(email: email, password: password);
  }
}
