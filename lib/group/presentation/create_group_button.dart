import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/util.dart";

class CreateGroupButton extends ConsumerWidget {
  const CreateGroupButton({super.key});

  Future<bool> _createGroup(SupabaseClient client, BuildContext context) async {
    try {
      final groupId =
          await client.from("Groups").insert({}) // use default values
              .select("id");

      await client.from("Users").update({"group_id": groupId.first["id"]}).eq(
          "id", client.auth.currentUser!.id);

      return true;
    } catch (e) {
      final t = "Error creating group: $e";
      log(t);

      // ignore: use_build_context_synchronously
      showSnackbar(t, context);

      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.read(clientProvider);
    return TextButton(
        onPressed: () async {
          if (!await _createGroup(client, context)) return;
          ref.invalidate(accountProviderAsync);
        },
        child: const Text("Create Group"));
  }
}
