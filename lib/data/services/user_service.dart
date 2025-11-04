import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:tyman/data/models/app_user.dart';
import 'package:tyman/domain/services/user_repository.dart';

class UserService implements UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<bool> createUser(String email) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return false;
      }

      final userData = {
        "id": user.uid,
        "email": email,
        "name": "Earthling",
        "photoUrl": "assets/images/userAvatar.png",
      };

      await firestore.collection('users').doc(user.uid).set(userData);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  @override
  Future<AppUser?> fetchUserProfile(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return AppUser.fromFirestore(userData, uid);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
      return null;
    }
  }

  @override
  Future<void> updateProfile(
      AppUser appUser, String name, String email, String photo) async {
    try {
      await firestore.collection('users').doc(appUser.uid).update({
        'name': name,
        'email': email,
        'photoUrl': photo,
      });
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  @override
  Future<String> uploadProfileImage(File file) async {
    final uid = auth.currentUser!.uid;
    final ref = storage.ref().child('avatars/$uid/profile.jpg');

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }
}
