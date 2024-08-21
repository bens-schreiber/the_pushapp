import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/freezed/account.dart";
import "package:the_pushapp/group/group_provider.dart";

class GroupMembers extends ConsumerWidget {
  const GroupMembers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupMembers = ref.read(groupMembersProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final member in groupMembers) _MemberTile(account: member)
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final Account account;
  const _MemberTile({required this.account});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text("${account.firstName} ${account.lastName}"),
    );
  }
}
