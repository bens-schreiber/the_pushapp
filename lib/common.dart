import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:the_pushapp/util.dart";

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
class Loader extends HookConsumerWidget {
  final Widget child;
  final Widget onLoading;
  final List<ProviderBase<AsyncValue<Object?>>> loaders;
  final bool loadOnce;
  final bool hide;
  const Loader(
      {required this.child,
      required this.loaders,
      this.onLoading = const LinearProgressIndicator(),
      this.loadOnce = true,
      this.hide = false,
      super.key});

  bool isLoading(List<AsyncValue> asyncValues) {
    return asyncValues.any((asyncValue) => asyncValue.isLoading);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaded = useState(false);
    if (loaded.value && loadOnce) {
      return child;
    }

    final asyncValues = loaders.map((l) => ref.watch(l)).toList();
    final finishedLoading = !isLoading(asyncValues);
    loaded.value = loaded.value || finishedLoading;
    return finishedLoading
        ? child
        : hide
            ? const SizedBox.shrink()
            : onLoading;
  }
}

/// Handles error via a snackbar
class HandleButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  const HandleButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    action() => useErrorHandle(onPressed, context);
    return TextButton(
      onPressed: action,
      child: child,
    );
  }
}
