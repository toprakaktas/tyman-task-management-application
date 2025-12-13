import 'package:tyman/data/models/app_user.dart';
import 'package:tyman/domain/services/user_repository.dart';

class GetUserStream {
  final UserRepository repository;

  GetUserStream(this.repository);

  Stream<AppUser?> call(String uid) {
    return repository.getUserStream(uid);
  }
}
