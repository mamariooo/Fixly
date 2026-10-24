import 'package:flutter/material.dart';

import 'validators.dart';

Future<void> showForgotPasswordDialog(BuildContext context) async {
  final ctrl = TextEditingController();
  String? error;

  final sent = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Reset password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email or phone and we will send a reset link.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email or phone',
                errorText: error,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final e = Validators.emailOrPhone(ctrl.text);
              if (e != null) {
                setState(() => error = e);
                return;
              }
              Navigator.pop(ctx, true);
            },
            child: const Text('Send'),
          ),
        ],
      ),
    ),
  );

  if (sent == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset link sent. Check your inbox.')),
    );
  }
}
