import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/util.dart";

class SignoutButton extends ConsumerWidget {
  final Function onTap;
  const SignoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    signOut() async {
      final client = ref.read(clientProvider);

      if (client.auth.currentUser == null) {
        onTap();
        return;
      }

      final id = client.auth.currentUser!.id;
      await client.auth.signOut();
      await client.from("Users").update({"fcm": null}).eq("id", id);

      ref.invalidate(clientProvider);
      onTap();
    }

    return ListTile(
      onTap: () => useErrorHandle(signOut, context),
      dense: true,
      leading: const Icon(Icons.logout, size: 25),
      title: Text("Sign Out", style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
