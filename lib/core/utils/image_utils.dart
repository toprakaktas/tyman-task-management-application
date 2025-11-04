import 'dart:io';
import 'package:image/image.dart' as img;

Future<File> compressImage(File imageFile,
    {int maxWidth = 800, int quality = 85}) async {
  final bytes = await imageFile.readAsBytes();
  final originalImage = img.decodeImage(bytes);

  if (originalImage == null) return imageFile;

  int width = originalImage.width;
  int height = originalImage.height;

  if (width > maxWidth) {
    final ratio = maxWidth / width;
    width = maxWidth;
    height = (height * ratio).round();
  }

  final resizedImage = img.copyResize(originalImage,
      width: width, height: height, interpolation: img.Interpolation.linear);

  /// Compression
  final compressedBytes = img.encodeJpg(resizedImage, quality: quality);

  final tempFile = File('${imageFile.path}_compressed.jpg');
  await tempFile.writeAsBytes(compressedBytes);

  return tempFile;
}
