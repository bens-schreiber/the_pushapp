import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/token/application/token_provider.dart";

class InfoDisplay extends ConsumerWidget {
  const InfoDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final group = ref.watch(groupProvider);
    final groupMembers = ref.watch(groupMembersProvider);
    final isLoading = ref.watch(tokenLoadingAnimationStateProvider);
    if (account == null || group == null || isLoading || groupMembers.isEmpty) {
      return const Padding(
          padding: EdgeInsets.all(8), child: LinearProgressIndicator());
    }

    final admin =
        groupMembers.firstWhere((member) => member.id == group.adminUserId);

    final accountTitle = "${account.firstName} ${account.lastName}";
    final accountSubtitle = account.id == group.adminUserId
        ? "Group Creator"
        : "${admin.firstName} ${admin.lastName}'s Group";

    final groupTitle =
        "${groupMembers.length} member${groupMembers.length > 1 ? "s" : ""}";
    final groupSubtitle = group.isActive ? "Active" : "Inactive";

    return Table(
      children: [
        TableRow(
          children: [
            ListTile(
                leading: const Icon(Icons.person, size: 25),
                title: Text(accountTitle),
                subtitle: Text(accountSubtitle)),
            ListTile(
                leading: const Icon(Icons.group, size: 25),
                title: Text(groupTitle),
                subtitle: Text(groupSubtitle)),
          ],
        ),
      ],
    );
  }
}
