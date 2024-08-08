import "package:flutter/material.dart";
import "package:the_pushapp/util.dart";
import "package:url_launcher/url_launcher.dart";

class HelpButton extends StatelessWidget {
  const HelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    open() async {
      final uri = Uri(scheme: "https", host: "www.bmin-schreib.com");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }

    return ListTile(
      onTap: () => useErrorHandle(open, context),
      dense: true,
      leading: const Icon(Icons.question_mark, size: 25),
      title: Text("Help", style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
