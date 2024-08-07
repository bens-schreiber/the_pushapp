import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/presentation/account_display.dart";
import "package:the_pushapp/account/presentation/account_form.dart";
import "package:the_pushapp/account/presentation/login_form.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/group/presentation/create_group_form.dart";
import "package:the_pushapp/group/presentation/group_display.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/util.dart";

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.read(clientProvider);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: client.auth.signOut,
          child: const Icon(Icons.logout),
        ),
        body: Loader(
          loaders: [
            isAuthenticatedProviderAsync,
            accountProviderAsync,
            groupProviderAsync
          ],
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: HomeDisplay(),
            ),
          ),
        ));
  }
}

class HomeDisplay extends ConsumerWidget {
  const HomeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final account = ref.watch(accountProvider);
    final group = ref.watch(groupProvider);

    return Column(
      children: [
        if (!isAuthenticated) const LoginForm(),
        if (account == null && isAuthenticated) const AccountForm(),
        if (account != null) const AccountDisplay(),
        const SizedBox(height: 20),
        if (group == null && account != null) const CreateGroupForm(),
        if (group != null) const GroupDisplay(),
      ],
    );
  }
}
