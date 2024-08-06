import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/presentation/account_form.dart";
import "package:the_pushapp/supabase_provider.dart";

class AccountDisplay extends ConsumerWidget {
  const AccountDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final client = ref.read(clientProvider);

    return account == null
        ? AccountForm(client: client)
        : Text(account.toString());
  }
}
