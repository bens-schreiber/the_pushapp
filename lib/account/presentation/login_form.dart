import "dart:developer";

import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/util.dart";

class LoginForm extends StatefulWidget {
  final GoTrueClient auth;
  const LoginForm({required this.auth, super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;

    final email = _emailController.text;
    try {
      await widget.auth.signInWithOtp(
          email: email,
          emailRedirectTo: "io.supabase.pushapp://login-callback/");
    } catch (e) {
      final t = "Error logging in: $e";
      log(t);

      // ignore: use_build_context_synchronously
      showSnackbar(t, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Email"),
              controller: _emailController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return "Please enter your email";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
