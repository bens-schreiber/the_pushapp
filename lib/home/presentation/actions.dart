import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/account_provider.dart";
import "package:the_pushapp/account/presentation/account_form.dart";
import "package:the_pushapp/account/presentation/login_form.dart";
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

class _ActionsDisplay extends ConsumerWidget {
  const _ActionsDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final account = ref.watch(accountProvider);
    final isTokenHolder = ref.watch(isTokenHolderProvider);
    final group = ref.watch(groupProvider);

    final isGroupAdmin = group != null && group.adminUserId == account?.id;

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
          const DeleteGroupForm(),
          if (group.isActive != true) const ActivateGroupForm(),
        ],
        if (!isGroupAdmin) const LeaveGroupForm(),
      ],
    );
  }
}
