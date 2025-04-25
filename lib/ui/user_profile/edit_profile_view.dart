import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_select_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_text_button_widget.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  String _selectedGender = 'Masculino';

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fullNameController.text = '';
    _usernameController.text = '';
    _emailController.text = '';
    _passwordController.text = '';
    _birthDateController.text = '';
    _genderController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryDegrade,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppInputWidget(
              label: 'Nome completo',
              controller: _fullNameController,
              hintText: 'Digite seu nome',
            ),
            const SizedBox(height: 16),
            AppInputWidget(
              label: 'Nome de usuário',
              controller: _usernameController,
              hintText: 'Digite o nome de usuário',
            ),
            const SizedBox(height: 16),
            AppInputWidget(
              label: 'E-mail',
              controller: _emailController,
              hintText: 'Digite seu e-mail',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AppInputWidget(
              label: 'Senha',
              controller: _passwordController,
              hintText: 'Digite sua senha',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            AppInputWidget(
              label: 'Data de nascimento',
              controller: _birthDateController,
              hintText: 'DD/MM/AAAA',
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            AppSelectWidget(
              label: 'Gênero',
              value: _selectedGender,
              options: ['Masculino', 'Feminino', 'Outro'],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value ?? '';
                });
              },
            ),
            const SizedBox(height: 32),
            AppButtonWidget(text: 'Salvar alterações', onPressed: () {}),
            const SizedBox(height: 16),
            AppTextButtonWidget(
              text: 'Cancelar',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
