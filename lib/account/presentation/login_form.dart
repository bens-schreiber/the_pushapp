import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/common/common.dart";
import "package:the_pushapp/supabase/supabase_provider.dart";
import "package:the_pushapp/common/util.dart";

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final sentOtp = useState(false);
    final loginFuture = useFutureLoader();

    validate() => formKey.currentState?.validate() == true;

    login() async {
      if (!validate()) return;
      final email = emailController.text;
      final client = ref.read(clientProvider);

      // // On success this will stream an auth event handled by [isAuthenticatedProviderAsync]
      await FutureLoader.load(
        client.auth.signInWithOtp(
            email: email,
            emailRedirectTo: "io.supabase.pushapp://login-callback/"),
        loginFuture,
      );

      sentOtp.value = true;
    }

    final form = Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              decoration: const InputDecoration(labelText: "Email"),
              controller: emailController,
              validator: (value) {
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                final regex = RegExp(pattern.toString());

                if (value == null || !regex.hasMatch(value)) {
                  return "Please enter your email";
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 20),

          HandleButton(
            onPressed: login,
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize),
            ),
          ),

          const SizedBox(height: 10),

          // Loading
          FutureLoader(loaders: [loginFuture]),
        ],
      ),
    );

    final codeSent = Column(
      children: [
        const Icon(Icons.check_circle, size: 50, color: Colors.green),
        const SizedBox(height: 10),
        Text(
          "Sent! Check your email for a login link.",
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        TextButton(
            onPressed: () {
              sentOtp.value = false;
            },
            child: Text("Try Again",
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.bodyLarge?.fontSize))),
      ],
    );

    return Column(
      children: [
        // Header
        if (!sentOtp.value) ...[
          Text("Sign in",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 25),
        ],

        // Form
        SizedBox(
          width: double.infinity,
          child: sentOtp.value ? codeSent : form,
        ),
      ],
    );
  }
}
