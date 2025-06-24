import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter/services.dart';

class AppInputWidget extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged; // <--- esta linha
  final List<TextInputFormatter>? inputFormatters;



  const AppInputWidget({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.readOnly = false,
    this.onChanged, // <--- Aqui
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged, // <--- Aqui
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: readOnly ? Colors.grey[200] : AppColors.primaryDegrade,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: readOnly ? Colors.grey : AppColors.primary,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
