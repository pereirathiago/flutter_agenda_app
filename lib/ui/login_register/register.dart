import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
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
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
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

                  AppButtonWidget(text: 'Criar conta', onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
