import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/supabase_provider.dart";

class DeleteGroupButton extends ConsumerWidget {
  final int groupId;
  const DeleteGroupButton({required this.groupId, super.key});

  Future<bool> _deleteGroup(SupabaseClient client) async {
    try {
      await client.from("Groups").delete().eq("id", groupId);
      return true;
    } catch (e) {
      log("Error deleting group: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.read(clientProvider);
    return TextButton(
        onPressed: () async {
          if (!await _deleteGroup(client)) return;
          ref.invalidate(accountProviderAsync);
        },
        child: const Text("Delete Group"));
  }
}
