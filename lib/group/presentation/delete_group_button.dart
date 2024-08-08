import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/supabase_provider.dart";

class DeleteGroupButton extends ConsumerWidget {
  final String groupId;
  const DeleteGroupButton({required this.groupId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    delete() async {
      final client = ref.read(clientProvider);
      await client.from("Groups").delete().eq("id", groupId);

      ref.invalidate(groupProviderAsync);
    }

    return HandleButton(onPressed: delete, child: const Text("Delete Group"));
  }
}
