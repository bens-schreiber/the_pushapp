import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/presentation/account_form.dart";
import "package:the_pushapp/account/presentation/login_form.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/group/presentation/activate_group_button.dart";
import "package:the_pushapp/group/presentation/create_group_button.dart";
import "package:the_pushapp/group/presentation/delete_group_button.dart";
import "package:the_pushapp/group/presentation/join_group_form.dart";
import "package:the_pushapp/notifications/application/notifications_provider.dart";
import "package:the_pushapp/notifications/presentation/require_notifications.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/token/presentation/increment_token_button.dart";

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: RequireNotifications(
            child: Loader(
              loaders: [
                isAuthenticatedProviderAsync,
                accountProviderAsync,
                groupProviderAsync
              ],
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100, left: 10, right: 10),
                  child: HomeDisplay(),
                ),
              ),
            ),
          ),
        ),
      );
}

class HomeDisplay extends ConsumerWidget {
  const HomeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.read(clientProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final account = ref.watch(accountProvider);
    final group = ref.watch(groupProvider);

    final isGroupAdmin = group != null && group.adminUserId == account?.id;
    final isTokenHolder = group != null && group.tokenUserId == account?.id;

    final fab = FloatingActionButton(
      onPressed: client.auth.signOut,
      child: const Icon(Icons.logout),
    );

    final accountForm = AccountForm(
      client: client,
      getNewFcm: () async => await ref.read(fcmTokenProvider.future),
    );

    return Column(
      children: [
        // Login
        if (!isAuthenticated) LoginForm(auth: client.auth),

        // Account
        if (account == null && isAuthenticated) accountForm,
        if (account != null) AsyncValueDisplay(data: accountProviderAsync),
        const SizedBox(height: 20),

        // Groups
        if (group == null && account != null) ...[
          CreateGroupButton(client: client),
          JoinGroupForm(client: client)
        ],
        if (group != null) AsyncValueDisplay(data: groupProviderAsync),
        if (isGroupAdmin) ...[
          DeleteGroupButton(client: client, groupId: group.id),
          if (!group.isActive)
            ActivateGroupButton(client: client, groupId: group.id)
        ],
        const SizedBox(height: 20),

        // Token
        if (isTokenHolder)
          IncrementTokenButton(client: client, token: group.token),

        // Logout
        if (isAuthenticated) fab
      ],
    );
  }
}
