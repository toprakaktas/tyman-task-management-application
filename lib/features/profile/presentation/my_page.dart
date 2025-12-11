import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tyman/core/providers/auth_providers.dart';
import 'package:tyman/core/providers/task_providers.dart';
import 'package:tyman/core/providers/user_provider.dart';
import 'package:tyman/core/utils/image_utils.dart';
import 'package:tyman/core/utils/snackbar_helper.dart';
import 'package:tyman/core/widgets/app_bottom_nav_bar.dart';
import 'package:tyman/core/widgets/cached_user_avatar.dart';
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
      final compressedFile = await compressImage(file);

      final uploadProfileImage = ref.read(uploadProfileImageProvider);
      final updateProfile = ref.read(updateProfileProvider);
      final downloadUrl = await uploadProfileImage(compressedFile);

      try {
        await compressedFile.delete();
      } catch (_) {}

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
      if (mounted) {
        showSnackBar(context, 'Upload failed: $e');
      }
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

        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('My Profile',
                style: TextStyle(color: Colors.white, fontSize: 22)),
            centerTitle: true,
          ),
          body: Container(
              decoration: BoxDecoration(
                  gradient: BackgroundDecoration.getGradient(context)),
              child: _buildProfileContent(appUser, context)),
          bottomNavigationBar: AppBottomNavBar(
              currentIndex: 1,
              onTap: (index) {
                if (index == 0) {
                  context.go('/home');
                }
              }),
        );
      },
    );
  }

  Widget _buildProfileContent(AppUser appUser, BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 25,
          children: <Widget>[
            GestureDetector(
              onTap: () => _pickImage(appUser),
              child: Stack(
                children: [
                  CachedUserAvatar(photoUrl: appUser.photo, size: 135),
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
            TextField(
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              controller: nameController,
              cursorOpacityAnimates: true,
              enabled: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                labelText: 'Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.tertiary),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: TextStyle(
                  color: theme.textTheme.bodyMedium!.color,
                  fontWeight: theme.textTheme.bodyMedium!.fontWeight,
                  fontSize: theme.textTheme.bodyMedium!.fontSize),
            ),
            TextField(
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              controller: emailController,
              readOnly: true,
              enableInteractiveSelection: false,
              style: TextStyle(
                  color: theme.textTheme.bodyMedium!.color,
                  fontWeight: theme.textTheme.bodyMedium!.fontWeight,
                  fontSize: theme.textTheme.bodyMedium!.fontSize),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                labelText: 'E-mail',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.tertiary),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _updateProfile(appUser),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.buttonTheme.colorScheme?.onPrimary,
                    backgroundColor: theme.buttonTheme.colorScheme?.primary,
                  ),
                  child: Text('Update Profile',
                      style: TextStyle(
                          color: theme.textTheme.bodyMedium!.color,
                          fontWeight: theme.textTheme.labelLarge!.fontWeight,
                          fontSize: theme.textTheme.labelLarge!.fontSize)),
                ),
                ElevatedButton(
                  onPressed: () => _signOut(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).buttonTheme.colorScheme?.onSecondary,
                    backgroundColor:
                        Theme.of(context).buttonTheme.colorScheme?.secondary,
                  ),
                  child: Text('Sign Out',
                      style: TextStyle(
                          color: theme.textTheme.bodyMedium!.color,
                          fontWeight: theme.textTheme.labelLarge!.fontWeight,
                          fontSize: theme.textTheme.labelLarge!.fontSize)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
