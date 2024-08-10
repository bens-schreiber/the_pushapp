import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/application/account_provider.dart";
import "package:the_pushapp/account/presentation/signout_button.dart";
import "package:the_pushapp/group/application/group_provider.dart";
import "package:the_pushapp/home/application/home_provider.dart";
import "package:the_pushapp/home/presentation/actions.dart";
import "package:the_pushapp/home/presentation/components/bminschreib.dart";
import "package:the_pushapp/token/application/token_provider.dart";
import "package:the_pushapp/token/presentation/token.dart";
import "package:the_pushapp/home/presentation/components/sliding_bottom_sheet.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockSlidingBottomSheet = ref.watch(lockSlidingBottomSheetProvider);
    final finishedLoading = !ref.watch(tokenLoadingAnimationStateProvider);
    final group = ref.watch(groupProvider);

    final inGroup = group != null;
    final inActiveGroup = group?.isActive == true;
    final isAuth = ref.watch(isAuthenticatedProvider);
    final isTokenHolder = ref.watch(isTokenHolderProvider);

    final logoPlaceholder = Container(
      width: 225.0,
      height: 225.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).buttonTheme.colorScheme?.primary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).buttonTheme.colorScheme!.shadow,
            blurRadius: 10,
            spreadRadius: 0.05,
          ),
        ],
      ),
    );

    final settingsButton = PopupMenuButton(
        enabled: isAuth,
        offset: const Offset(0, 50),
        icon: const Icon(Icons.settings, size: 30),
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

    final sheet = SlidingBottomSheet(
      finishedLoading: finishedLoading,
      isInActiveGroup: inActiveGroup,
      locked: lockSlidingBottomSheet,
      minimizedChild: const SizedBox.shrink(),
      expandedChild: const ActionsDisplay(),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("The Push App"),
        actions: [
          if (isAuth) settingsButton,
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
          child: logoPlaceholder,
        ),
      ),
    );
  }
}
