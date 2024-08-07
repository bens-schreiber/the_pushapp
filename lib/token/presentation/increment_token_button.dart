import "dart:developer";

import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:the_pushapp/util.dart";

class IncrementTokenButton extends StatelessWidget {
  final SupabaseClient client;
  final int token;
  const IncrementTokenButton(
      {required this.client, required this.token, super.key});

  Future<void> _incrementToken(BuildContext context) async {
    try {
      await client
          .from("Groups")
          .update({"token": token + 1, "token_user_id": null})
          .eq("token_user_id", client.auth.currentUser!.id)
          .count(CountOption.exact);
    } catch (e) {
      final t = "Error incrementing token: $e";
      log(t);

      // ignore: use_build_context_synchronously
      showSnackbar(t, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          await _incrementToken(context);
        },
        child: const Text("Increment Token"));
  }
}
