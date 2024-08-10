import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/util.dart";

class LeaveGroupForm extends HookConsumerWidget {
  const LeaveGroupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupFuture = useFutureLoader();

    leave() async {
      final client = ref.read(clientProvider);

      await FutureLoader.load(
          client.from("Users").update(
            {"group_id": null},
          ).eq(
            "id",
            client.auth.currentUser!.id,
          ),
          groupFuture);

      ref.invalidate(groupProviderAsync);
    }

    // TODO: Are you sure? dialog
    return Column(
      children: [
        HandleButton(onPressed: leave, child: const Text("Leave Group")),
        FutureLoader(loaders: [groupFuture]),
      ],
    );
  }
}
