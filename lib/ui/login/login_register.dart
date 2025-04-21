import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class LoginRegisterView extends StatelessWidget {
  const LoginRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Agenda',
              style: TextStyle(
                fontSize: 40,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SvgPicture.asset(
              'assets/images/schedule.svg',
              semanticsLabel: 'Imagem calendário',
              height: 250,
            ),
            Column(
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {},
                  child: const Text('Entrar', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Criar uma conta',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
