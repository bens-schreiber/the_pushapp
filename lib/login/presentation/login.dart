import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_pushapp/supabase_provider.dart';

class LoginDisplay extends ConsumerWidget {
  const LoginDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = ref.read(supabaseProvider).value!;
    return _LoginForm(supabase.auth);
  }
}

class _LoginForm extends StatelessWidget {
  final GoTrueClient auth;
  _LoginForm(this.auth);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  GoTrueClient get _auth => auth;

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;
    final email = _emailController.text;
    await _auth.signInWithOtp(
        email: email, emailRedirectTo: "io.supabase.pushapp://login-callback/");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "Email"),
            controller: _emailController,
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
