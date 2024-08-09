import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/home/application/home_provider.dart";

class SlidingBottomSheet extends HookConsumerWidget {
  final Widget minimizedChild;
  final Widget expandedChild;
  const SlidingBottomSheet(
      {super.key, required this.minimizedChild, required this.expandedChild});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doneLoading = ref.watch(loadingAnimationStateProvider);
    final locked = ref.watch(lockSlidingBottomSheetProvider);

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );

    final animation = useAnimation(
      Tween<double>(begin: 0, end: 300).animate(controller),
    );

    useEffect(() {
      if (doneLoading) {
        controller.forward();
      }
      return null;
    }, [doneLoading]);

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
                width: 100,
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

    sheet() => Card(
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

    return SizedBox(
      height: 150 + animation,
      width: double.infinity,
      child: sheet(),
    );
  }
}
