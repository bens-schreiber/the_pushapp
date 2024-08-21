import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/common/common.dart";
import "package:the_pushapp/group/group_provider.dart";
import "package:the_pushapp/supabase/supabase_provider.dart";
import "package:the_pushapp/common/util.dart";

class IncrementTokenDisplay extends HookConsumerWidget {
  const IncrementTokenDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenFuture = useFutureLoader();
    final token = ref.read(groupProvider)!.token;

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
        Image.asset(
          "assets/logo.png",
          height: 70,
          color: Colors.white,
        ),
        const SizedBox(height: 15),
        Text("Drop and give $token push up${token > 1 ? "s" : ""}!",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        HandleButton(
          elevated: true,
          onPressed: incrementToken,
          child: const Text("I've done my push ups"),
        ),
        const SizedBox(height: 10),
        FutureLoader(loaders: [tokenFuture])
      ],
    );
  }
}
