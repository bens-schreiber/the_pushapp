import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/util.dart";

class CreateGroupForm extends HookConsumerWidget {
  const CreateGroupForm({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createGroupFuture = useFutureLoader();

    createGroup() async {
      final client = ref.read(clientProvider);
      final groupId =
          await client.from("Groups").insert({}) // use default values
              .select("id");

      await FutureLoader.load(
          client.from("Users").update({
            "group_id": groupId.first["id"],
          }).eq(
            "id",
            client.auth.currentUser!.id,
          ),
          createGroupFuture);

      ref.invalidate(accountProviderAsync);
    }

    return Column(
      children: [
        Text("Find your friends!",
            style: Theme.of(context).textTheme.headlineLarge),
        Text("Accept an invite or create a group to get started.",
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 25),
        HandleButton(
          onPressed: createGroup,
          child: const Text("Create Group"),
        ),

        // Loading
        FutureLoader(
          loaders: [createGroupFuture],
        ),
      ],
    );
  }
}
