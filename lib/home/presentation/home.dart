import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/account/account_provider.dart";
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

    const sheet = SizedBox(
      height: 300,
      child: Card(
        elevation: 10,
        child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
              child: ActionsDisplay(),
            )),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: appBar,

      // Main actionable display of the app.
      bottomSheet: sheet,

      // Entirely for app aesthetics
      body: const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: TokenBackground(),
      ),
    );
  }
}
