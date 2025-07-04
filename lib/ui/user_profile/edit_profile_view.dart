import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/user.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/ui/user_profile/widget/editable_profile_avatar.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_loading_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_select_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_text_button_widget.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = 'Masculino';
  String? _profileImagePath;
  int _userId = 0;

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
      if (value != null && context.mounted) {
        final time = value.format(context);
        _birthDateController.text = time;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserRepository>(context, listen: false).loggedUser;

    if (user != null) {
      _userId = user.id!;
      _fullNameController.text = user.fullName;
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _passwordController.text = user.password ?? '';
      _selectedDate = user.birthDate;
      _birthDateController.text =
          user.birthDate != null
              ? '${user.birthDate!.day}/${user.birthDate!.month}/${user.birthDate!.year}'
              : '';
      _selectedGender = user.gender ?? 'Masculino';
      _profileImagePath = user.profilePicture;
    }
  }

  Future<void> _saveProfile(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final userRepository = Provider.of<UserRepository>(context, listen: false);

    final user = User(
      id: userRepository.loggedUser?.id ?? 0,
      firebaseUid: userRepository.loggedUser?.firebaseUid,
      fullName: _fullNameController.text,
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      birthDate: _selectedDate,
      gender: _selectedGender,
      profilePicture: _profileImagePath,
    );

    if (user.id == 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Erro: Usuário não identificado para salvar o perfil.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      await userRepository.editProfile(user);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  EditableProfileAvatar(
                    currentImagePath: _profileImagePath,
                    userId: _userId.toString(),
                    onImageUpdated: (newPath) async {
                      try {
                        await Provider.of<UserRepository>(
                          context,
                          listen: false,
                        ).updateProfilePicture(_userId, newPath);
                        setState(() => _profileImagePath = newPath);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppInputWidget(
                label: 'Nome completo',
                controller: _fullNameController,
                hintText: 'Digite seu nome',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome completo é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputWidget(
                label: 'Nome de usuário',
                controller: _usernameController,
                hintText: 'Digite o nome de usuário',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome de usuário é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputWidget(
                label: 'E-mail',
                controller: _emailController,
                hintText: 'Digite seu e-mail',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'E-mail é obrigatório.';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Digite um e-mail válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputWidget(
                label: 'Senha',
                controller: _passwordController,
                hintText: 'Digite sua senha',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatória.';
                  }
                  if (value.length < 6) {
                    return 'Senha deve ter no mínimo 6 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data de nascimento'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        _selectedDate = date;
                        _birthDateController.text =
                            '${date.day}/${date.month}/${date.year}';
                      }
                    },
                    validator: (value) {
                      if (_selectedDate == null) {
                        return 'Data de nascimento é obrigatória.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Selecione a data de nascimento',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
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
              AppLoadingButton(
                text: 'Salvar alterações',
                onPressed: () => _saveProfile(context),
              ),
              const SizedBox(height: 16),
              AppTextButtonWidget(
                text: 'Cancelar',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
