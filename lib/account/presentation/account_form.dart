import "dart:developer";

import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/util.dart";

class AccountForm extends StatefulWidget {
  final SupabaseClient client;
  const AccountForm({required this.client, super.key});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  Future<void> _createAccount() async {
    if (_formKey.currentState?.validate() != true) return;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;

    try {
      await widget.client
          .from("Users")
          .insert({"first_name": firstName, "last_name": lastName});
    } catch (e) {
      final t = "Error creating account: $e";
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
            TextButton(
              onPressed: _createAccount,
              child: const Text("Create account"),
            ),
          ],
        ),
      ),
    );
  }
}
