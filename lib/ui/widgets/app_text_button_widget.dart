import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';

class AppTextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppTextButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: AppColors.primary, width: 2),
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: AppColors.primary),
      ),
    );
  }
}
