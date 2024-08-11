import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/token/application/token_provider.dart";
import "package:the_pushapp/token/presentation/background_design.dart";

class TokenLogo extends StatelessWidget {
  final int? token;
  const TokenLogo({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Text(
          (token ?? "").toString(),
          style: const TextStyle(color: Colors.white, fontSize: 100),
        ),
      ),
    );
  }
}

class TokenBackground extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final rotationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    final fadeController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    final rotationAnimation =
        useAnimation(Tween<double>(begin: 0, end: 4 * 3.14).animate(
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

    final logo = FadeTransition(
        opacity: fadeController,
        child: Transform(
          transform: Matrix4.rotationY(rotationAnimation),
          alignment: FractionalOffset.center,
          child: TokenLogo(token: token),
        ));

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AnimatedBackgroundDesign(
          animate: isActiveGroup || isTokenHolder,
          background: isTokenHolder,
          child: logo),
    );
  }
}
