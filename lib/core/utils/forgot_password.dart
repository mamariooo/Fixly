import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import 'validators.dart';

Future<void> showForgotPasswordDialog(BuildContext context) async {
  final ctrl = TextEditingController();
  String? error;

  bool sending = false;

  final sent = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Reset password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your email and we will send a reset link.'),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
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
            onPressed: sending
                ? null
                : () async {
                    final e = Validators.email(ctrl.text);
                    if (e != null) {
                      setState(() => error = e);
                      return;
                    }
                    setState(() {
                      sending = true;
                      error = null;
                    });
                    try {
                      await AuthService().sendPasswordReset(ctrl.text);
                      if (ctx.mounted) Navigator.pop(ctx, true);
                    } on FirebaseAuthException catch (ex) {
                      setState(() {
                        sending = false;
                        error = ex.message ?? 'Unable to send reset link.';
                      });
                    } catch (_) {
                      setState(() {
                        sending = false;
                        error = 'Unable to send reset link.';
                      });
                    }
                  },
            child: Text(sending ? 'Sending...' : 'Send'),
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
