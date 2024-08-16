import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/token/application/token_provider.dart";
import "package:the_pushapp/token/presentation/background_design.dart";

class TokenLogo extends ConsumerWidget {
  final int? token;
  final double rotation;
  const TokenLogo({super.key, required this.token, required this.rotation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenLoading = ref.watch(tokenLoadingProviderAsync).isLoading;

    final logo = !tokenLoading && token != null
        ? Text(
            (token).toString(),
            style: const TextStyle(color: Colors.white, fontSize: 100),
          )
        : Padding(
            padding: const EdgeInsets.all(25.0),
            child: Image.asset("assets/logo.png", color: Colors.white),
          );

    final r = rotation % (2 * pi);
    final isBack = r > pi / 2 && r < 3 * pi / 2;

    return Container(
      width: 225.0,
      height: 225.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 10,
        ),
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
      child: !isBack
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: tokenLoading ? null : logo,
            )
          : null,
    );
  }
}

class TokenBackground extends HookWidget {
  final bool isTokenHolder;
  final bool isInGroup;
  final bool isActiveGroup;
  final int? token;
  const TokenBackground(
      {super.key,
      required this.isActiveGroup,
      required this.isInGroup,
      required this.isTokenHolder,
      required this.token});

  @override
  Widget build(BuildContext context) {
    final rotationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    final fadeController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    final rotationAnimation =
        useAnimation(Tween<double>(begin: 0, end: 4 * pi).animate(
      CurvedAnimation(parent: rotationController, curve: Curves.decelerate),
    ));

    useEffect(() {
      fadeController.forward();

      // On a new active group, reset so we can animate again
      if (isInGroup && isActiveGroup) {
        rotationController.reset();
      }

      rotationController.forward();
      return null;
    }, [isInGroup, isActiveGroup]);

    final logo = FadeTransition(
        opacity: fadeController,
        child: Transform(
          transform: Matrix4.rotationY(rotationAnimation),
          alignment: FractionalOffset.center,
          child: TokenLogo(token: token, rotation: rotationAnimation),
        ));

    return Padding(
      padding: const EdgeInsets.only(bottom: 150),
      child: AnimatedBackgroundDesign(
          animate: isActiveGroup || isTokenHolder,
          background: isTokenHolder,
          child: logo),
    );
  }
}
