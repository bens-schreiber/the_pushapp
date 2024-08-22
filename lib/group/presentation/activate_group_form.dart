import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/common/common.dart";
import "package:the_pushapp/common/util.dart";
import "package:the_pushapp/group/group_provider.dart";
import "package:the_pushapp/supabase/supabase_provider.dart";

class ActivateGroupForm extends ConsumerWidget {
  const ActivateGroupForm({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    confirm() => showConfirmationDialog(
          title: "Activate Group",
          content:
              "By activating your group, you will begin recieving Pushup token notifications.",
          context: context,
        );

    activateGroup() async {
      if (!await confirm()) return;

      final client = ref.read(clientProvider);
      final group = ref.read(groupProvider);
      await client.from("Groups").update({"is_active": true, "token": 1}).eq(
        "id",
        group!.id,
      );

      ref.invalidate(groupProviderAsync);
    }

    return HandleButton(
      elevated: true,
      onPressed: activateGroup,
      child: const Text("Activate Your Group"),
    );
  }
}
