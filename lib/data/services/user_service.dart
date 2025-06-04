import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tyman/data/models/app_user.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> createUser(String email) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set({"id": auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

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
}
