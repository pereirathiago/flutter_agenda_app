import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({required ImageSource source}) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return null;
    return File(image.path);
  }

  Future<String> saveImageToAppDir(File imageFile, String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'profile_$userId${path.extension(imageFile.path)}';
    final newPath = path.join(directory.path, fileName);

    final savedImage = await imageFile.copy(newPath);
    return savedImage.path;
  }

  Future<void> deleteOldImage(String? imagePath) async {
    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // ignore: avoid_print
        print('Erro ao deletar imagem antiga: $e');
      }
    }
  }
}
