import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

bool isLoading(List<AsyncValue> asyncValues) {
  return asyncValues.any((asyncValue) => asyncValue.isLoading);
}

/// Shows a loading widget while the loaders are loading
class Loader extends ConsumerWidget {
  final Widget child;
  final Widget onLoading;
  final List<ProviderBase<AsyncValue<Object?>>> loaders;
  const Loader(
      {required this.child,
      required this.loaders,
      this.onLoading = const LinearProgressIndicator(),
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValues = loaders.map((l) => ref.watch(l)).toList();
    return isLoading(asyncValues) ? onLoading : child;
  }
}
