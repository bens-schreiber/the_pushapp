import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/util.dart";

class JoinGroupForm extends ConsumerStatefulWidget {
  const JoinGroupForm({super.key});

  @override
  ConsumerState<JoinGroupForm> createState() => _JoinGroupForm();
}

class _JoinGroupForm extends ConsumerState<JoinGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _groupIdController = TextEditingController();

  Future<void> _joinGroup() async {
    if (_formKey.currentState?.validate() != true) return;
    final groupId = _groupIdController.text;
    final client = ref.read(clientProvider);

    try {
      await client
          .from("Users")
          .update({"group_id": groupId}).eq("id", client.auth.currentUser!.id);

      ref.invalidate(accountProviderAsync);
    } catch (e) {
      final t = "Error joining group $e";
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
              decoration: const InputDecoration(labelText: "Group Code"),
              controller: _groupIdController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return "Enter a group code";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _joinGroup,
              child: const Text("Join Group"),
            ),
          ],
        ),
      ),
    );
  }
}
