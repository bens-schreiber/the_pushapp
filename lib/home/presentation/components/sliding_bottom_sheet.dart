import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SlidingBottomSheet extends HookConsumerWidget {
  final Widget minimizedChild;
  final Widget expandedChild;
  final bool locked;
  final bool finishedLoading;
  final bool isInActiveGroup;
  const SlidingBottomSheet({
    super.key,
    required this.minimizedChild,
    required this.expandedChild,
    required this.locked,
    required this.finishedLoading,
    required this.isInActiveGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );

    final animation = useAnimation(
      Tween<double>(begin: 0, end: 300).animate(controller),
    );

    // After finishing loading, open this menu open if the user is not in a group, which subsequently
    // means if they have no account and haven't been authenticated.
    useEffect(() {
      if (finishedLoading) {
        controller.forward();
      }
      if (isInActiveGroup) {
        controller.reverse();
      }

      return null;
    }, [locked, finishedLoading, isInActiveGroup]);

    return SizedBox(
      height: 200 + animation,
      width: double.infinity,
      child: _SlidingSheet(
        minimizedChild: minimizedChild,
        expandedChild: expandedChild,
        locked: locked,
        controller: controller,
      ),
    );
  }
}

class _SlidingSheet extends StatelessWidget {
  final Widget minimizedChild;
  final Widget expandedChild;
  final bool locked;
  final AnimationController controller;
  const _SlidingSheet(
      {required this.minimizedChild,
      required this.expandedChild,
      required this.locked,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    onTap() {
      if (locked) return;
      if (controller.isAnimating) return;
      !controller.isCompleted ? controller.reverse() : controller.forward();
    }

    onPanUpdate(details) {
      if (locked) return;
      if (controller.isAnimating) return;
      if (details.delta.dy > 0 && controller.isCompleted) {
        controller.reverse();
      }
      if (details.delta.dy < 0 && !controller.isCompleted) {
        controller.forward();
      }
    }

    final gestureBar = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      onPanUpdate: onPanUpdate,
      // hack to expand the gesture area
      child: Stack(
        children: [
          const SizedBox(
            height: 50,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 5,
                width: 200,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColorLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Card(
        elevation: 10,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              gestureBar,
              if (!controller.isAnimating)
                controller.isCompleted ? expandedChild : minimizedChild,
            ],
          ),
        ));
  }
}
