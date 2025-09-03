import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tyman/data/models/app_user.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.user});

  final AppUser? user;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  ImageProvider _getImageProvider(String photoUrl) {
    if (photoUrl.startsWith('http')) return NetworkImage(photoUrl);
    if (photoUrl.startsWith('assets/')) return AssetImage(photoUrl);
    try {
      final file = File(photoUrl);
      if (file.existsSync() && file.lengthSync() > 0) {
        return FileImage(file);
      }
    } catch (_) {}
    return const AssetImage('assets/images/userAvatar.png');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (user != null)
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CircleAvatar(
                  backgroundImage: _getImageProvider(user!.photo),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          const SizedBox(width: 10),
          Text(
            "Hello, ${user?.name ?? 'Earthling'}!",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
