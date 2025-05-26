import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/services/auth_service.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/user_profile/widget/info_card_profile_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  void _logout(BuildContext context) {
    try {
      final userRepository = Provider.of<UserRepository>(
        context,
        listen: false,
      );

      userRepository.logout();

      if (context.mounted) {
        Navigator.pushNamed(context, '/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst("Exception: ", "")),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = context.watch<UserRepository>();
    final user = userRepository.loggedUser;

    if (user == null) {
      AuthService().logout();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushNamed(context, '/login');
        }
      });
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: ClipOval(
                    child: _buildProfileImage(user.profilePicture),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@${user.username}',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
              const SizedBox(height: 16),
              InfoCardProfileWidget(title: 'Email', value: user.email),
              InfoCardProfileWidget(title: 'Senha', value: '•••••••••••'),
              InfoCardProfileWidget(
                title: 'Data de nascimento',
                value:
                    user.birthDate != null
                        ? user.birthDate.toString()
                        : 'Ainda não cadastrado',
              ),
              InfoCardProfileWidget(
                title: 'Gênero',
                value: user.gender ?? 'Não informado',
              ),
              const SizedBox(height: 16),
              AppButtonWidget(
                text: 'Editar Perfil',
                onPressed: () {
                  Navigator.pushNamed(context, '/edit_profile');
                },
              ),
              const SizedBox(height: 16),
              AppButtonWidget(
                text: 'Sair da conta',
                onPressed: () => _logout(context),
                backgroundColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset('assets/images/profile.png', fit: BoxFit.cover);
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/profile.png', fit: BoxFit.cover);
          },
        );
      } else {
        return Image.asset('assets/images/profile.png', fit: BoxFit.cover);
      }
    }
  }
}
