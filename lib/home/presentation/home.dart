import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/account/account_provider.dart";
import "package:the_pushapp/group/group_provider.dart";
import "package:the_pushapp/group/presentation/display_group_photos.dart";
import "package:the_pushapp/home/presentation/actions.dart";
import "package:the_pushapp/home/presentation/components/settings_button.dart";
import "package:the_pushapp/token/presentation/token_display.dart";
import "package:the_pushapp/token/token_provider.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final isTokenHolder = ref.watch(isTokenHolderProvider);

    final backgroundColor = isTokenHolder ? Colors.orangeAccent : Colors.black;

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      title: const Text("The Push App", style: TextStyle(color: Colors.white)),
      actions: [
        if (isAuthenticated) const SettingsButton(),
      ],
    );

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: appBar,

        // Main actionable display of the app.
        bottomSheet: const _BottomSheet(),

        // Entirely for app aesthetics
        body: const SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: TokenBackground(),
        ),
      ),
    );
  }
}

class _BottomSheet extends HookConsumerWidget {
  const _BottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inActiveGroup = ref.watch(groupProvider)?.isActive == true;
    final index = useState(0);

    const actions = Card(
      elevation: 0,
      child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
            child: ActionsDisplay(),
          )),
    );

    final appBar = SizedBox(
      height: 50,
      width: double.infinity,
      child: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.group,
                size: 30,
              ),
              onPressed: () => index.value = 0,
            ),
            IconButton(
              icon: const Icon(Icons.photo_album, size: 30),
              onPressed: () => index.value = 1,
            ),
          ],
        ),
      ),
    );

    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: index.value == 0 ? 350 : size.height,
      child: Stack(
        children: [
          Center(
            child: index.value == 0 ? actions : const GroupPhotosDisplay(),
          ),
          if (inActiveGroup)
            Positioned(bottom: 0, width: size.width, child: appBar),
        ],
      ),
    );
  }
}
