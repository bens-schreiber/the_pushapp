import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:the_pushapp/home/application/home_provider.dart";

class SlidingBottomSheet extends ConsumerStatefulWidget {
  final Widget minimizedChild;
  final Widget expandedChild;
  const SlidingBottomSheet(
      {super.key, required this.minimizedChild, required this.expandedChild});

  @override
  ConsumerState<SlidingBottomSheet> createState() => _SlidingBottomSheetState();
}

class _SlidingBottomSheetState extends ConsumerState<SlidingBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 300).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final doneLoading = ref.watch(loadingAnimationStateProvider);
    if (doneLoading) {
      _controller.forward();
    }

    onTap() {
      if (_controller.isAnimating) return;
      _controller.isCompleted ? _controller.reverse() : _controller.forward();
    }

    onPanUpdate(details) {
      if (_controller.isAnimating) return;
      if (details.delta.dy > 0 && _controller.isCompleted) {
        _controller.reverse();
      }
      if (details.delta.dy < 0 && !_controller.isCompleted) {
        _controller.forward();
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
              padding: const EdgeInsets.all(8.0),
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
        color: Theme.of(context).cardTheme.color,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              gestureBar,
              if (!_controller.isAnimating)
                _controller.isCompleted
                    ? widget.expandedChild
                    : widget.minimizedChild,
            ],
          ),
        ));

    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
              height: 150 + _animation.value,
              width: double.infinity,
              child: sheet());
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
