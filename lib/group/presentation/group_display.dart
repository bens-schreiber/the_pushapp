import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/group/presentation/create_group_form.dart";

class GroupDisplay extends ConsumerWidget {
  const GroupDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider);
    print("Group: $group");
    final inGroup = group != null;
    return inGroup
        ? Text(group.toString())
        : const Column(
            children: [CreateGroupForm()],
          );
  }
}
