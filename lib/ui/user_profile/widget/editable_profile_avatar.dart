import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/services/image_service.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class EditableProfileAvatar extends StatefulWidget {
  final String? currentImagePath;
  final String userId;
  final Function(String) onImageUpdated;

  const EditableProfileAvatar({
    super.key,
    required this.currentImagePath,
    required this.userId,
    required this.onImageUpdated,
  });

  @override
  State<EditableProfileAvatar> createState() => _EditableProfileAvatarState();
}

class _EditableProfileAvatarState extends State<EditableProfileAvatar> {
  final ImageService _imageService = ImageService();
  String? _localImagePath;

  @override
  Widget build(BuildContext context) {
    final currentImage = _localImagePath ?? widget.currentImagePath;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          key: ValueKey(currentImage),
          radius: 50,
          backgroundImage: _getProfileImage(currentImage),
        ),
        IconButton(
          onPressed: _showImageSourceModal,
          icon: const Icon(Icons.edit, color: AppColors.primary),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primaryDegrade,
          ),
        ),
      ],
    );
  }

  ImageProvider? _getProfileImage(String? imagePath) {
    if (imagePath == null) {
      return const AssetImage('assets/images/profile.png');
    } else if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        final bytes = file.readAsBytesSync();
        return MemoryImage(bytes);
      } else {
        return const AssetImage('assets/images/profile.png');
      }
    }
  }

  Future<void> _changeProfilePicture(ImageSource source) async {
    try {
      final imageFile = await _imageService.pickImage(source: source);
      if (imageFile == null) return;

      if (context.mounted) {
        showDialog(
          context: context.mounted ? context : context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );
      }

      await _imageService.deleteOldImage(widget.currentImagePath);

      final savedImagePath = await _imageService.saveImageToAppDir(
        imageFile,
        widget.userId,
      );

      setState(() => _localImagePath = savedImagePath);

      widget.onImageUpdated(savedImagePath);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao alterar imagem: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _showImageSourceModal() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Alterar foto de perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          iconSize: 50,
                          icon: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDegrade,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _changeProfilePicture(ImageSource.camera);
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Câmera',
                          style: TextStyle(color: AppColors.black),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          iconSize: 50,
                          icon: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDegrade,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_library,
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _changeProfilePicture(ImageSource.gallery);
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Galeria',
                          style: TextStyle(color: AppColors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
