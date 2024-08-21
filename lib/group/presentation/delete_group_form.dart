import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/common/common.dart";
import "package:the_pushapp/group/group_provider.dart";
import "package:the_pushapp/supabase/supabase_provider.dart";
import "package:the_pushapp/common/util.dart";

class DeleteGroupForm extends HookConsumerWidget {
  const DeleteGroupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupFuture = useFutureLoader();

    delete() async {
      final client = ref.read(clientProvider);
      final group = ref.read(groupProvider);

      await FutureLoader.load(
          client.from("Groups").delete().eq(
                "id",
                group!.id,
              ),
          groupFuture);

      ref.invalidate(groupProviderAsync);
    }

    // TODO: Are you sure? dialog
    return Column(
      children: [
        HandleButton(onPressed: delete, child: const Text("Delete Group")),
        FutureLoader(loaders: [groupFuture]),
      ],
    );
  }
}
