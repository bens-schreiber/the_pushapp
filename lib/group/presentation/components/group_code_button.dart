import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/group/application/group_provider.dart";

class CopyGroupCodeButton extends ConsumerWidget {
  const CopyGroupCodeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider);
    final code = "https://bmin-schreib.com/pushapp?invite=${group?.id}";

    copyClipboard() async {
      await Clipboard.setData(ClipboardData(text: code));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Copied invitation link to clipboard")),
      );
    }

    return ListTile(
      onTap: copyClipboard,
      dense: true,
      leading: const Icon(Icons.copy, size: 25),
      title: const Text("Copy Group Code", style: TextStyle(fontSize: 16)),
    );
  }
}
