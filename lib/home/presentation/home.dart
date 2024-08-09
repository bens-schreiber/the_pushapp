import "package:flutter/material.dart";
import "package:the_pushapp/account/presentation/signout_button.dart";
import "package:the_pushapp/home/presentation/actions.dart";
import "package:the_pushapp/home/presentation/components/bminschreib.dart";
import "package:the_pushapp/home/presentation/components/token.dart";
import "package:the_pushapp/home/presentation/components/sliding_bottom_sheet.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      width: 225.0,
      height: 225.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).buttonTheme.colorScheme?.primary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).buttonTheme.colorScheme!.shadow,
            blurRadius: 8.0,
            spreadRadius: 8.0,
          ),
        ],
      ),
    );

    final settingsButton = PopupMenuButton(
        offset: const Offset(0, 50),
        icon: const Icon(Icons.settings, size: 30),
        itemBuilder: (menuContext) {
          return [
            PopupMenuItem(
              child: SignoutButton(onTap: () {
                Navigator.of(menuContext).pop();
              }),
            ),
            PopupMenuItem(child: HelpButton(onTap: () {
              Navigator.of(menuContext).pop();
            })),
          ];
        });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: settingsButton,
          ),
        ],
      ),
      bottomSheet: const SlidingBottomSheet(
        minimizedChild: SizedBox.shrink(),
        expandedChild: ActionsDisplay(),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: TokenBackground(
              child: logo,
            ),
          ),
        ),
      ),
    );
  }
}
