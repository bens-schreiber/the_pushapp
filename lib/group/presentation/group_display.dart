import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/group/application/group_provider.dart";

class GroupDisplay extends ConsumerWidget {
  const GroupDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider);
    return Text(group.toString());
  }
}
