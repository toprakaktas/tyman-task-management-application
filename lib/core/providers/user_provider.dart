import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyman/core/providers/auth_providers.dart';
import 'package:tyman/data/models/app_user.dart';
import 'package:tyman/data/services/user_service.dart';
import 'package:tyman/domain/usecases/user/fetch_user_profile.dart';
import 'package:tyman/domain/usecases/user/update_profile.dart';
import 'package:tyman/domain/usecases/user/upload_profile_image.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

final fetchUserProfileProvider = Provider<FetchUserProfile>(
    (ref) => FetchUserProfile(ref.read(userServiceProvider)));

final updateProfileProvider = Provider<UpdateProfile>(
    (ref) => UpdateProfile(ref.read(userServiceProvider)));

final uploadProfileImageProvider = Provider<UploadProfileImage>(
    (ref) => UploadProfileImage(ref.read(userServiceProvider)));

final userProfileProvider = FutureProvider<AppUser?>((ref) async {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return null;
  return ref.read(fetchUserProfileProvider)(authUser.uid);
});
