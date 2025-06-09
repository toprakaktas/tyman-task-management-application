import 'package:tyman/data/models/app_user.dart';
import 'package:tyman/domain/services/user_repository.dart';

class UpdateProfile {
  final UserRepository repository;

  UpdateProfile(this.repository);

  Future<void> call(
      AppUser appUser, String name, String email, String photo) async {
    await repository.updateProfile(appUser, name, email, photo);
  }
}
