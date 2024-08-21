import "package:flutter/material.dart";
import "package:the_pushapp/account/presentation/signout_button.dart";
import "package:the_pushapp/home/presentation/components/bminschreib.dart";

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        offset: const Offset(0, 50),
        icon: const Icon(
          Icons.settings,
          size: 30,
          color: Colors.white,
        ),
        itemBuilder: (menuContext) {
          return [
            PopupMenuItem(
              child: SignoutButton(onTap: () {
                if (!menuContext.mounted) return;
                Navigator.of(menuContext).pop();
              }),
            ),
            PopupMenuItem(child: HelpButton(onTap: () {
              if (!menuContext.mounted) return;
              Navigator.of(menuContext).pop();
            })),
          ];
        });
  }
}
