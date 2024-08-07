import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Displays the value of an [AsyncValue] provider in a widget
///
/// If [child] is not provided, the value will be displayed in a [Text] widget
///
/// If the [AsyncValue] has an error, the error will be displayed in a [Text] widget
class AsyncValueDisplay extends ConsumerWidget {
  final ProviderBase<AsyncValue<Object?>> data;
  final Widget? child;
  const AsyncValueDisplay({required this.data, this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(data);
    if (asyncValue.hasError) {
      return Text("Error: ${asyncValue.error}");
    }

    if (asyncValue.isLoading && !asyncValue.hasValue) {
      return const SizedBox.shrink();
    }

    return child ?? Text(asyncValue.value?.toString() ?? "null");
  }
}

/// Shows a loading widget while the loaders are loading
class Loader extends ConsumerStatefulWidget {
  final Widget child;
  final Widget onLoading;
  final List<ProviderBase<AsyncValue<Object?>>> loaders;
  final bool loadOnce;
  const Loader(
      {required this.child,
      required this.loaders,
      this.onLoading = const LinearProgressIndicator(),
      this.loadOnce = true,
      super.key});

  @override
  ConsumerState<Loader> createState() => _LoaderState();
}

class _LoaderState extends ConsumerState<Loader> {
  bool isLoading(List<AsyncValue> asyncValues) {
    return asyncValues.any((asyncValue) => asyncValue.isLoading);
  }

  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    if (loaded && widget.loadOnce) {
      return widget.child;
    }

    final asyncValues = widget.loaders.map((l) => ref.watch(l)).toList();
    final finishedLoading = !isLoading(asyncValues);
    loaded = loaded || finishedLoading;
    return finishedLoading ? widget.child : widget.onLoading;
  }
}
