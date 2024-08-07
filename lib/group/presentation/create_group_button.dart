import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/supabase_provider.dart";

class CreateGroupButton extends ConsumerWidget {
  const CreateGroupButton({super.key});

  Future<bool> _createGroup(SupabaseClient client) async {
    try {
      final groupId =
          await client.from("Groups").insert({}) // use default values
              .select("id");

      await client.from("Users").update({"group_id": groupId.first["id"]}).eq(
          "id", client.auth.currentUser!.id);

      return true;
    } catch (e) {
      log("Error creating group: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.read(clientProvider);
    return TextButton(
        onPressed: () async {
          if (!await _createGroup(client)) return;
          ref.invalidate(accountProviderAsync);
        },
        child: const Text("Create Group"));
  }
}
