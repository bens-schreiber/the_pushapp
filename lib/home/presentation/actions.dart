import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/account/account_provider.dart";
import "package:the_pushapp/account/presentation/account_form.dart";
import "package:the_pushapp/account/presentation/login_form.dart";
import "package:the_pushapp/common/util.dart";
import "package:the_pushapp/group/group_provider.dart";
import "package:the_pushapp/group/presentation/activate_group_form.dart";
import "package:the_pushapp/group/presentation/create_group_form.dart";
import "package:the_pushapp/group/presentation/delete_group_form.dart";
import "package:the_pushapp/group/presentation/display_group_members.dart";
import "package:the_pushapp/group/presentation/components/group_code_button.dart";
import "package:the_pushapp/group/presentation/leave_group_form.dart";
import "package:the_pushapp/notifications/presentation/require_notifications.dart";
import "package:the_pushapp/common/common.dart";
import "package:the_pushapp/token/token_provider.dart";
import "package:the_pushapp/token/presentation/increment_token_form.dart";

class ActionsDisplay extends StatelessWidget {
  const ActionsDisplay({super.key});

  @override
  Widget build(BuildContext context) => RequireNotifications(
        child: Loader(
          loaders: [
            tokenLoadingProviderAsync,
            isAuthenticatedProviderAsync,
            accountProviderAsync,
            groupProviderAsync,
            groupMembersProviderAsync,
          ],
          child: const _ActionsDisplay(),
        ),
      );
}

class _ActionsDisplay extends HookConsumerWidget {
  const _ActionsDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final account = ref.watch(accountProvider);
    final isTokenHolder = ref.watch(isTokenHolderProvider);
    final group = ref.watch(groupProvider);

    final isGroupAdmin = group != null && group.adminUserId == account?.id;

    useOneTimeDialog(
      title: "Welcome to The PushApp",
      content:
          """PushApp is a simple game where a random user is prompted to do an incrementing amounts of pushups. 
                \n\nTo play, create a group or join one via an invitation code.
                \n\nThis app is currently in alpha testing. Report any bugs you find via the help button.
                """,
      context: context,
      condition: () => account != null,
      keys: [account],
    );

    if (!isAuthenticated) {
      return const LoginForm();
    }

    if (account == null && isAuthenticated) {
      return const AccountForm();
    }

    if (group == null) {
      return const CreateGroupForm();
    }

    if (isTokenHolder) {
      return const IncrementTokenDisplay();
    }

    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 100),
          child: const GroupMembers(),
        ),
        if (isGroupAdmin) ...[
          const CopyGroupCodeButton(),
          const SizedBox(height: 20),
          if (group.isActive != true) const ActivateGroupForm(),
          const SizedBox(height: 20),
          const DeleteGroupForm(),
        ],
        if (!isGroupAdmin) const LeaveGroupForm(),
      ],
    );
  }
}
