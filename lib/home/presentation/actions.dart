import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/presentation/account_form.dart";
import "package:the_pushapp/account/presentation/login_form.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/group/presentation/activate_group_form.dart";
import "package:the_pushapp/group/presentation/create_group_form.dart";
import "package:the_pushapp/group/presentation/delete_group_form.dart";
import "package:the_pushapp/group/presentation/display_group_members.dart";
import "package:the_pushapp/group/presentation/components/group_code_button.dart";
import "package:the_pushapp/group/presentation/leave_group_form.dart";
import "package:the_pushapp/notifications/presentation/require_notifications.dart";
import "package:the_pushapp/common.dart";
import "package:the_pushapp/token/presentation/increment_token_button.dart";

class ActionsDisplay extends StatelessWidget {
  const ActionsDisplay({super.key});

  @override
  Widget build(BuildContext context) => RequireNotifications(
        child: Loader(
          loaders: [
            isAuthenticatedProviderAsync,
            accountProviderAsync,
            groupProviderAsync
          ],
          child: const _ActionsDisplay(),
        ),
      );
}

class _ActionsDisplay extends ConsumerWidget {
  const _ActionsDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final group = ref.watch(groupProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

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
        if (group == null && account != null) const CreateGroupForm(),
        if (group != null)
          Container(
            constraints: const BoxConstraints(maxHeight: 100),
            child: const GroupMembers(),
          ),

        if (isGroupAdmin) ...[
          const CopyGroupCodeButton(),
          const DeleteGroupForm(),
          if (!group.isActive) const ActivateGroupForm(),
        ],

        if (group != null && !isGroupAdmin) const LeaveGroupForm(),

        // Token
        if (isTokenHolder) const IncrementTokenButton()
      ],
    );
  }
}
