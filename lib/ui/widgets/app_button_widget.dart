import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';

class AppButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const AppButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: backgroundColor,
        minimumSize: const Size(double.infinity, 48),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 20)),
    );
  }
}
