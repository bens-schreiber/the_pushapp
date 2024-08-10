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
/// Once all loaders are done loading, [SizedBox.shrink()] is displayed
class FutureLoader extends StatelessWidget {
  final List<ValueNotifier<Future<Object?>?>> loaders;
  final Widget onLoading;
  const FutureLoader(
      {required this.loaders,
      this.onLoading = const LinearProgressIndicator(),
      super.key});

  /// Assign the future to a notifier and await it
  /// [flickerDelay] will add a delay to the loading time to prevent the bar flickering
  static Future<T> load<T>(Future<T> future, ValueNotifier<Future<T>?> notifier,
      {bool flickerDelay = true}) async {
    notifier.value = () async {
      final time = DateTime.now();
      await future;
      final diff = DateTime.now().difference(time).inMilliseconds;
      if (flickerDelay && diff < 500) {
        await Future.delayed(Duration(milliseconds: 500 - diff));
      }
      return future;
    }();
    await notifier.value;
    return future;
  }

  @override
  Widget build(BuildContext context) {
    loaders.removeWhere((loader) => loader.value == null);
    if (loaders.isEmpty) {
      return const SizedBox.shrink();
    }

    final futures = loaders.map((loader) => loader.value!).toList();

    return FutureBuilder(
        future: Future.wait(futures),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const SizedBox.shrink();
          }

          return onLoading;
        });
  }
}

/// Shows a loading widget while the loaders are loading.
/// Once all loaders are done loading, [child] is displayed.
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
    action() => inErrorHandler(onPressed, context);
    return TextButton(
      onPressed: action,
      child: child,
    );
  }
}
