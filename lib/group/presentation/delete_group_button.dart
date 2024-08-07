import "dart:developer";

import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/util.dart";

class DeleteGroupButton extends StatelessWidget {
  final String groupId;
  final SupabaseClient client;
  const DeleteGroupButton(
      {required this.client, required this.groupId, super.key});

  Future<void> _deleteGroup(BuildContext context) async {
    try {
      await client.from("Groups").delete().eq("id", groupId);
    } catch (e) {
      final t = "Error deleting group: $e";
      log(t);

      // ignore: use_build_context_synchronously
      showSnackbar(t, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          await _deleteGroup(context);
        },
        child: const Text("Delete Group"));
  }
}
