import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/user.dart';
import 'package:flutter_agenda_app/repositories/user_repository_memory.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_select_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_text_button_widget.dart';
import 'package:provider/provider.dart';

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

  void pickTime(BuildContext context) {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      value,
    ) {
      if (value != null) {
        final time = value.format(context);
        _birthDateController.text = time;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final user =
        Provider.of<UserRepositoryMemory>(context, listen: false).loggedUser;

    if (user != null) {
      _fullNameController.text = user.fullName;
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _passwordController.text = user.password;
      _birthDateController.text =
          user.birthDate != null
              ? '${user.birthDate!.day}/${user.birthDate!.month}/${user.birthDate!.year}'
              : '';
      _selectedGender = user.gender ?? 'Masculino';
    }
  }

  void _saveProfile() {
    final userRepository = Provider.of<UserRepositoryMemory>(
      context,
      listen: false,
    );
    final user = User(
      id: userRepository.loggedUser?.id ?? '',
      fullName: _fullNameController.text,
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      birthDate: DateTime.tryParse(_birthDateController.text),
      gender: _selectedGender,
    );

    userRepository.editProfile(user);
    Navigator.pushNamed(context, '/profile');
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data de nascimento'),
                const SizedBox(height: 8),
                TextField(
                  controller: _birthDateController,
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                        final dateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                        );
                        _birthDateController.text =
                            '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Digite a data e hora de término',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
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
            AppButtonWidget(text: 'Salvar alterações', onPressed: _saveProfile),
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
