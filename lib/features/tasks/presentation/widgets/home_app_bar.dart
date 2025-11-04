import 'package:flutter/material.dart';
import 'package:tyman/core/widgets/cached_user_avatar.dart';
import 'package:tyman/data/models/app_user.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.user});

  final AppUser? user;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
                child: CachedUserAvatar(photoUrl: user!.photo, size: 40),
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
