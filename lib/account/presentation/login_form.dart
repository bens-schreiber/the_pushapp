import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/supabase_provider.dart";

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    validate() => _formKey.currentState?.validate() == true;

    login() async {
      if (!validate()) return;
      final email = _emailController.text;
      final client = ref.read(clientProvider);

      // On success this will stream an auth event handled by [isAuthenticatedProviderAsync]
      await client.auth.signInWithOtp(
          email: email,
          emailRedirectTo: "io.supabase.pushapp://login-callback/");
    }

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
            HandleButton(
              onPressed: login,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
