import 'package:flutter/material.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({
    super.key,
    required this.onPressed,
    this.label = 'Continue',
  });
  final VoidCallback onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('login_button'),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
