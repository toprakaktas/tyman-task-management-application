import 'package:tyman/data/models/app_user.dart';
import 'package:tyman/domain/services/user_repository.dart';

class FetchUserProfile {
  final UserRepository repository;

  FetchUserProfile(this.repository);

  Future<AppUser?> call(String uid) async {
    return await repository.fetchUserProfile(uid);
  }
}
