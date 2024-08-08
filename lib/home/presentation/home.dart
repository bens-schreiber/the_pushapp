import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/presentation/signout_button.dart";
import "package:the_pushapp/home/application/home_provider.dart";
import "package:the_pushapp/home/presentation/actions.dart";
import "package:the_pushapp/home/presentation/components/bminschreib.dart";
import "package:the_pushapp/home/presentation/components/token.dart";
import "package:the_pushapp/home/presentation/components/sliding_bottom_sheet.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationComplete = ref.watch(loadingAnimationStateProvider);
    final loadingAsync = ref.watch(loadingScreenProviderAsync);

    final sheetEnabled = animationComplete && loadingAsync.value == true;

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
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              child: SignoutButton(),
            ),
            const PopupMenuItem(child: HelpButton())
          ];
        });

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: settingsButton,
          ),
        ],
      ),
      bottomSheet: IgnorePointer(
        ignoring: !sheetEnabled,
        child: const SlidingBottomSheet(
          minimizedChild: SizedBox.shrink(),
          expandedChild: ActionsDisplay(),
        ),
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
