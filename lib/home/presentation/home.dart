import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/presentation/signout_button.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/home/application/home_provider.dart";
import "package:the_pushapp/home/presentation/actions.dart";
import "package:the_pushapp/home/presentation/components/bminschreib.dart";
import "package:the_pushapp/token/application/token_provider.dart";
import "package:the_pushapp/token/presentation/token_display.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(initializeAppProviderAsync);
    final group = ref.watch(groupProvider);

    final inGroup = group != null;
    final inActiveGroup = group?.isActive == true;
    final isAuth = ref.watch(isAuthenticatedProvider);
    final isTokenHolder = ref.watch(isTokenHolderProvider);

    const sheet = SizedBox(
      height: 300,
      child: Card(
        elevation: 10,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
              padding: EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
              child: ActionsDisplay()),
        ),
      ),
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: isTokenHolder
            ? Theme.of(context).colorScheme.tertiary
            : Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title:
              const Text("The Push App", style: TextStyle(color: Colors.white)),
          actions: [
            if (isAuth) SettingsButton(isAuth: isAuth),
          ],
        ),
        bottomSheet: sheet,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: TokenBackground(
              isInGroup: inGroup,
              isActiveGroup: inActiveGroup,
              isTokenHolder: isTokenHolder,
              token: group?.token),
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final bool isAuth;
  const SettingsButton({super.key, required this.isAuth});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        enabled: isAuth,
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
