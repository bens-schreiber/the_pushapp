import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/supabase_provider.dart";

class JoinGroupForm extends HookConsumerWidget {
  const JoinGroupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final groupIdController = useTextEditingController();

    validate() => formKey.currentState?.validate() == true;

    joinGroup() async {
      if (!validate()) return;
      final groupId = groupIdController.text;
      final client = ref.read(clientProvider);

      await client
          .from("Users")
          .update({"group_id": groupId}).eq("id", client.auth.currentUser!.id);
    }

    return Card(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Group Code"),
              controller: groupIdController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return "Enter a group code";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            HandleButton(
              onPressed: joinGroup,
              child: const Text("Join Group"),
            ),
          ],
        ),
      ),
    );
  }
}
