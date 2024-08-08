import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/notifications/application/notifications_provider.dart";
import "package:the_pushapp/supabase_provider.dart";

class AccountForm extends ConsumerStatefulWidget {
  const AccountForm({super.key});

  @override
  ConsumerState<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    validate() => _formKey.currentState?.validate() == true;

    createAccount() async {
      if (!validate()) return;
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;

      final client = ref.read(clientProvider);
      final fcm = await ref.read(fcmTokenProvider.future);
      await await client
          .from("Users")
          .insert({"first_name": firstName, "last_name": lastName, "fcm": fcm});

      ref.invalidate(accountProviderAsync);
    }

    return Card(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "First name"),
              controller: _firstNameController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return "Please enter your first name";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Last name"),
              controller: _lastNameController,
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
