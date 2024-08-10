import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/supabase_provider.dart";

class ActivateGroupButton extends ConsumerWidget {
  final String groupId;
  const ActivateGroupButton({required this.groupId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    activateGroup() async {
      final client = ref.read(clientProvider);
      await client.from("Groups").update({"is_active": true}).eq("id", groupId);

      ref.invalidate(groupProviderAsync);
    }

    return HandleButton(
      onPressed: activateGroup,
      child: const Text("Activate Group"),
    );
  }
}
