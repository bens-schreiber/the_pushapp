import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/home/application/home_provider.dart";
import "package:the_pushapp/home/presentation/components/background_design.dart";

class TokenBackground extends HookConsumerWidget {
  final Widget child;
  const TokenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verticalController = useAnimationController(
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    final rotationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    final fadeController = useAnimationController(
      duration: const Duration(milliseconds: 750),
    );

    final verticalAnimation =
        useAnimation(Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: verticalController, curve: Curves.easeInOut),
    ));

    final rotationAnimation =
        useAnimation(Tween<double>(begin: 0, end: 5 * 3.14).animate(
      CurvedAnimation(parent: rotationController, curve: Curves.decelerate),
    ));

    fadeController.forward();
    rotationController.forward();
    rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(loadingAnimationStateProvider.notifier).state = true;
      }
    });

    return BackgroundDesign(
      child: FadeTransition(
          opacity: fadeController,
          child: Transform.translate(
            offset: Offset(0, verticalAnimation),
            child: Transform(
              transform: Matrix4.rotationY(rotationAnimation),
              alignment: FractionalOffset.center,
              child: child,
            ),
          )),
    );
  }
}
