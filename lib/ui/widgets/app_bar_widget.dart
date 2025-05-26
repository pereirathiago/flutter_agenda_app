import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';

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
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/location');
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: Image.asset('assets/images/profile.png'),
                ),
              ),
            ),
          ],
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
