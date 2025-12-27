import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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
  Stream<AppUser?> getUserStream(String uid) {
    return firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return AppUser.fromFirestore(snapshot.data()!, uid);
      }
      return null;
    });
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

  @override
  Future<void> saveFCMToken(String token) async {
    final uid = auth.currentUser!.uid;
    try {
      final TimezoneInfo timezone = await FlutterTimezone.getLocalTimezone();

      final docSnapshot = await firestore.collection('users').doc(uid).get();
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data();
      final String currentToken = data?['fcmToken'];
      final String currentTimezone = data?['timezone'];

      bool isTokenChanged = currentToken != token;
      bool isTimezoneChanged = currentTimezone != timezone.identifier;

      if (!isTokenChanged && !isTimezoneChanged) {
        if (kDebugMode) {
          print('Token and timezone are the same. No update required.');
        }
        return;
      }
      await firestore.collection('users').doc(uid).update({
        'fcmToken': token,
        'timezone': timezone.identifier,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('FCM Token or Timezone updated!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving FCM token: $e');
      }
    }
  }

  @override
  Future<void> updateNotificationSettings(String uid, bool isEnabled) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'isNotificationsEnabled': isEnabled,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating notification settings: $e');
      }
      throw Exception('Failed to update notification settings');
    }
  }
}
