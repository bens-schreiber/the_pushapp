import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/token/application/token_provider.dart";
import "package:the_pushapp/token/presentation/background_design.dart";

class TokenBackground extends HookConsumerWidget {
  final Widget child;
  final bool isTokenHolder;
  final bool isInGroup;
  final bool isActiveGroup;
  const TokenBackground(
      {super.key,
      required this.child,
      required this.isActiveGroup,
      required this.isInGroup,
      required this.isTokenHolder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    final fadeController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    final rotationAnimation =
        useAnimation(Tween<double>(begin: 0, end: 5 * 3.14).animate(
      CurvedAnimation(parent: rotationController, curve: Curves.decelerate),
    ));

    useEffect(() {
      fadeController.forward();

      // On a new active group, reset so we can animate again
      if (isInGroup && isActiveGroup) {
        rotationController.reset();
      }

      rotationController.forward();

      // On rotation complete, signal the token loading animation is done
      rotationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          ref.read(tokenLoadingAnimationStateProvider.notifier).state = false;
        }
      });
      return null;
    }, [isInGroup, isActiveGroup]);

    final token = FadeTransition(
        opacity: fadeController,
        child: Transform(
          transform: Matrix4.rotationY(rotationAnimation),
          alignment: FractionalOffset.center,
          child: child,
        ));

    return AnimatedBackgroundDesign(
        animate: isActiveGroup || isTokenHolder,
        background: isTokenHolder,
        child: token);
  }
}
