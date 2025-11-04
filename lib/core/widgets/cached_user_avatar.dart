import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedUserAvatar extends StatelessWidget {
  final String photoUrl;
  final double size;
  final double borderRadius;

  const CachedUserAvatar({
    super.key,
    required this.photoUrl,
    this.size = 40,
    this.borderRadius = 10,
  });

  ImageProvider<Object> _getImageProvider() {
    if (photoUrl.isEmpty) {
      return const AssetImage('assets/images/userAvatar.png');
    }

    if (photoUrl.startsWith('http')) {
      return CachedNetworkImageProvider(photoUrl);
    }

    if (photoUrl.startsWith('assets/')) {
      return AssetImage(photoUrl);
    }

    final file = File(photoUrl);
    if (file.existsSync()) {
      return FileImage(file);
    }

    return const AssetImage('assets/images/userAvatar.png');
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: photoUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: _getImageProvider(),
          radius: size / 2,
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: size / 2,
          backgroundImage: const AssetImage('assets/images/userAvatar.png'),
        ),
        fadeInDuration: const Duration(milliseconds: 500),
        fadeOutDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}
