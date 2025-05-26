import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  const AppBarWidget({
    super.key,
    this.title = 'Agenda',
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final userRepository = context.watch<UserRepository>();
    final profilePicture = userRepository.loggedUser?.profilePicture;

    return showBackButton
        ? AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 32,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Navigator.pushNamed(context, '/'),
              ),
            ),
          ),
        )
        : AppBar(
          title: Text(title),
          centerTitle: true,
          actions: [
            if (ModalRoute.of(context)?.settings.name != '/location' &&
                ModalRoute.of(context)?.settings.name != '/new-location')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.location_on,
                    color: AppColors.primaryDegrade,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/location'),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: CircleAvatar(
                  backgroundImage: _getProfileImage(profilePicture),
                  radius: 16,
                ),
              ),
            ),
          ],
        );
  }

  ImageProvider? _getProfileImage(String? imagePath) {
    if (imagePath == null) return const AssetImage('assets/images/profile.png');
    if (imagePath.startsWith('assets/')) return AssetImage(imagePath);

    final file = File(imagePath);
    if (file.existsSync()) {
      final bytes = file.readAsBytesSync();
      return MemoryImage(bytes);
    } else {
      return const AssetImage('assets/images/profile.png');
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
