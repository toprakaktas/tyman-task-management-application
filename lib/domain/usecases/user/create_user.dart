import 'package:tyman/domain/services/user_repository.dart';

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<bool> call(String email) async {
    return await repository.createUser(email);
  }
}
