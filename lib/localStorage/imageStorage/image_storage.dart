import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageStorage {
  Future<String> saveImage(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    final uniqueId = Uuid().v4();
    final imagePath = '${imageDir.path}/$uniqueId.jpg';
    await image.copy(imagePath);
    return imagePath;
  }

  Future<File> getImage(String imagePath) async {
    final imageFile = File(imagePath);
    if (!await imageFile.exists()) {
      throw Exception('Image not found');
    }
    return imageFile;
  }
}
