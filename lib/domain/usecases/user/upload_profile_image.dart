import 'dart:io';
import 'package:tyman/domain/services/user_repository.dart';

class UploadProfileImage {
  final UserRepository repository;

  UploadProfileImage(this.repository);

  Future<String> call(File imageFile) async {
    return await repository.uploadProfileImage(imageFile);
  }
}
