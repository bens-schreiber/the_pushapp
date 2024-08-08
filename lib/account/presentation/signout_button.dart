import "package:flutter/widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/supabase_provider.dart";

class SignoutButton extends ConsumerWidget {
  const SignoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    signOut() async {
      final client = ref.read(clientProvider);

      final id = client.auth.currentUser!.id;
      await client.auth.signOut();
      await client.from("Users").update({"fcm": null}).eq("id", id);

      ref.invalidate(accountProviderAsync);
    }

    return HandleButton(onPressed: signOut, child: const Text("Sign Out"));
  }
}
