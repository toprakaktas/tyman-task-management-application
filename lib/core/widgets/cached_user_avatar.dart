import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedUserAvatar extends StatelessWidget {
  final String photoUrl;
  final double size;

  const CachedUserAvatar({
    super.key,
    required this.photoUrl,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: photoUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.transparent,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.transparent,
          child: const CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => _buildAssetAvatar(),
        fadeInDuration: const Duration(milliseconds: 500),
        fadeOutDuration: const Duration(milliseconds: 200),
      );
    }

    final file = File(photoUrl);
    if (file.existsSync()) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: FileImage(file),
        backgroundColor: Colors.transparent,
      );
    }

    return _buildAssetAvatar();
  }

  Widget _buildAssetAvatar() {
    return CircleAvatar(
      backgroundImage: photoUrl.startsWith('assets/')
          ? AssetImage(photoUrl)
          : const AssetImage('assets/images/userAvatar.png'),
      radius: size / 2,
      backgroundColor: Colors.transparent,
    );
  }
}
