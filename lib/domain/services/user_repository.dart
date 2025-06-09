import 'package:tyman/data/models/app_user.dart';

abstract class UserRepository {
  Future<bool> createUser(String email);
  Future<AppUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(
      AppUser appUser, String name, String email, String photo);
}
