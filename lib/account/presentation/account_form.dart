import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/account/account_provider.dart";
import "package:the_pushapp/common/common.dart";
import "package:the_pushapp/notifications/notifications_provider.dart";
import "package:the_pushapp/supabase/supabase_provider.dart";
import "package:the_pushapp/common/util.dart";

class AccountForm extends HookConsumerWidget {
  const AccountForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final accountFuture = useFutureLoader();

    validate() => formKey.currentState?.validate() == true;

    createAccount() async {
      if (!validate()) return;
      final firstName = firstNameController.text;
      final lastName = lastNameController.text;

      final client = ref.read(clientProvider);
      final fcm = await ref.read(fcmTokenProviderAsync.future);

      await FutureLoader.load(
        client.from("Users").insert(
          {
            "first_name": firstName,
            "last_name": lastName,
            "fcm": fcm,
          },
        ),
        accountFuture,
      );

      ref.invalidate(accountProviderAsync);
    }

    return Card(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              "Let's get to know you!",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            TextFormField(
              decoration: const InputDecoration(labelText: "First name"),
              controller: firstNameController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return "Please enter your first name";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Last name"),
              controller: lastNameController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return "Please enter your last name";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            HandleButton(
              onPressed: createAccount,
              child: const Text("Create account"),
            ),
            const SizedBox(height: 10),

            // Loading
            FutureLoader(loaders: [accountFuture]),
          ],
        ),
      ),
    );
  }
}
