import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/util.dart";

class IncrementTokenDisplay extends HookConsumerWidget {
  const IncrementTokenDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenFuture = useFutureLoader();

    incrementToken() async {
      final client = ref.read(clientProvider);
      final group = ref.read(groupProvider);
      final token = group!.token;

      await FutureLoader.load(
          client
              .from("Groups")
              .update({"token": token + 1, "token_user_id": null})
              .eq("token_user_id", client.auth.currentUser!.id)
              .count(CountOption.exact),
          tokenFuture);

      ref.invalidate(groupProviderAsync);
    }

    return Column(
      children: [
        Text("You're the token holder!",
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Text("Drop and give ${ref.read(groupProvider)!.token}!",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        HandleButton(
          onPressed: () => inErrorHandler(incrementToken, context),
          child: const Text("Increment Token"),
        ),
        FutureLoader(loaders: [tokenFuture])
      ],
    );
  }
}
