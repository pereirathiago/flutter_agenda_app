import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/user.dart';
import 'package:flutter_agenda_app/repositories/user_repository_memory.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _registerUser(context) {
    final userRepository = Provider.of<UserRepositoryMemory>(
      context,
      listen: false,
    );

    final user = User(
      id: DateTime.now().toString(),
      fullName: fullNameController.text,
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    userRepository.register(user);
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBarWidget(showBackButton: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppInputWidget(
                    label: 'Nome completo',
                    hintText: 'Digite seu nome completo',
                    controller: fullNameController,
                  ),
                  const SizedBox(height: 16),
                  AppInputWidget(
                    label: 'Nome de usuário',
                    hintText: 'Digite seu nome de usuário',
                    controller: usernameController,
                  ),
                  const SizedBox(height: 16),
                  AppInputWidget(
                    label: 'E-mail',
                    hintText: 'Digite seu e-mail',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),
                  AppInputWidget(
                    label: 'Senha',
                    hintText: 'Digite sua senha',
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 32),

                  AppButtonWidget(
                    text: 'Criar conta',
                    onPressed: () => _registerUser(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
