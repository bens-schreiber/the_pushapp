import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/supabase_provider.dart";

class CreateGroupButton extends ConsumerWidget {
  const CreateGroupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    createGroup() async {
      final client = ref.read(clientProvider);
      final groupId =
          await client.from("Groups").insert({}) // use default values
              .select("id");

      await client.from("Users").update({"group_id": groupId.first["id"]}).eq(
          "id", client.auth.currentUser!.id);

      ref.invalidate(accountProviderAsync);
    }

    return HandleButton(
      onPressed: createGroup,
      child: const Text("Create Group"),
    );
  }
}
