import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/user_profile/widget/info_card_profile_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
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
                    child: Image.asset(
                      'assets/images/profile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nome Completo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '@nomeusuario',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
              const SizedBox(height: 16),
              InfoCardProfileWidget(title: 'Email', value: 'email@exemplo.com'),
              InfoCardProfileWidget(title: 'Senha', value: '•••••••••••'),
              InfoCardProfileWidget(
                title: 'Data de nascimento',
                value: '01/01/1990',
              ),
              InfoCardProfileWidget(title: 'Gênero', value: 'Masculino'),
              const SizedBox(height: 16),
              AppButtonWidget(
                text: 'Editar Perfil',
                onPressed: () {
                  Navigator.pushNamed(context, '/edit_profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
