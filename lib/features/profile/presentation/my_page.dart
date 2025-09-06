import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tyman/core/utils/snackbar_helper.dart';
import 'package:tyman/core/widgets/app_bottom_nav_bar.dart';
import 'package:tyman/core/widgets/custom_text_field.dart';
import 'package:tyman/data/services/auth_service.dart';
import 'package:tyman/data/services/task_service.dart';
import 'dart:io';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/data/services/user_service.dart';
import 'package:tyman/domain/usecases/auth/sign_in.dart';
import 'package:tyman/domain/usecases/auth/sign_out.dart';
import 'package:tyman/domain/usecases/task/add_task.dart';
import 'package:tyman/domain/usecases/task/fetch_task_counts_for_categories.dart';
import 'package:tyman/domain/usecases/user/fetch_user_profile.dart';
import 'package:tyman/domain/usecases/user/update_profile.dart';
import 'package:tyman/domain/usecases/user/upload_profile_image.dart';
import 'package:tyman/features/authentication/presentation/sign_in_page.dart';
import 'package:tyman/features/tasks/presentation/home_page.dart';
import 'package:tyman/data/models/app_user.dart';

class MyPage extends StatefulWidget {
  final FetchUserProfile fetchUserProfile;
  final UpdateProfile updateProfile;
  final SignOut signOut;
  final UploadProfileImage uploadProfileImage;

  const MyPage({
    super.key,
    required this.fetchUserProfile,
    required this.updateProfile,
    required this.signOut,
    required this.uploadProfileImage,
  });

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  AppUser? appUser;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final user = await widget.fetchUserProfile(firebaseUser!.uid);
    if (mounted) {
      if (user == null) {
        FirebaseAuth.instance.signOut();
        return;
      }
      setState(() {
        appUser = user;
        nameController.text = appUser!.name;
        emailController.text = appUser!.email;
      });
    }
  }

  Future<void> _pickImage() async {
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
      final downloadUrl = await widget.uploadProfileImage(file);
      setState(() => appUser!.photo = downloadUrl);
      await widget.updateProfile(
        appUser!,
        nameController.text,
        emailController.text,
        downloadUrl,
      );
      if (mounted) {
        showSnackBar(context, 'Profile picture updated successfully');
      }
    } catch (e) {
      if (mounted) showSnackBar(context, 'Upload failed: $e');
      return;
    }
  }

  Future<void> _updateProfile() async {
    try {
      await widget.updateProfile(
        appUser!,
        nameController.text,
        emailController.text,
        appUser!.photo,
      );
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
      await widget.signOut(context);
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Error signing out. Try again.');
      }
    }
  }

  ImageProvider _getImageProvider(String photoUrl) {
    if (photoUrl.startsWith('http')) {
      return NetworkImage(photoUrl);
    } else if (photoUrl.startsWith('assets/')) {
      return AssetImage(photoUrl);
    } else {
      return FileImage(File(photoUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appUser == null) {
      return SignInPage(() {}, signIn: SignIn(AuthService()));
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
        body: _buildProfileContent(),
        bottomNavigationBar: AppBottomNavBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage(
                        fetchTaskCounts:
                            FetchTaskCountsForCategories(TaskService()),
                        addTask: AddTask(TaskService()),
                        fetchUserProfile: FetchUserProfile(UserService()))));
              }
            }),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _getImageProvider(appUser!.photo),
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
                  onPressed: _updateProfile,
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
