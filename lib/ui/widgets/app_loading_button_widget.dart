import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';

class AppLoadingButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final Color? backgroundColor;

  const AppLoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
  });

  @override
  State<AppLoadingButton> createState() => _AppLoadingButtonState();
}

class _AppLoadingButtonState extends State<AppLoadingButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: widget.backgroundColor,
        minimumSize: const Size(double.infinity, 48),
        disabledBackgroundColor: widget.backgroundColor,
      ),
      onPressed: _isLoading ? null : _handlePress,
      child:
          _isLoading
              ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
              : Text(widget.text, style: const TextStyle(fontSize: 20)),
    );
  }
}
