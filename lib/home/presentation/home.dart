import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/presentation/account_form.dart";
import "package:the_pushapp/account/presentation/login_form.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/group/presentation/create_group_form.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/common.dart";

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          bottom: false,
          child: Loader(
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
          )));
}

class HomeDisplay extends ConsumerWidget {
  const HomeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(clientProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final account = ref.watch(accountProvider);
    final group = ref.watch(groupProvider);

    final fab = FloatingActionButton(
        onPressed: client.auth.signOut, child: const Icon(Icons.logout));

    final accountDisplay = AsyncValueDisplay(data: accountProviderAsync);
    final groupDisplay = AsyncValueDisplay(data: groupProviderAsync);

    return Column(
      children: [
        // Login
        if (!isAuthenticated) const LoginForm(),

        // Account
        if (account == null && isAuthenticated) const AccountForm(),
        if (account != null) accountDisplay,
        const SizedBox(height: 20),

        // Groups
        if (group == null && account != null) const CreateGroupForm(),
        if (group != null) groupDisplay,
        const SizedBox(height: 20),

        // Logout
        if (isAuthenticated) fab
      ],
    );
  }
}
