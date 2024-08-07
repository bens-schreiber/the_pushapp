import "dart:developer";

import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/util.dart";

class CreateGroupButton extends StatelessWidget {
  final SupabaseClient client;
  const CreateGroupButton({required this.client, super.key});

  Future<void> _createGroup(BuildContext context) async {
    try {
      final groupId =
          await client.from("Groups").insert({}) // use default values
              .select("id");

      await client.from("Users").update({"group_id": groupId.first["id"]}).eq(
          "id", client.auth.currentUser!.id);
    } catch (e) {
      final t = "Error creating group: $e";
      log(t);

      // ignore: use_build_context_synchronously
      showSnackbar(t, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          await _createGroup(context);
        },
        child: const Text("Create Group"));
  }
}
