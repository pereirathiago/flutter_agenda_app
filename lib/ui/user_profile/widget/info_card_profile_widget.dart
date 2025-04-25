import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';

class InfoCardProfileWidget extends StatelessWidget {
  final String title;
  final String value;

  const InfoCardProfileWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryDegrade,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.cardTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: AppColors.cardTextColor),
        ),
      ),
    );
  }
}
