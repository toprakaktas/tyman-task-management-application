import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tyman/authentication/authentication_data.dart';
import 'package:tyman/constants/colors.dart';
import 'package:tyman/screens/home/home.dart';
import 'package:tyman/services/firestore_services.dart';

class AppUser {
  final String uid;
  String name;
  final String email;
  String photo;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photo = 'assets/images/userAvatar.png',
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      name: data['name'] ?? 'Earthling',
      email: data['email'] ?? '',
      photo: data['photoUrl'] as String? ?? 'assets/images/userAvatar.png',
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  AppUser? appUser;
  final picker = ImagePicker();
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  final AuthenticationData authService = AuthenticationData();
  final _selectedIndex = 1;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    firestoreService.fetchUserProfile(firebaseUser!.uid).then((AppUser? user) {
      if (mounted) {
        setState(() {
          appUser = user;
          nameController.text = appUser!.name;
          emailController.text = appUser!.email;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    if (mounted) {
      setState(() {
        _isEditMode = !_isEditMode;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        if (pickedFile != null) {
          appUser!.photo = pickedFile.path;
        } else {
          if (kDebugMode) {
            print('No image selected.');
          }
        }
      });
    }
  }

  Future<void> updateProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(appUser!.uid)
          .update({
        'name': nameController.text,
        'email': emailController.text,
        'photoUrl': appUser!.photo,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile')),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await authService.logout(context);
    } catch (e) {
      const snackBar = SnackBar(content: Text('Error signing out. Try again.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  ImageProvider _getImageProvider(String photoUrl) {
    if (photoUrl.startsWith('assets/images')) {
      return AssetImage(photoUrl);
    } else {
      return FileImage(File(photoUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemGrey.withOpacity(0.1),
          middle: const Text('My Profile',
              style: TextStyle(color: Colors.white, fontSize: 22)),
          automaticallyImplyLeading: false,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                tileMode: TileMode.mirror,
                colors: [
                  kBlack,
                  kGreyDark,
                  kGrey,
                  kGreyLight,
                  kWhiteGrey,
                ],
                transform: GradientRotation(pi / 4)),
          ),
          padding: const EdgeInsets.all(16.0),
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
              CupertinoTextField(
                controller: nameController,
                placeholder: 'Name',
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.inactiveGray,
                  fontStyle: FontStyle.italic,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CupertinoColors.systemGrey,
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                enabled: false,
                readOnly: true,
                controller: emailController,
                placeholder: 'Email',
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.inactiveGray,
                  fontStyle: FontStyle.italic,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CupertinoColors.systemGrey,
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                onPressed: updateProfile,
                color: CupertinoColors.systemTeal.highContrastColor,
                child: const Text('Update Profile'),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                onPressed: () => logout(context),
                color: CupertinoColors.label,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(context),
    );
  }

  Widget buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: const Color.fromARGB(255, 63, 117, 212),
      unselectedItemColor: Colors.grey.withValues(alpha: 0.75),
      currentIndex: _selectedIndex,
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home_rounded),
        ),
        BottomNavigationBarItem(
          label: 'My Page',
          icon: Icon(Icons.person_rounded),
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
    );
  }
}
