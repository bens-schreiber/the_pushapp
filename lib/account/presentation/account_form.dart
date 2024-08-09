import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/notifications/application/notifications_provider.dart";
import "package:the_pushapp/supabase_provider.dart";

class AccountForm extends HookConsumerWidget {
  const AccountForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();

    validate() => formKey.currentState?.validate() == true;

    createAccount() async {
      if (!validate()) return;
      final firstName = firstNameController.text;
      final lastName = lastNameController.text;

      final client = ref.read(clientProvider);
      final fcm = await ref.read(fcmTokenProviderAsync.future);
      await client
          .from("Users")
          .insert({"first_name": firstName, "last_name": lastName, "fcm": fcm});

      ref.invalidate(accountProviderAsync);
    }

    return Card(
      child: Form(
        key: formKey,
        child: Column(
          children: [
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
          ],
        ),
      ),
    );
  }
}
