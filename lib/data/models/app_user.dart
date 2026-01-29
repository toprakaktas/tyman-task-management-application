class AppUser {
  final String uid;
  String name;
  final String email;
  String photo;
  bool isNotificationsEnabled;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photo = 'assets/images/userAvatar.png',
    this.isNotificationsEnabled = true,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String uid) {
    return AppUser(
        uid: uid,
        name: data['name'] ?? 'Earthling',
        email: data['email'] ?? '',
        photo: data['photoUrl'] as String? ?? 'assets/images/userAvatar.png',
        isNotificationsEnabled: data['isNotificationsEnabled'] ?? true);
  }
}
