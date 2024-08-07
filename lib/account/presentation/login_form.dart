import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/util.dart";

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = ref.read(clientProvider);
    return _LoginForm(supabase.auth);
  }
}

class _LoginForm extends StatefulWidget {
  final GoTrueClient auth;
  const _LoginForm(this.auth);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  GoTrueClient get _auth => widget.auth;

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;

    final email = _emailController.text;
    try {
      await _auth.signInWithOtp(
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
