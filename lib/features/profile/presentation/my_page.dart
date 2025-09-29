import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tyman/core/providers/auth_providers.dart';
import 'package:tyman/core/providers/task_providers.dart';
import 'package:tyman/core/providers/user_provider.dart';
import 'package:tyman/core/utils/snackbar_helper.dart';
import 'package:tyman/core/widgets/app_bottom_nav_bar.dart';
import 'package:tyman/core/widgets/custom_text_field.dart';
import 'dart:io';
import 'package:tyman/core/constants/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:tyman/data/models/app_user.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => MyPageState();
}

class MyPageState extends ConsumerState<MyPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? _loadedUserId;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(AppUser appUser) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select image source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
    if (source == null) return;

    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return;

    final file = File(picked.path);

    try {
      final uploadProfileImage = ref.read(uploadProfileImageProvider);
      final updateProfile = ref.read(updateProfileProvider);
      final downloadUrl = await uploadProfileImage(file);
      await updateProfile(
        appUser,
        nameController.text,
        emailController.text,
        downloadUrl,
      );
      appUser.photo = downloadUrl;
      await _refreshUserProfile();
      if (mounted) {
        showSnackBar(context, 'Profile picture updated successfully');
      }
    } catch (e) {
      if (mounted) showSnackBar(context, 'Upload failed: $e');
      return;
    }
  }

  Future<void> _updateProfile(AppUser appUser) async {
    try {
      final updateProfile = ref.read(updateProfileProvider);
      await updateProfile(
        appUser,
        nameController.text,
        emailController.text,
        appUser.photo,
      );
      await _refreshUserProfile();
      if (mounted) {
        showSnackBar(context, 'Profile updated successfully');
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error updating profile: $e');
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await ref.read(signOutProvider)(context);
      ref.invalidate(userProfileProvider);
      ref.invalidate(taskCountsProvider);
      ref.invalidate(tasksForTodayProvider);
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Error signing out. Try again.');
      }
    }
  }

  Future<void> _refreshUserProfile() async {
    ref.invalidate(userProfileProvider);
    try {
      await ref.read(userProfileProvider.future);
    } catch (_) {}
  }

  ImageProvider _getImageProvider(String photoUrl) {
    if (photoUrl.isEmpty)
      return const AssetImage('assets/images/userAvatar.png');
    if (photoUrl.startsWith('http')) {
      return NetworkImage(photoUrl);
    } else if (photoUrl.startsWith('assets/')) {
      return AssetImage(photoUrl);
    } else {
      try {
        final file = File(photoUrl);
        if (file.existsSync() && file.lengthSync() > 0) return FileImage(file);
      } catch (_) {}
      return const AssetImage('assets/images/userAvatar.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (appUser) {
        if (appUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (_loadedUserId != appUser.uid) {
          nameController.text = appUser.name;
          emailController.text = appUser.email;
          _loadedUserId = appUser.uid;
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              tileMode: TileMode.mirror,
              colors: [
                designBlack,
                designGreyDark,
                designGrey,
                designGreyLight,
                designWhiteGrey,
              ],
              transform: GradientRotation(pi / 4),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('My Profile',
                  style: TextStyle(color: Colors.white, fontSize: 22)),
              centerTitle: true,
            ),
            body: _buildProfileContent(appUser),
            bottomNavigationBar: AppBottomNavBar(
                currentIndex: 1,
                onTap: (index) {
                  if (index == 0) {
                    context.go('/home');
                  }
                }),
          ),
        );
      },
    );
  }

  Widget _buildProfileContent(AppUser appUser) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => _pickImage(appUser),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _getImageProvider(appUser.photo),
                    backgroundColor: Colors.transparent,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CupertinoColors.systemGrey.withOpacity(0.7),
                      ),
                      child: const Icon(CupertinoIcons.camera,
                          size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
                controller: nameController, label: 'Name', enabled: true),
            const SizedBox(height: 20),
            CustomTextField(
                controller: emailController, label: 'Email', enabled: false),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  onPressed: () => _updateProfile(appUser),
                  color: CupertinoColors.systemGrey3,
                  child: const Text('Update Profile'),
                ),
                CupertinoButton(
                  onPressed: () => _signOut(context),
                  color: CupertinoColors.darkBackgroundGray,
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
