import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class AnimatedBackgroundDesign extends HookWidget {
  final Widget child;
  final bool background;
  final bool animate;
  const AnimatedBackgroundDesign(
      {required this.child,
      required this.background,
      required this.animate,
      super.key});

  @override
  Widget build(BuildContext context) {
    final border = !background;
    final screenWidth = MediaQuery.of(context).size.width;

    final controller = useAnimationController(
      duration: const Duration(seconds: 4),
    );

    final sizeAnimation = useAnimation(Tween<double>(
      begin: 0,
      end: 20,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    ));

    p(double percent) => (screenWidth * percent);

    useEffect(() {
      if (animate) {
        controller.repeat(reverse: true);
      }

      if (!animate) {
        controller.reset();
      }

      return null;
    }, [animate]);

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleDesign(
            opacity: 1, diameter: p(3), border: border, background: background),
        CircleDesign(
            opacity: 0.7,
            diameter: p(1.6) + sizeAnimation * 1.25,
            border: border,
            background: background),
        CircleDesign(
            opacity: 0.7,
            diameter: p(0.7) + (sizeAnimation + p(0.2)) * 3,
            border: border,
            background: background),
        CircleDesign(
          opacity: 0.5,
          diameter: p(1) + (sizeAnimation) * 1.75,
          border: border,
          background: background,
        ),
        CircleDesign(
          opacity: 0.9,
          diameter: p(0.8) + sizeAnimation * 1.5,
          border: border,
          background: background,
        ),
        child,
      ],
    );
  }
}

class CircleDesign extends StatelessWidget {
  final double diameter;
  final double opacity;
  final bool border;
  final bool background;
  const CircleDesign(
      {required this.opacity,
      required this.diameter,
      this.border = true,
      this.background = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: diameter,
      width: diameter,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: background ? Theme.of(context).focusColor : null,
            border: border
                ? Border.all(color: Theme.of(context).focusColor, width: 3)
                : null,
          ),
        ),
      ),
    );
  }
}
