import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/home/application/home_provider.dart";
import "package:the_pushapp/home/presentation/components/background_design.dart";

class TokenBackground extends ConsumerStatefulWidget {
  final Widget child;
  const TokenBackground({super.key, required this.child});

  @override
  ConsumerState<TokenBackground> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends ConsumerState<TokenBackground>
    with TickerProviderStateMixin {
  late AnimationController _verticalController;
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _verticalAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _verticalController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);

    _verticalAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _verticalController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 5 * 3.14).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.decelerate),
    );

    _fadeController.forward();
    _rotationController.forward();
    _rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(loadingAnimationStateProvider.notifier).state = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundDesign(
      child: AnimatedBuilder(
        animation: Listenable.merge([_verticalAnimation, _rotationAnimation]),
        builder: (context, child) {
          return FadeTransition(
              opacity: _fadeController,
              child: Transform.translate(
                offset: Offset(0, _verticalAnimation.value),
                child: Transform(
                  transform: Matrix4.rotationY(_rotationAnimation.value),
                  alignment: FractionalOffset.center,
                  child: widget.child,
                ),
              ));
        },
      ),
    );
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}
