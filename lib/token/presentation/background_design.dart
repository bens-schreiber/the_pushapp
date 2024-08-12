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

    final controller = useAnimationController();

    final sizeAnimation =
        useAnimation(Tween<double>(begin: 0, end: 20).animate(controller));

    p(double percent) => (screenWidth * percent);

    useEffect(() {
      controller.duration = Duration(seconds: background ? 2 : 4);

      if (animate) {
        controller.repeat(reverse: true);
      }

      if (!animate) {
        controller.reset();
      }

      return null;
    }, [animate, background]);

    final opacity = background ? 0.25 : 1.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleDesign(
            opacity: opacity,
            diameter: p(1.3) + (sizeAnimation + p(0.4)),
            border: border,
            background: background),
        CircleDesign(
            opacity: opacity,
            diameter: p(1.3) + sizeAnimation * 1.25,
            border: border,
            background: background),
        CircleDesign(
          opacity: opacity,
          diameter: p(0.9) + (sizeAnimation) * 1.75,
          border: border,
          background: background,
        ),
        CircleDesign(
          opacity: opacity,
          diameter: p(0.7) + (sizeAnimation) * 1.1,
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
            color: background ? Theme.of(context).colorScheme.primary : null,
            border: border
                ? Border.all(color: Theme.of(context).focusColor, width: 3)
                : null,
          ),
        ),
      ),
    );
  }
}
