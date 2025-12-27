import 'package:tyman/domain/services/user_repository.dart';

class ToggleNotificationSettings {
  final UserRepository repository;

  ToggleNotificationSettings(this.repository);

  Future<void> call(String uid, bool isEnabled) async {
    return await repository.updateNotificationSettings(uid, isEnabled);
  }
}
