import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/presentation/account_form.dart";
import "package:the_pushapp/account/presentation/login_form.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/group/presentation/activate_group_button.dart";
import "package:the_pushapp/group/presentation/create_group_button.dart";
import "package:the_pushapp/group/presentation/delete_group_button.dart";
import "package:the_pushapp/group/presentation/display_group_members.dart";
import "package:the_pushapp/group/presentation/group_code_button.dart";
import "package:the_pushapp/notifications/presentation/require_notifications.dart";
import "package:the_pushapp/supabase_provider.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/token/presentation/increment_token_button.dart";

class ActionsDisplay extends StatelessWidget {
  const ActionsDisplay({super.key});

  @override
  Widget build(BuildContext context) => RequireNotifications(
        child: Loader(
          hide: true,
          loaders: [
            isAuthenticatedProviderAsync,
            accountProviderAsync,
            groupProviderAsync
          ],
          child: const Center(
            child: _ActionsDisplay(),
          ),
        ),
      );
}

class _ActionsDisplay extends ConsumerWidget {
  const _ActionsDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.read(clientProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final account = ref.watch(accountProvider);
    final group = ref.watch(groupProvider);

    final isGroupAdmin = group != null && group.adminUserId == account?.id;
    final isTokenHolder = group != null && group.tokenUserId == account?.id;

    return Column(
      children: [
        // Login
        if (!isAuthenticated) const LoginForm(),

        // Account
        if (account == null && isAuthenticated) ...[
          const AccountForm(),
          const SizedBox(height: 20),
        ],

        // Groups
        if (group == null && account != null) ...[
          Text("Find your friends!",
              style: Theme.of(context).textTheme.headlineLarge),
          Text("Accept an invite or create a group to get started.",
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 25),
          const CreateGroupButton(),
        ],
        if (group != null) ...[
          const CopyGroupCodeButton(),
          const SizedBox(
            height: 100,
            child: GroupMembers(),
          ),
        ],

        if (isGroupAdmin) ...[
          DeleteGroupButton(groupId: group.id),
          if (!group.isActive) ActivateGroupButton(groupId: group.id)
        ],

        // Token
        if (isTokenHolder)
          IncrementTokenButton(client: client, token: group.token),
      ],
    );
  }
}
