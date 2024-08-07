import "dart:developer";

import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/util.dart";

class ActivateGroupButton extends StatelessWidget {
  final String groupId;
  final SupabaseClient client;
  const ActivateGroupButton(
      {required this.client, required this.groupId, super.key});

  Future<void> _activateGroup(BuildContext context) async {
    try {
      await client.from("Groups").update({"is_active": true}).eq("id", groupId);
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
          await _activateGroup(context);
        },
        child: const Text("Activate Group"));
  }
}
