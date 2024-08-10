import "package:flutter/material.dart";
import "package:the_pushapp/util.dart";
import "package:url_launcher/url_launcher.dart";

class HelpButton extends StatelessWidget {
  final Function onTap;
  const HelpButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    open() async {
      final uri = Uri(scheme: "https", host: "www.bmin-schreib.com");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
      onTap();
    }

    return ListTile(
      onTap: () => inErrorHandler(open, context),
      dense: true,
      leading: const Icon(Icons.question_mark, size: 25),
      title: Text("Help", style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
